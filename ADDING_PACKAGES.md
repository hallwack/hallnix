# Adding Packages And Configuration

This guide explains where to add packages and configuration in the current dendritic layout.

## Rule Of Thumb

Choose the location by scope:

- `modules/nixos/`: machine-wide NixOS configuration.
- `modules/home-manager/`: user-level Home Manager configuration.
- `config/`: editable dotfiles linked by Home Manager.
- `pkgs/`: local package definitions.
- `flake.nix`: upstream flake inputs and top-level flake composition.

Choose the module by ownership:

- one app owns its package and config
- one language/runtime owns its toolchain packages
- one system feature owns its related services and OS options

## System Packages And Services

Put Linux system concerns in `modules/nixos/`.

Examples:

- boot loader
- networking
- audio
- Bluetooth
- display manager
- desktop environment or compositor enablement
- system services
- system-wide packages required by the OS

Current examples:

```text
modules/nixos/system/core.nix
modules/nixos/system/audio.nix
modules/nixos/system/bluetooth.nix
modules/nixos/system/fonts.nix
modules/nixos/system/pcsc.nix
modules/nixos/system/shell.nix
modules/nixos/system/users.nix
modules/nixos/services/openssh.nix
modules/nixos/desktop/gnome.nix
modules/nixos/desktop/niri.nix
```

Minimal pattern:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.system.example.enable =
    lib.mkEnableOption "Enable example system feature";

  config = lib.mkIf config.hallwack.system.example.enable {
    environment.systemPackages = with pkgs; [
      example
    ];
  };
}
```

Then enable it in `hosts/hallnet/configuration.nix`:

```nix
hallwack.system.example.enable = true;
```

## User Packages And Dotfiles

Put user-level concerns in `modules/home-manager/`.

Examples:

- Git config
- Zsh config
- Neovim config
- terminal config
- user packages
- files under `~/.config`
- user-session desktop config

Current examples:

```text
modules/home-manager/user/hallwack.nix
modules/home-manager/cli/git.nix
modules/home-manager/cli/shell.nix
modules/home-manager/cli/nodejs.nix
modules/home-manager/cli/rust.nix
modules/home-manager/cli/dev-tools.nix
modules/home-manager/editors/neovim.nix
modules/home-manager/terminal/ghostty.nix
modules/home-manager/terminal/kitty.nix
modules/home-manager/desktop/niri.nix
modules/home-manager/desktop/noctalia.nix
```

Minimal pattern:

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.cli.example.enable =
    lib.mkEnableOption "Enable example user tool";

  config = lib.mkIf config.hallwack.cli.example.enable {
    home.packages = with pkgs; [
      example
    ];
  };
}
```

Then enable it in `hosts/hallnet/home.nix`:

```nix
hallwack.cli.example.enable = true;
```

## Adding A New CLI Tool

If it belongs to an existing concern, add it there:

- Git-related tools: `modules/home-manager/cli/git.nix`
- Rust tools: `modules/home-manager/cli/rust.nix`
- Node.js tools: `modules/home-manager/cli/nodejs.nix`
- general CLI tools: `modules/home-manager/cli/dev-tools.nix`
- editor support tools: `modules/home-manager/editors/neovim.nix`

If it deserves its own toggle, create a new module under `modules/home-manager/cli/`.

## Adding A New App

Create an app-owned Home Manager module.

Example:

```text
modules/home-manager/terminal/alacritty.nix
```

```nix
{ config, lib, pkgs, repoRoot, ... }:

{
  options.hallwack.terminal.alacritty.enable =
    lib.mkEnableOption "Alacritty terminal";

  config = lib.mkIf config.hallwack.terminal.alacritty.enable {
    home.packages = with pkgs; [
      alacritty
    ];

    xdg.configFile."alacritty".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/alacritty"
    );
  };
}
```

Because `modules/home-manager/default.nix` auto-imports modules recursively, you do not need to manually add this file to `flake.nix`.

## Adding A New Language Runtime

Create one module per runtime under `modules/home-manager/cli/`.

Examples:

```text
modules/home-manager/cli/nodejs.nix
modules/home-manager/cli/rust.nix
```

This keeps language-specific packages out of the generic user package list.

## Adding A New Window Manager Or Desktop

Split it into two layers when it has both system and user concerns:

```text
modules/nixos/desktop/<name>.nix
modules/home-manager/desktop/<name>.nix
```

The NixOS module owns:

- `programs.<wm>.enable`
- display manager/session integration
- portals
- polkit/keyring if needed
- system packages needed by the compositor/session

The Home Manager module owns:

- `xdg.configFile`
- user config files
- panel/shell config
- user-session scripts

Enable the system layer in:

```text
hosts/hallnet/configuration.nix
```

Enable the user layer in:

```text
hosts/hallnet/home.nix
```

## Local Packages

Use `pkgs/` for local package definitions:

```text
pkgs/helium-browser/default.nix
pkgs/zennotes/default.nix
```

Use `home.packages` when the package is for the user environment.

Use `environment.systemPackages` when the package must be available system-wide or supports an OS-level feature.

## Auto-Import Rules

Both module roots are auto-imported:

```text
modules/nixos/default.nix
modules/home-manager/default.nix
```

Do not place non-module helper files directly under those trees unless they are excluded. Current auto-import excludes:

- `default.nix`
- paths containing `/_`

If you need helper files, prefer:

```text
modules/home-manager/_lib/
modules/nixos/_lib/
```

## Current Gaps To Keep In Mind

Compared with the older `dendritic` branch, this branch does not currently include separate Home Manager modules for every previous tool. If you still need them, add modules such as:

```text
modules/home-manager/cli/bun.nix
modules/home-manager/cli/nix.nix
```

Hyprland also has a Home Manager placeholder, but the NixOS Hyprland system module has not been recreated in this branch.
