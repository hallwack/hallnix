# dendritic

This directory is a parallel sketch of the current repo reorganized in a
feature-oriented, dendritic-style layout using `flake-parts`.

It does not replace the existing configuration in the repo root.

What this demonstrates:

- `hosts/` contains thin machine entrypoints
- `modules/system/nixos/` owns Linux system concerns
- `modules/home/common/` owns reusable Home Manager concerns
- `modules/home/linux/` owns Linux desktop Home Manager concerns
- each feature file is a `flake-parts` module
- features export reusable modules via `flake.modules.nixos.*` and `flake.modules.homeManager.*`
- existing dotfiles under `../config/` are reused so you can compare structure without duplicating assets

Notable differences from the current root config:

- the flake entrypoint is `flake.nix`, built with `flake-parts.lib.mkFlake`
- the host entrypoint is `hosts/hallnet/default.nix`
- there is no duplicate `configuration.nix` vs `hosts/...` split
- Hyprland is linked to `~/.config/hypr`
- rebuild aliases and config paths point at the real repo location

To inspect the sketch:

- flake: `dendritic/flake.nix`
- host: `dendritic/hosts/hallnet/default.nix`
- system modules: `dendritic/modules/system/nixos/*.nix`
- home modules: `dendritic/modules/home/common/*.nix`
- Linux-only home modules: `dendritic/modules/home/linux/*.nix`

The important shift from the previous sketch is:

- before: feature files were plain NixOS/Home Manager modules
- now: feature files are `flake-parts` modules that publish reusable flake outputs

Recommended future split:

- keep git, shell, editors, CLI tools, and generic user settings in `modules/home/common/`
- keep cross-platform GUI user apps like Ghostty in `modules/home/common/`
- for app-owned layouts, use `modules/home/common/<app>/default.nix` plus `modules/home/common/<app>/config/`
- keep language-specific dev environments in dedicated modules such as `modules/home/common/nodejs.nix`, `rust.nix`, and `bun.nix`
- keep Hyprland, Waybar, rofi, and similar desktop pieces in `modules/home/linux/`
- keep hardware, boot, networking, audio, and Linux services in `modules/system/nixos/`
- if you later add macOS, reuse `modules/home/common/` and add `modules/system/darwin/`
- Niri system enablement now lives in `modules/system/nixos/desktop-niri.nix`
- Niri user config lives in `modules/home/linux/niri/`
- Noctalia lives in `modules/home/linux/noctalia/`
