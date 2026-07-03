# Repository Structure

This repository contains a NixOS configuration built around `flake-parts`, host entry points, ordinary NixOS modules, ordinary Home Manager modules, dotfiles, and local packages.

## Overview

```text
.
├── flake.nix
├── flake.lock
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
├── pkgs/
└── *.md
```

## `flake.nix`

`flake.nix` is the repository entry point.

It:

- declares inputs such as `nixpkgs`, `home-manager`, `flake-parts`, `nur`, `noctalia`, and other dependencies
- uses `flake-parts.lib.mkFlake`
- imports host entry points
- exposes per-system outputs such as the formatter

It does not manually import every feature module. The current flake imports:

```nix
imports = [
  ./hosts/hallnet
];
```

## `hosts/`

`hosts/` contains one directory per machine.

Current host:

```text
hosts/hallnet/
├── default.nix
├── configuration.nix
├── home.nix
└── hardware-configuration.nix
```

### `hosts/hallnet/default.nix`

This is the flake-parts host entry point.

It:

- defines `flake.nixosConfigurations.hallnet`
- calls `inputs.nixpkgs.lib.nixosSystem`
- sets `system`, `username`, `hostname`, and `repoRoot`
- passes `specialArgs`
- imports `./configuration.nix`
- imports `../../modules/nixos`
- enables Home Manager through `inputs.home-manager.nixosModules.home-manager`
- passes `../../modules/home-manager` to `home-manager.sharedModules`
- imports `./home.nix` as the Home Manager user config

### `hosts/hallnet/configuration.nix`

This is the NixOS host profile.

It:

- imports `hardware-configuration.nix`
- sets `networking.hostName`
- enables `nixpkgs.config.allowUnfree`
- enables NixOS feature options

Example:

```nix
hallwack.system.core.enable = true;
hallwack.system.audio.enable = true;
hallwack.services.openssh.enable = true;
hallwack.desktop.gnome.enable = true;
hallwack.desktop.niri.enable = true;
```

### `hosts/hallnet/home.nix`

This is the Home Manager user profile.

It:

- sets `home.username`
- sets `home.homeDirectory`
- sets `home.stateVersion`
- enables Home Manager feature options

Example:

```nix
hallwack.user.enable = true;
hallwack.cli.git.enable = true;
hallwack.cli.shell.enable = true;
hallwack.editors.neovim.enable = true;
hallwack.terminal.kitty.enable = true;
hallwack.desktop.niri.enable = true;
```

### `hosts/hallnet/hardware-configuration.nix`

This is the generated NixOS hardware file.

It defines filesystems, initrd modules, kernel modules, swap devices, and hardware defaults. Avoid manual edits unless the hardware or disk layout changes.

## `modules/nixos/`

`modules/nixos/` contains NixOS modules.

Current structure:

```text
modules/nixos/
├── default.nix
├── desktop/
│   ├── gnome.nix
│   └── niri.nix
├── services/
│   └── openssh.nix
└── system/
    ├── audio.nix
    ├── bluetooth.nix
    ├── core.nix
    ├── fonts.nix
    ├── pcsc.nix
    ├── shell.nix
    └── users.nix
```

`modules/nixos/default.nix` auto-imports the modules below it.

NixOS modules should define `options` and conditionally apply `config`:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.system.example.enable =
    lib.mkEnableOption "Enable example system module";

  config = lib.mkIf config.hallwack.system.example.enable {
    environment.systemPackages = with pkgs; [
      example
    ];
  };
}
```

Use NixOS modules for:

- `boot.*`
- `networking.*`
- `users.users.*`
- `services.*`
- `hardware.*`
- `security.*`
- `programs.niri` or other system compositor enablement
- `environment.systemPackages`
- system fonts
- system services

## `modules/home-manager/`

`modules/home-manager/` contains Home Manager modules.

Current structure:

```text
modules/home-manager/
├── default.nix
├── cli/
│   ├── dev-tools.nix
│   ├── git.nix
│   ├── nodejs.nix
│   ├── rust.nix
│   └── shell.nix
├── desktop/
│   ├── hyprland.nix
│   ├── niri.nix
│   └── noctalia.nix
├── editors/
│   └── neovim.nix
├── terminal/
│   ├── ghostty.nix
│   └── kitty.nix
└── user/
    └── hallwack.nix
```

`modules/home-manager/default.nix` auto-imports the modules below it.

Home Manager modules should define `options` and conditionally apply `config`:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.cli.example.enable =
    lib.mkEnableOption "Enable example user module";

  config = lib.mkIf config.hallwack.cli.example.enable {
    home.packages = with pkgs; [
      example
    ];
  };
}
```

Use Home Manager modules for:

- `home.*`
- `home.packages`
- `programs.git`
- `programs.zsh`
- `programs.neovim`
- `xdg.configFile`
- `gtk.*`
- `dconf.*`
- user-level services
- user dotfiles

## Auto-Import Rules

Both module roots use the same import pattern:

```text
modules/nixos/default.nix
modules/home-manager/default.nix
```

The import logic includes every `.nix` file recursively, except:

- `default.nix`
- paths containing `/_`

This means every `.nix` file under those directories must be a valid module unless excluded.

## `config/`

`config/` stores editable dotfiles.

Examples:

```text
config/ghostty/config
config/kitty/kitty.conf
config/niri/config.kdl
config/nvim/init.lua
config/starship.toml
config/zsh/custom.zsh
```

Home Manager modules link these files into the user environment, usually with:

```nix
config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/<name>"
```

## `pkgs/`

`pkgs/` contains local package definitions.

Current examples:

```text
pkgs/helium-browser/default.nix
pkgs/zennotes/default.nix
```

## Naming Conventions

Use `hallwack.<scope>.<feature>.enable` for module toggles.

Current scopes include:

```text
hallwack.system.*
hallwack.services.*
hallwack.desktop.*
hallwack.cli.*
hallwack.editors.*
hallwack.terminal.*
hallwack.user.*
```

It is acceptable for NixOS and Home Manager modules to use the same option path, such as `hallwack.desktop.niri.enable`, because they are evaluated in different module systems.

## Validation

Check evaluation:

```sh
nix flake check --no-build
```

Apply the configuration:

```sh
sudo nixos-rebuild switch --flake .#hallnet
```
