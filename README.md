# hallnix

Personal NixOS configuration built with `flake-parts`, NixOS modules, and Home Manager.

This branch uses a dendritic layout: small feature modules are auto-imported, while each host decides which features are enabled.

## Layout

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
│   └── home-manager/
├── config/
└── pkgs/
```

## Entry Points

- `flake.nix` is the top-level flake entry point.
- `hosts/hallnet/default.nix` defines `flake.nixosConfigurations.hallnet`.
- `hosts/hallnet/configuration.nix` enables NixOS/system feature flags for `hallnet`.
- `hosts/hallnet/home.nix` enables Home Manager/user feature flags for `hallwack`.
- `hosts/hallnet/hardware-configuration.nix` is the generated NixOS hardware file.

## NixOS Modules

NixOS modules live in:

```text
modules/nixos/
├── default.nix
├── desktop/
├── services/
└── system/
```

`modules/nixos/default.nix` recursively imports all `.nix` files under `modules/nixos`, except `default.nix` and paths containing `/_`.

These modules define options such as:

```nix
hallwack.system.core.enable
hallwack.system.audio.enable
hallwack.system.bluetooth.enable
hallwack.system.fonts.enable
hallwack.system.pcsc.enable
hallwack.system.shell.enable
hallwack.system.users.enable
hallwack.services.openssh.enable
hallwack.desktop.gnome.enable
hallwack.desktop.niri.enable
```

Enable them from `hosts/hallnet/configuration.nix`.

## Home Manager Modules

Home Manager modules live in:

```text
modules/home-manager/
├── default.nix
├── cli/
├── desktop/
├── editors/
├── terminal/
└── user/
```

`modules/home-manager/default.nix` recursively imports all `.nix` files under `modules/home-manager`, except `default.nix` and paths containing `/_`.

These modules define options such as:

```nix
hallwack.user.enable
hallwack.cli.devtools.enable
hallwack.cli.git.enable
hallwack.cli.nodejs.enable
hallwack.cli.rust.enable
hallwack.cli.shell.enable
hallwack.desktop.niri.enable
hallwack.desktop.noctalia.enable
hallwack.editors.neovim.enable
hallwack.terminal.ghostty.enable
hallwack.terminal.kitty.enable
```

Enable them from `hosts/hallnet/home.nix`.

## Desktop Layers

Desktop configuration is split into system and user layers.

Niri system enablement is in:

```text
modules/nixos/desktop/niri.nix
```

Niri user config is in:

```text
modules/home-manager/desktop/niri.nix
```

Both currently use the same option name, `hallwack.desktop.niri.enable`, but they live in different module systems:

- NixOS sees `hallwack.desktop.niri.enable`.
- Home Manager sees `home-manager.users.hallwack.hallwack.desktop.niri.enable`.

That is valid. Enable the system layer in `configuration.nix` and the user layer in `home.nix`.

## Dotfiles

The `config/` directory stores editable application configuration that Home Manager links into the user environment.

Examples:

- `config/niri`
- `config/nvim`
- `config/ghostty`
- `config/kitty`
- `config/zsh`
- `config/starship.toml`

Dotfiles are not active by themselves. A Home Manager module must link or configure them.

## Local Packages

Local package definitions live in:

```text
pkgs/
├── helium-browser/
└── zennotes/
```

They can be referenced from NixOS or Home Manager modules through flake inputs or `pkgs` depending on how they are exposed.

## Rebuild

From this repository:

```sh
sudo nixos-rebuild switch --flake .#hallnet
```

The `hallwack.cli.shell` module also defines a `switch` shell alias using the configured repository path.

## Check

```sh
nix flake check --no-build
```

## More Documentation

- `STRUCTURE.md`: repository structure and module conventions.
- `ADDING_PACKAGES.md`: where to add packages and new feature modules.
- `FLAKES_VS_HOME_MANAGER.md`: how flakes, NixOS, and Home Manager fit together.
- `MIGRATING_TO_DENDRITIC.md`: migration notes for this module layout.
- `MACOS.md`: planned nix-darwin/macOS extension strategy.
