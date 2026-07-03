# Flakes Vs Home Manager In This Repository

This guide explains the difference between flakes, NixOS modules, and Home Manager modules in the current layout.

## Short Version

- **Flakes** define the project, inputs, and outputs.
- **NixOS modules** configure the machine.
- **Home Manager modules** configure the user environment.

In this repo:

```text
flake.nix                         -> project entry point
hosts/hallnet/default.nix         -> creates nixosConfigurations.hallnet
hosts/hallnet/configuration.nix   -> enables NixOS feature modules
hosts/hallnet/home.nix            -> enables Home Manager feature modules
modules/nixos/                    -> NixOS modules
modules/home-manager/             -> Home Manager modules
config/                           -> dotfiles linked by Home Manager
```

## What Flakes Do

Flakes are the project-level structure.

They answer questions like:

- which inputs does this repository use?
- which `nixpkgs` revision is pinned?
- which systems does the flake support?
- which outputs does this repository expose?
- how is `nixosConfigurations.hallnet` created?

This starts in:

```text
flake.nix
```

This repository uses `flake-parts`, so `flake.nix` stays small and imports the host entry point:

```nix
imports = [
  ./hosts/hallnet
];
```

The host entry point then defines:

```nix
flake.nixosConfigurations.hallnet
```

## What NixOS Modules Do

NixOS modules configure the operating system and machine-wide behavior.

They answer questions like:

- how does the system boot?
- which services are enabled?
- which users exist?
- which desktop/session support is installed?
- which packages are available system-wide?
- how are audio, Bluetooth, fonts, and PCSC configured?

In this repo, NixOS modules live in:

```text
modules/nixos/
```

Examples:

```text
modules/nixos/system/core.nix
modules/nixos/system/audio.nix
modules/nixos/system/bluetooth.nix
modules/nixos/system/fonts.nix
modules/nixos/system/users.nix
modules/nixos/services/openssh.nix
modules/nixos/desktop/gnome.nix
modules/nixos/desktop/niri.nix
```

They are auto-imported through:

```text
modules/nixos/default.nix
```

The host enables them in:

```text
hosts/hallnet/configuration.nix
```

Example:

```nix
hallwack.system.audio.enable = true;
hallwack.services.openssh.enable = true;
hallwack.desktop.niri.enable = true;
```

## What Home Manager Does

Home Manager manages the user environment.

It answers questions like:

- which packages should the user have?
- what should be linked into `~/.config`?
- how should Git, Zsh, Neovim, Ghostty, Kitty, or Niri be configured?
- which user-level session files should be installed?

In this repo, Home Manager modules live in:

```text
modules/home-manager/
```

Examples:

```text
modules/home-manager/user/hallwack.nix
modules/home-manager/cli/git.nix
modules/home-manager/cli/shell.nix
modules/home-manager/cli/nodejs.nix
modules/home-manager/cli/rust.nix
modules/home-manager/editors/neovim.nix
modules/home-manager/terminal/ghostty.nix
modules/home-manager/terminal/kitty.nix
modules/home-manager/desktop/niri.nix
modules/home-manager/desktop/noctalia.nix
```

They are auto-imported through:

```text
modules/home-manager/default.nix
```

The host enables them in:

```text
hosts/hallnet/home.nix
```

Example:

```nix
hallwack.cli.git.enable = true;
hallwack.cli.shell.enable = true;
hallwack.editors.neovim.enable = true;
hallwack.terminal.kitty.enable = true;
```

## How They Fit Together

The evaluation flow is:

1. `flake.nix` imports `./hosts/hallnet`.
2. `hosts/hallnet/default.nix` creates `flake.nixosConfigurations.hallnet`.
3. That NixOS system imports `hosts/hallnet/configuration.nix`.
4. It also imports `modules/nixos`, which auto-imports all NixOS feature modules.
5. It enables Home Manager through `inputs.home-manager.nixosModules.home-manager`.
6. Home Manager receives `modules/home-manager` through `home-manager.sharedModules`.
7. `hosts/hallnet/home.nix` enables the user-level feature modules.

Home Manager is integrated into the NixOS rebuild, so the normal command is:

```sh
sudo nixos-rebuild switch --flake .#hallnet
```

You do not normally run `home-manager switch` separately in this setup.

## Responsibility Boundary

Use this rule:

- if the machine itself needs it, use a NixOS module
- if the user environment needs it, use a Home Manager module
- if the whole project needs to know about it, use the flake

Examples:

```text
services.openssh.enable      -> NixOS
programs.niri.enable         -> NixOS
programs.git.enable          -> Home Manager
xdg.configFile."nvim"        -> Home Manager
inputs.noctalia              -> flake.nix
```

## Same Option Names In NixOS And Home Manager

It is valid for a NixOS module and a Home Manager module to use the same option path, for example:

```nix
hallwack.desktop.niri.enable
```

They are evaluated in different module systems:

- NixOS sees `hallwack.desktop.niri.enable`.
- Home Manager sees `home-manager.users.hallwack.hallwack.desktop.niri.enable`.

This is useful when a feature has both a system layer and a user layer. You still need to enable each layer in the correct host file:

```nix
# hosts/hallnet/configuration.nix
hallwack.desktop.niri.enable = true;

# hosts/hallnet/home.nix
hallwack.desktop.niri.enable = true;
```

## What `flake-parts` Changes

`flake-parts` is used for flake composition, but feature modules are now ordinary NixOS/Home Manager modules rather than `flake.modules.*` outputs.

Current pattern:

```text
flake.nix imports hosts/hallnet
hosts/hallnet/default.nix imports modules/nixos
home-manager.sharedModules imports modules/home-manager
```

This keeps `flake.nix` small and moves host-specific decisions into `hosts/hallnet/`.

## How To Think About `config/`

The intended pattern is:

- source files live under `config/`
- Home Manager links them into `~/.config`

Examples:

```text
config/nvim/init.lua
config/niri/config.kdl
config/starship.toml
config/zsh/custom.zsh
```

Change the Home Manager module when changing package ownership or file links. Change files under `config/` when changing the application behavior itself.
