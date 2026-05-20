# Adding Packages And Configuration

This guide explains how to add new packages and configuration to the
`dendritic/` example layout.

## Rule Of Thumb

Choose the module location by scope:

- `modules/system/nixos/`: Linux system concerns
- `modules/home/common/`: user packages/config that can also make sense on macOS later
- `modules/home/linux/`: Linux desktop or Wayland-specific user packages/config

Choose the module shape by ownership:

- one app owns its own package and config
- one language/runtime owns its own toolchain packages
- one system concern owns its related Linux services/options

## Where Things Go

### 1. System packages and services

Put them in `modules/system/nixos/`.

Examples:

- networking
- bluetooth
- audio
- boot loader
- display manager
- window manager enablement

Example files:

- [base.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/base.nix:1)
- [bluetooth.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/bluetooth.nix:1)
- [desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/desktop-hyprland.nix:1)

### 2. Cross-platform user apps

Put them in `modules/home/common/`.

Examples:

- `ghostty`
- `kitty`
- `neovim`
- `git`
- `shell`

Recommended structure:

```text
modules/home/common/<app>/
  default.nix
  config/
    ...
```

Examples:

- [ghostty](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/ghostty/default.nix:1)
- [kitty](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/kitty/default.nix:1)
- [neovim](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/neovim/default.nix:1)

### 3. Linux-only desktop apps and config

Put them in `modules/home/linux/`.

Examples:

- Hyprland config
- waybar
- rofi
- mako
- swaync

Example:

- [desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/linux/desktop-hyprland.nix:1)

### 4. Language toolchains

Put them in dedicated Home Manager modules under `modules/home/common/`.

Examples:

- [nodejs.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/nodejs.nix:1)
- [rust.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/rust.nix:1)
- [bun.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/bun.nix:1)

This keeps runtime-specific tools out of the generic user package list.

## How To Add A New App

Example: adding `ghostty`.

Create:

```text
modules/home/common/ghostty/
  default.nix
  config/
    config
```

`default.nix`:

```nix
{
  ...
}: {
  flake.modules.homeManager.ghostty = { pkgs, ... }: {
    home.packages = with pkgs; [
      ghostty
    ];

    xdg.configFile."ghostty".source = ./config;
  };
}
```

Then add it to:

- `dendritic/flake.nix` imports
- `home-manager.sharedModules` in `dendritic/hosts/hallnet/default.nix`

## How To Add A New CLI Tool

If it belongs to an existing concern, add it there.

Examples:

- add `git` to `git.nix`
- add `cargo-*` tools to `rust.nix`
- add `pnpm` or `typescript-language-server` to `nodejs.nix`

If it is general developer tooling, either:

- place it in an existing related module
- or create a new module such as `dev-base.nix`

## How To Add A New Window Manager

Split it in two:

- system enablement in `modules/system/nixos/desktop-<name>.nix`
- user config in `modules/home/linux/desktop-<name>.nix`

Example split:

```text
modules/system/nixos/desktop-niri.nix
modules/home/linux/desktop-niri.nix
```

System module owns:

- `programs.<wm>.enable`
- portals
- system packages
- session integration

Home module owns:

- `xdg.configFile`
- launcher config
- panel config
- wallpapers/scripts if they are user-session concerns

## How To Add A New Language Runtime

Create one module per runtime.

Examples:

- `modules/home/common/nodejs.nix`
- `modules/home/common/rust.nix`
- `modules/home/common/bun.nix`

Minimal pattern:

```nix
{
  ...
}: {
  flake.modules.homeManager.nodejs = { pkgs, ... }: {
    home.packages = with pkgs; [
      nodejs
      nodePackages.pnpm
    ];
  };
}
```

Then import it in `flake.nix` and add it to `sharedModules`.

## Package Placement Rules

Use these rules when unsure:

- if the OS must know about it, use `modules/system/nixos/`
- if it is a user app that may work on macOS later, use `modules/home/common/`
- if it depends on Linux desktop infrastructure, use `modules/home/linux/`
- if the package exists only to support one app, keep it with that app
- if the package exists for one language ecosystem, keep it with that language

## Current Examples In This Repo

App-owned modules:

- Ghostty: package + config directory
- Kitty: package + config directory
- Neovim: package + config directory

Language-owned modules:

- Node.js: runtime and JS tooling
- Rust: toolchain and cargo helpers
- Bun: runtime

System-owned modules:

- Bluetooth
- Audio
- Fonts
- Hyprland enablement

## Suggested Future Cleanup

- move `git` package ownership fully into `git.nix`
- decide whether `gcc` belongs in `rust.nix` or a shared `dev-base.nix`
- move `waybar`, `rofi`, and `mako` to app-owned modules under `modules/home/linux/`
