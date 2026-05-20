# Implementing On macOS

This guide explains how to extend the `dendritic/` layout to support
macOS using `nix-darwin` and Home Manager.

The current `dendritic/` tree is Linux-first, but it is already split
so that cross-platform user modules can be reused.

## What Changes On macOS

On NixOS, the host is built with `nixosSystem`.

On macOS, the host is built with `nix-darwin.lib.darwinSystem`.

You keep:

- `flake-parts`
- Home Manager
- `modules/home/common/`

You replace or add:

- `modules/system/darwin/`
- a Darwin host under `hosts/`

## What You Can Reuse

These modules are already good candidates for reuse on macOS:

- [modules/home/common/git.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/git.nix:1)
- [modules/home/common/shell.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/shell.nix:1)
- [modules/home/common/ghostty/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/ghostty/default.nix:1)
- [modules/home/common/kitty/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/kitty/default.nix:1)
- [modules/home/common/neovim/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/neovim/default.nix:1)
- [modules/home/common/nodejs.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/nodejs.nix:1)
- [modules/home/common/rust.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/rust.nix:1)
- [modules/home/common/bun.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/bun.nix:1)

These Linux-only modules should not be reused directly:

- [modules/system/nixos/desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/desktop-hyprland.nix:1)
- [modules/home/linux/desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/linux/desktop-hyprland.nix:1)
- most of `modules/system/nixos/`

## Recommended Layout

Add a Darwin-specific system tree:

```text
dendritic/
  hosts/
    hallmac/
      default.nix
  modules/
    system/
      nixos/
      darwin/
        base.nix
        user-hallwack.nix
        homebrew.nix
        fonts.nix
```

Keep using:

```text
modules/home/common/
```

## Flake Changes

Add a `nix-darwin` input to `dendritic/flake.nix`.

Example:

```nix
inputs = {
  nixpkgs.url = "nixpkgs/nixos-25.05";
  flake-parts.url = "github:hercules-ci/flake-parts";
  home-manager = {
    url = "github:nix-community/home-manager/release-25.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  nix-darwin = {
    url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Then import Darwin modules and a Darwin host file.

## Example Darwin Host

Create:

```text
hosts/hallmac/default.nix
```

Example shape:

```nix
{
  config,
  inputs,
  ...
}: let
  repoRoot = "/Users/hallwack/dev/hallnix";
in {
  flake.darwinConfigurations.hallmac = inputs.nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit repoRoot;
    };
    modules = [
      config.flake.modules.darwin.base
      config.flake.modules.darwin.user-hallwack
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.hallwack = {};
          sharedModules = [
            config.flake.modules.homeManager.user-hallwack
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.git
            config.flake.modules.homeManager.ghostty
            config.flake.modules.homeManager.kitty
            config.flake.modules.homeManager.neovim
            config.flake.modules.homeManager.nodejs
            config.flake.modules.homeManager.rust
            config.flake.modules.homeManager.bun
          ];
          extraSpecialArgs = {
            inherit repoRoot;
          };
        };
      }
    ];
  };
}
```

Use `aarch64-darwin` for Apple Silicon and `x86_64-darwin` for Intel Macs.

## Example Darwin Modules

### `modules/system/darwin/base.nix`

```nix
{
  ...
}: {
  flake.modules.darwin.base = { pkgs, ... }: {
    nix.settings.experimental-features = ["nix-command" "flakes"];

    system.defaults.dock.autohide = true;
    system.defaults.finder.AppleShowAllExtensions = true;

    environment.systemPackages = with pkgs; [
      curl
      wget
      vim
    ];

    system.stateVersion = 6;
  };
}
```

### `modules/system/darwin/user-hallwack.nix`

```nix
{
  ...
}: {
  flake.modules.darwin.user-hallwack = { ... }: {
    users.users.hallwack = {
      home = "/Users/hallwack";
    };
  };
}
```

## What To Move Out Of Linux Modules

Do not carry these into macOS:

- `programs.hyprland`
- `services.xserver`
- `services.blueman`
- `services.pipewire`
- Linux hardware modules
- Wayland-only config modules

Instead, create Darwin-native replacements if you need them.

Examples:

- terminal stays in `modules/home/common/ghostty`
- editor stays in `modules/home/common/neovim`
- shell stays in `modules/home/common/shell`
- tiling/window behavior would use a macOS-specific tool, not Hyprland

## Home Manager Strategy On macOS

Keep user app modules in `modules/home/common/` whenever possible.

That means if you add:

- `ghostty`
- `kitty`
- `neovim`
- `git`
- `nodejs`
- `rust`
- `bun`

they should continue to work on both Linux and macOS with minimal or no changes.

If an app needs OS-specific config differences, split it like this:

```text
modules/home/common/<app>/
modules/home/linux/<app>/
modules/home/darwin/<app>/
```

Use the common module for shared config, and small OS-specific modules only for overrides.

## Suggested Migration Plan

1. Add `nix-darwin` input to `dendritic/flake.nix`.
2. Create `modules/system/darwin/base.nix`.
3. Create `modules/system/darwin/user-hallwack.nix`.
4. Create `hosts/hallmac/default.nix`.
5. Reuse the existing `modules/home/common/` modules.
6. Only add `modules/home/darwin/` if an app actually needs Darwin-specific overrides.

## Current Best Practice For This Repo

If you want future macOS support, keep following these rules:

- put reusable user-space tools in `modules/home/common/`
- keep Linux desktop modules in `modules/home/linux/`
- keep Linux system modules in `modules/system/nixos/`
- add Darwin system modules under `modules/system/darwin/`
- avoid putting app config inside Linux desktop modules if the app itself is cross-platform

## Notes

As of May 20, 2026, the current official integration points are:

- `flake-parts.lib.mkFlake` for flake composition
- `nix-darwin.lib.darwinSystem` for macOS hosts
- `inputs.home-manager.darwinModules.home-manager` for Home Manager on macOS

Sources:

- flake-parts getting started: https://flake.parts/getting-started.html
- nix-darwin README: https://github.com/nix-darwin/nix-darwin
- Home Manager manual, nix-darwin module: https://home-manager.dev/manual/23.05/
