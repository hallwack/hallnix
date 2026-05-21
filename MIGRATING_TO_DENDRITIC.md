# Migrating From A Traditional Structure To Dendritic

This guide explains how to move from a traditional NixOS repository layout
to the `dendritic/` structure in this repo.

Traditional layout usually looks like this:

```text
flake.nix
configuration.nix
hardware-configuration.nix
home-manager.nix
modules/
core/
config/
```

The dendritic layout in this repo looks like this:

```text
dendritic/
  flake.nix
  hosts/
  modules/
    system/
      nixos/
    home/
      common/
      linux/
```

## Main Idea

Traditional structure groups files by entrypoint or by technical layer.

Examples:

- one big `configuration.nix`
- one big `home-manager.nix`
- a `modules/` directory with mixed ownership

Dendritic structure groups files by ownership and reuse.

Examples:

- Bluetooth owns Bluetooth
- Ghostty owns Ghostty package and config
- Neovim owns Neovim package and config
- Node.js owns Node.js tooling
- a Linux desktop module owns only Linux desktop concerns

## What You Are Trying To Achieve

By the end of the migration:

- host files are thin
- `flake.nix` is composition, not the whole config
- system concerns live in `modules/system/nixos/`
- reusable user concerns live in `modules/home/common/`
- Linux-only desktop concerns live in `modules/home/linux/`
- each app or language can own its own package and config

## Recommended Migration Strategy

Do not rewrite everything in one step.

Migrate in this order:

1. create a parallel dendritic tree
2. move host assembly first
3. split system concerns
4. split Home Manager concerns
5. split app-owned config
6. split language toolchains
7. remove the old duplicated files only after the new tree is stable

This is exactly why the `dendritic/` directory exists in parallel in this repo.

## Step 1. Create A Parallel Tree

Do not replace the old root config immediately.

Create a separate tree:

```text
dendritic/
  flake.nix
  hosts/
  modules/
```

This lets you compare:

- old root config
- new dendritic layout

without breaking the working system during the refactor.

## Step 2. Move The Host Entrypoint First

In the traditional structure, the flake often points directly at:

- `./configuration.nix`

In dendritic, the host file should be thin and live under `hosts/`.

Example:

- [hosts/hallnet/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/hosts/hallnet/default.nix:1)

The host should mostly:

- declare the system type
- pass `specialArgs`
- import the hardware config
- assemble modules

It should not contain large chunks of actual system logic.

## Step 3. Split System Concerns

Take the large `configuration.nix` and split it by functionality into
`modules/system/nixos/`.

Examples from this repo:

- [base.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/base.nix:1)
- [audio.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/audio.nix:1)
- [bluetooth.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/bluetooth.nix:1)
- [fonts.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/fonts.nix:1)
- [desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/desktop-hyprland.nix:1)
- [desktop-niri.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/system/nixos/desktop-niri.nix:1)

Good candidates for system modules:

- boot loader
- networking
- audio
- bluetooth
- fonts
- display manager
- window manager enablement
- Linux services
- hardware-related setup

## Step 4. Split Home Manager Concerns

Take the large `home-manager.nix` and split it by reuse level.

Put reusable user modules in:

- `modules/home/common/`

Put Linux desktop-only user modules in:

- `modules/home/linux/`

Examples:

- [shell.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/shell.nix:1)
- [git.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/git.nix:1)
- [desktop-hyprland.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/linux/desktop-hyprland.nix:1)
- [niri/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/linux/niri/default.nix:1)

## Step 5. Split App-Owned Modules

If a package and its config belong together, give that app its own module.

Recommended pattern:

```text
modules/home/common/<app>/
  default.nix
  config/
```

Examples:

- [ghostty](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/ghostty/default.nix:1)
- [kitty](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/kitty/default.nix:1)
- [neovim](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/neovim/default.nix:1)

This is better than one giant Home Manager file with many unrelated
`xdg.configFile` entries.

## Step 6. Split Language Toolchains

If a set of packages belongs to one ecosystem, move it out of the generic
user package list.

Examples:

