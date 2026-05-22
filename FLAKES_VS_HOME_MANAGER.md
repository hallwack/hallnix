# Flakes Vs Home Manager In This Configuration

This guide explains the difference between:

- `flakes`
- `Home Manager`

and how they work together in this repository.

This repo uses both, but they solve different problems.

## Short Version

- **Flakes** define and compose the whole project
- **Home Manager** manages your user environment

In this repo:

- `flake.nix` is the top-level entrypoint
- `hosts/hallnet/default.nix` assembles the NixOS system
- `modules/system/nixos/*` configure the machine
- `modules/home/*` configure your user environment

## What Flakes Do

Flakes are the project-level structure.

They answer questions like:

- which inputs does this config use?
- which version of `nixpkgs` does it follow?
- which outputs does this repo provide?
- how do we build `nixosConfigurations.hallnet`?

In this repo, that starts in:

- [flake.nix](/home/hallwack/Documents/dev/nix/hallnix/flake.nix:1)

### In your `flake.nix`

Your flake defines:

- `inputs`
  - `nixpkgs`
  - `home-manager`
  - `flake-parts`
  - `nur`
  - `noctalia`
  - others
- `outputs`
- imported modules
- `perSystem` packages and formatter

So flakes are the **container and composition layer**.

They do not directly mean "desktop config" or "shell config".

They define the graph of the whole configuration.

## What Home Manager Does

Home Manager manages the user environment.

It answers questions like:

- what packages should the user have?
- what should go into `~/.config/nvim`?
- how should `zsh` be configured?
- what should `starship` look like?
- what should `ghostty`, `kitty`, or `niri` place in `~/.config`?

In this repo, Home Manager modules live in:

- [modules/home/common](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common)
- [modules/home/linux](/home/hallwack/Documents/dev/nix/hallnix/modules/home/linux)

Examples:

- [modules/home/common/shell.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common/shell.nix:1)
- [modules/home/common/neovim/default.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common/neovim/default.nix:1)
- [modules/home/common/git.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common/git.nix:1)
- [modules/home/linux/niri/default.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/linux/niri/default.nix:1)

So Home Manager is the **user-level configuration layer**.

## What NixOS Does

NixOS is the operating system configuration layer.

It answers questions like:

- boot loader
- networking
- audio
- Bluetooth
- installed system packages
- login manager
- window manager enablement

In this repo, NixOS modules live in:

- [modules/system/nixos](/home/hallwack/Documents/dev/nix/hallnix/modules/system/nixos)

Examples:

- [modules/system/nixos/base.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/system/nixos/base.nix:1)
- [modules/system/nixos/audio.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/system/nixos/audio.nix:1)
- [modules/system/nixos/desktop-niri.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/system/nixos/desktop-niri.nix:1)

## How They Fit Together Here

The flow in this repo is:

1. `flake.nix` declares inputs and imports module files
2. `hosts/hallnet/default.nix` builds `nixosConfigurations.hallnet`
3. that host imports NixOS modules for system config
4. it also imports Home Manager as a NixOS module
5. Home Manager then applies the user modules for `hallwack`

The main assembly file is:

- [hosts/hallnet/default.nix](/home/hallwack/Documents/dev/nix/hallnix/hosts/hallnet/default.nix:1)

## The Actual Wiring In This Repo

Your host file contains:

- `inputs.home-manager.nixosModules.home-manager`
- `home-manager.sharedModules = [ ... ]`
- `home-manager.users.hallwack = {}`

That means:

- Home Manager is being run **through NixOS**
- your user config is part of the same `nixos-rebuild switch`

So you do **not** run separate Home Manager commands in this setup.

Instead, you usually apply both system and home config with:

```bash
sudo nixos-rebuild switch --flake .#hallnet
```

## Difference In Responsibility

Use this rule:

- if the machine itself must know about it: NixOS module
- if the user environment must know about it: Home Manager module
- if the whole project must know how to assemble it: flake

### Examples

#### Example 1: enable Niri

This is a system concern.

Use:

- [modules/system/nixos/desktop-niri.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/system/nixos/desktop-niri.nix:1)

because the OS needs to start the compositor and session support.

#### Example 2: configure Niri files

This is a user concern.

Use:

- [modules/home/linux/niri/default.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/linux/niri/default.nix:1)
- [config/niri/config.kdl](/home/hallwack/Documents/dev/nix/hallnix/config/niri/config.kdl:1)

because this populates `~/.config/niri`.

#### Example 3: configure Zsh

This is a user concern.

Use:

