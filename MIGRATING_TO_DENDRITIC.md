# Migrating To The Current Dendritic Layout

This guide describes the migration model used by the `fix/dendritic-restructure` branch.

The current layout is no longer based on `flake.modules.nixos.*` and `flake.modules.homeManager.*`. Feature modules are now ordinary NixOS and Home Manager modules that are auto-imported from their module roots.

## Target Layout

```text
.
├── flake.nix
├── hosts/
│   └── hallnet/
│       ├── default.nix
│       ├── configuration.nix
│       ├── home.nix
│       └── hardware-configuration.nix
├── modules/
│   ├── nixos/
│   │   ├── default.nix
│   │   ├── desktop/
│   │   ├── services/
│   │   └── system/
│   └── home-manager/
│       ├── default.nix
│       ├── cli/
│       ├── desktop/
│       ├── editors/
│       ├── terminal/
│       └── user/
├── config/
└── pkgs/
```

## Main Idea

The migration separates three concerns:

- `flake.nix` defines inputs and imports host entry points.
- `hosts/<name>/` decides what a machine and user enable.
- `modules/` contains reusable feature modules.

The host should mostly enable options. The modules should contain the implementation.

## Step 1. Thin Out `flake.nix`

The flake should import the host entry point:

```nix
imports = [
  ./hosts/hallnet
];
```

It should not manually import every feature module.

## Step 2. Split The Host Directory

Use three host files:

```text
hosts/hallnet/default.nix
hosts/hallnet/configuration.nix
hosts/hallnet/home.nix
```

Responsibilities:

- `default.nix`: creates `flake.nixosConfigurations.hallnet`.
- `configuration.nix`: imports hardware and enables NixOS feature flags.
- `home.nix`: sets Home Manager identity and enables user feature flags.

## Step 3. Auto-Import NixOS Modules

Use `modules/nixos/default.nix` to import all NixOS modules under `modules/nixos`.

Feature modules should be ordinary NixOS modules:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.system.core.enable =
    lib.mkEnableOption "Enable core system configuration";

  config = lib.mkIf config.hallwack.system.core.enable {
    networking.networkmanager.enable = true;
  };
}
```

The host imports the module root:

```nix
modules = [
  ./configuration.nix
  ../../modules/nixos
];
```

## Step 4. Auto-Import Home Manager Modules

Use `modules/home-manager/default.nix` to import all Home Manager modules under `modules/home-manager`.

Feature modules should be ordinary Home Manager modules:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.cli.git.enable =
    lib.mkEnableOption "Enable Git configuration";

  config = lib.mkIf config.hallwack.cli.git.enable {
    programs.git.enable = true;
  };
}
```

The host passes the module root to Home Manager:

```nix
home-manager.sharedModules = [
  ../../modules/home-manager
];
```

## Step 5. Move Activation To Host Files

System activation belongs in:

```text
hosts/hallnet/configuration.nix
```

Example:

```nix
hallwack.system.core.enable = true;
hallwack.system.audio.enable = true;
hallwack.services.openssh.enable = true;
hallwack.desktop.niri.enable = true;
```

User activation belongs in:

```text
hosts/hallnet/home.nix
```

Example:

```nix
hallwack.user.enable = true;
hallwack.cli.git.enable = true;
hallwack.cli.shell.enable = true;
hallwack.editors.neovim.enable = true;
hallwack.desktop.niri.enable = true;
```

## Step 6. Map Old Modules To New Locations

Old locations:

```text
modules/system/nixos/
modules/home/common/
modules/home/linux/
```

New locations:

```text
modules/nixos/system/
modules/nixos/services/
modules/nixos/desktop/
modules/home-manager/user/
modules/home-manager/cli/
modules/home-manager/editors/
modules/home-manager/terminal/
modules/home-manager/desktop/
```

Example mapping:

```text
modules/system/nixos/base.nix              -> modules/nixos/system/core.nix
modules/system/nixos/audio.nix             -> modules/nixos/system/audio.nix
modules/system/nixos/bluetooth.nix         -> modules/nixos/system/bluetooth.nix
modules/system/nixos/user-hallwack.nix     -> modules/nixos/system/users.nix
modules/system/nixos/desktop-gnome.nix     -> modules/nixos/desktop/gnome.nix
modules/system/nixos/desktop-niri.nix      -> modules/nixos/desktop/niri.nix
modules/home/common/user-hallwack.nix      -> modules/home-manager/user/hallwack.nix
modules/home/common/git.nix                -> modules/home-manager/cli/git.nix
modules/home/common/shell.nix              -> modules/home-manager/cli/shell.nix
modules/home/common/neovim/default.nix     -> modules/home-manager/editors/neovim.nix
modules/home/common/ghostty/default.nix    -> modules/home-manager/terminal/ghostty.nix
modules/home/common/kitty/default.nix      -> modules/home-manager/terminal/kitty.nix
modules/home/linux/niri/default.nix        -> modules/home-manager/desktop/niri.nix
modules/home/linux/noctalia/default.nix    -> modules/home-manager/desktop/noctalia.nix
```

## Step 7. Keep Package Ownership Clear

Use these ownership rules:

- NixOS packages required by services or the OS go in `environment.systemPackages`.
- User packages go in `home.packages`.
- Dotfiles go in `config/` and are linked from Home Manager modules.
- Language toolchains should have their own `modules/home-manager/cli/<runtime>.nix`.
- App config should be owned by the app module.

## Common Migration Mistakes

### Importing Non-Modules

Because `modules/nixos/default.nix` and `modules/home-manager/default.nix` auto-import recursively, every `.nix` file under those trees must be a valid module unless excluded.

Use `_` directories for helpers:

```text
modules/home-manager/_lib/
modules/nixos/_lib/
```

### Putting `imports` Inside `config`

Module imports belong at module top-level:

```nix
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = lib.mkIf cfg.enable {
    ...
  };
}
```

Do not put `imports` inside `config = lib.mkIf ...`.

### Mixing NixOS And Home Manager Options

These belong in NixOS modules:

```nix
services.openssh.enable
programs.niri.enable
environment.systemPackages
users.users
```

These belong in Home Manager modules:

```nix
programs.git.enable
xdg.configFile
home.packages
home.sessionVariables
```

### Forgetting Both Desktop Layers

Some desktop features have two layers:

```text
modules/nixos/desktop/niri.nix
modules/home-manager/desktop/niri.nix
```

Enable the system layer in `configuration.nix` and the user layer in `home.nix`.

## Validation

After migration, check:

```sh
nix flake check --no-build
```

Then rebuild:

```sh
sudo nixos-rebuild switch --flake .#hallnet
```