- [nodejs.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/nodejs.nix:1)
- [rust.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/rust.nix:1)
- [bun.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/modules/home/common/bun.nix:1)

This makes it obvious where to add:

- Node.js tools
- Rust tools
- Bun tools
- future Go/Python/Java tools

## Step 7. Convert The Flake To Composition

In a traditional layout, `flake.nix` often just calls `nixosSystem`.

In the dendritic example, `flake.nix` uses `flake-parts` and imports module
files that export reusable outputs.

See:

- [dendritic/flake.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/flake.nix:1)

The important change is:

- before: the flake directly held most of the assembly
- after: modules export `flake.modules.nixos.*` and `flake.modules.homeManager.*`

## Step 8. Wire Modules Into The Host

After splitting the modules, assemble them in the host file.

System modules go into the `nixosSystem` module list.

Home Manager modules go into `home-manager.sharedModules`.

See:

- [hosts/hallnet/default.nix](/home/hallwack/Documents/dev/nix/hallnix/dendritic/hosts/hallnet/default.nix:1)

## Migration Mapping For This Repo

Here is how the old-style files in this repo map into the dendritic tree.

Old:

- `configuration.nix`
- `home-manager.nix`
- `core/*.nix`
- `modules/programs/*.nix`
- `config/*`

New:

- `configuration.nix` system pieces -> `modules/system/nixos/*.nix`
- `home-manager.nix` generic shell/editor/app pieces -> `modules/home/common/*`
- `home-manager.nix` Linux desktop pieces -> `modules/home/linux/*`
- app config trees -> `modules/home/common/<app>/config/` or `modules/home/linux/<app>/config/`
- host assembly -> `hosts/hallnet/default.nix`

## How To Decide Where Something Goes

Ask these questions in order:

1. Does the OS itself need to know about this?
   Then it goes in `modules/system/nixos/`.

2. Is this a user package or user config that may work on macOS later?
   Then it goes in `modules/home/common/`.

3. Is this tied to Linux desktop or Wayland?
   Then it goes in `modules/home/linux/`.

4. Does this belong to one app?
   Then give the app its own module directory.

5. Does this belong to one language ecosystem?
   Then give that ecosystem its own module.

## Common Migration Mistakes

### 1. Keeping duplicate active entrypoints

Bad:

- root `configuration.nix`
- `hosts/hallnet/default.nix`
- both describe the same machine

Pick one active tree once migration is complete.

### 2. Leaving unrelated packages in generic user lists

Bad:

- language toolchains in `user-hallwack.nix`
- app-specific helpers in random generic modules

Move them to the module that owns them.

### 3. Letting one desktop module own unrelated apps

Bad:

- Hyprland module owns Kitty
- Hyprland module owns Ghostty

If Kitty or Ghostty are cross-platform apps, give them their own modules.

### 4. Migrating everything at once

Bad:

- giant rewrite
- no comparison point
- hard to debug

Prefer the parallel migration approach.

## Suggested Order For Your Existing Repo

For this repo specifically, the clean order is:

1. keep the old root config untouched
2. create `dendritic/`
3. move host assembly to `dendritic/hosts/hallnet/default.nix`
4. split `configuration.nix` into `modules/system/nixos/`
5. split `home-manager.nix` into `modules/home/common/` and `modules/home/linux/`
6. create app-owned directories for Ghostty, Kitty, and Neovim
7. create language-owned modules for Node.js, Rust, and Bun
8. only then consider switching your real machine over

## When The Migration Is Finished

A mature dendritic tree should have these properties:

- a thin host file
- a compositional `flake.nix`
- no duplicate active config trees
- clear ownership for each app and ecosystem
- obvious places to add future packages
- reusable Home Manager modules for future macOS support

## Related Documents

- package placement guide: [ADDING_PACKAGES.md](/home/hallwack/Documents/dev/nix/hallnix/dendritic/ADDING_PACKAGES.md:1)
- macOS implementation guide: [MACOS.md](/home/hallwack/Documents/dev/nix/hallnix/dendritic/MACOS.md:1)
- overview: [README.md](/home/hallwack/Documents/dev/nix/hallnix/dendritic/README.md:1)