- [modules/home/common/shell.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common/shell.nix:1)
- [config/zsh/custom.zsh](/home/hallwack/Documents/dev/nix/hallnix/config/zsh/custom.zsh:1)

because Zsh is your shell environment, not a system service.

#### Example 4: add a new flake input

This is a project concern.

Use:

- [flake.nix](/home/hallwack/Documents/dev/nix/hallnix/flake.nix:1)

because only the flake can define new upstream dependencies.

## What `flake-parts` Changes

This repo uses `flake-parts`.

That means your `flake.nix` does not manually define everything in one file.

Instead:

- module files export `flake.modules.nixos.*`
- module files export `flake.modules.homeManager.*`
- the host assembles them

So in this repo:

- flakes are still the top-level structure
- `flake-parts` just makes the flake modular

## Why You Need Both

You need flakes because:

- you want a reproducible project with pinned inputs
- you want one command to build the whole configuration
- you want reusable outputs and module composition

You need Home Manager because:

- you want declarative `~/.config`
- you want declarative shell/editor/app setup
- you want user packages separated from system packages

Without flakes:

- you lose the modern project structure and pinned inputs

Without Home Manager:

- you can still configure NixOS, but user dotfiles and app config become awkward

## How To Implement Things In This Repo

### Add a system feature

Use:

- `modules/system/nixos/<feature>.nix`

Then wire it in through:

- [hosts/hallnet/default.nix](/home/hallwack/Documents/dev/nix/hallnix/hosts/hallnet/default.nix:1)

Examples:

- audio
- Bluetooth
- fonts
- Niri enablement

### Add a user feature

Use:

- `modules/home/common/<feature>.nix`
- or `modules/home/common/<app>/default.nix`
- or `modules/home/linux/<feature>.nix`

Then add it to:

- `home-manager.sharedModules`

Examples:

- Neovim
- Git
- Starship
- Zsh
- Niri config
- Noctalia

### Add a new upstream dependency

Use:

- `flake.nix`

Examples:

- `noctalia`
- `nur`
- `apple-fonts`

## How To Think About `config/`

In this repo, the intended pattern is:

- source of truth lives in `~/hallnix/config/...`
- Home Manager links it into `~/.config/...`

Examples:

- [config/nvim/init.lua](/home/hallwack/Documents/dev/nix/hallnix/config/nvim/init.lua:1)
- [config/starship.toml](/home/hallwack/Documents/dev/nix/hallnix/config/starship.toml:1)
- [config/zsh/custom.zsh](/home/hallwack/Documents/dev/nix/hallnix/config/zsh/custom.zsh:1)
- [config/niri/config.kdl](/home/hallwack/Documents/dev/nix/hallnix/config/niri/config.kdl:1)

So:

- flakes assemble
- Home Manager populates user config
- `config/` stores the editable source files

## Common Confusion

### “Is Home Manager separate from flakes?”

Yes conceptually, but in this repo it is integrated into the flake.

So:

- Home Manager is a tool/module system
- the flake is how you include and assemble it

### “Do I edit Home Manager or the config files?”

Usually both:

- edit the Home Manager module when changing ownership, packages, or links
- edit files under `config/` when changing app behavior

Example:

- change package list for Neovim support in [modules/home/common/neovim/default.nix](/home/hallwack/Documents/dev/nix/hallnix/modules/home/common/neovim/default.nix:1)
- change Neovim behavior in [config/nvim/init.lua](/home/hallwack/Documents/dev/nix/hallnix/config/nvim/init.lua:1)

### “Do I run `home-manager switch`?”

Not in this repo’s normal flow.

Because Home Manager is integrated into the NixOS flake, you usually run:

```bash
sudo nixos-rebuild switch --flake .#hallnet
```

## Practical Summary

- `flake.nix`: project entrypoint and dependency graph
- `hosts/hallnet/default.nix`: machine assembly
- `modules/system/nixos/*`: machine/system configuration
- `modules/home/*`: user configuration through Home Manager
- `config/*`: editable source files that Home Manager links into `~/.config`

## Related Docs

- package placement: [ADDING_PACKAGES.md](/home/hallwack/Documents/dev/nix/hallnix/ADDING_PACKAGES.md:1)
- migration guide: [MIGRATING_TO_DENDRITIC.md](/home/hallwack/Documents/dev/nix/hallnix/MIGRATING_TO_DENDRITIC.md:1)
- macOS guide: [MACOS.md](/home/hallwack/Documents/dev/nix/hallnix/MACOS.md:1)
