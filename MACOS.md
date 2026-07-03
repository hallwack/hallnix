# macOS And nix-darwin

This repository is currently NixOS-first, but the current structure can be extended to macOS with `nix-darwin`.

The important split is:

```text
modules/nixos/          -> NixOS-only system modules
modules/home-manager/   -> Home Manager user modules
modules/darwin/         -> future nix-darwin system modules
```

## What Changes On macOS

On NixOS, hosts are created with:

```nix
inputs.nixpkgs.lib.nixosSystem
```

On macOS, hosts are created with:

```nix
inputs.nix-darwin.lib.darwinSystem
```

Home Manager is still used, but through the Darwin integration:

```nix
inputs.home-manager.darwinModules.home-manager
```

## Recommended Future Layout

Add a Mac host and Darwin module root:

```text
hosts/
  hallnet/
    default.nix
    configuration.nix
    home.nix
    hardware-configuration.nix
  macbook/
    default.nix
    configuration.nix
    home.nix

modules/
  nixos/
  home-manager/
  darwin/
    default.nix
    system/
      core.nix
      users.nix
      homebrew.nix
      fonts.nix
```

## Flake Input

Add `nix-darwin` to `flake.nix`:

```nix
nix-darwin = {
  url = "github:nix-darwin/nix-darwin";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Then import the Mac host:

```nix
imports = [
  ./hosts/hallnet
  ./hosts/macbook
];
```

Add the Darwin system to `systems` if you want per-system outputs for macOS:

```nix
systems = [
  "x86_64-linux"
  "aarch64-darwin"
];
```

Use `aarch64-darwin` for Apple Silicon and `x86_64-darwin` for Intel Macs.

## Example Darwin Host

Create:

```text
hosts/macbook/default.nix
```

Example:

```nix
{
  inputs,
  self,
  ...
}:

let
  system = "aarch64-darwin";
  username = "hallwack";
  hostname = "macbook";
  repoRoot = "/Users/${username}/hallnix";
in
{
  flake.darwinConfigurations.${hostname} = inputs.nix-darwin.lib.darwinSystem {
    inherit system;

    specialArgs = {
      inherit inputs self system username hostname repoRoot;
    };

    modules = [
      ./configuration.nix
      ../../modules/darwin

      inputs.home-manager.darwinModules.home-manager

      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";

          sharedModules = [
            ../../modules/home-manager
          ];

          users.${username} = import ./home.nix;

          extraSpecialArgs = {
            inherit inputs self system username hostname repoRoot;
          };
        };
      }
    ];
  };
}
```

## Example Darwin Configuration

Create:

```text
hosts/macbook/configuration.nix
```

Example:

```nix
{ username, hostname, ... }:

{
  networking.hostName = hostname;
  networking.computerName = hostname;

  users.users.${username}.home = "/Users/${username}";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = 6;

  hallwack.darwin.core.enable = true;
  hallwack.darwin.users.enable = true;
}
```

## Example Darwin Home

Create:

```text
hosts/macbook/home.nix
```

Example:

```nix
{ username, ... }:

{
  home = {
    username = username;
    homeDirectory = "/Users/${username}";
    stateVersion = "25.05";
  };

  hallwack.user.enable = true;
  hallwack.cli.git.enable = true;
  hallwack.cli.shell.enable = true;
  hallwack.cli.nodejs.enable = true;
  hallwack.cli.rust.enable = true;
  hallwack.editors.neovim.enable = true;
  hallwack.terminal.ghostty.enable = true;
}
```

## Example Darwin Module Root

Create:

```text
modules/darwin/default.nix
```

Use the same auto-import pattern as `modules/nixos/default.nix`:

```nix
{ lib, ... }:

let
  allFiles = lib.filesystem.listFilesRecursive ./.;

  isModule =
    file:
    let
      path = builtins.toString file;
      name = builtins.baseNameOf file;
    in
    lib.hasSuffix ".nix" path && name != "default.nix" && !(lib.hasInfix "/_" path);

  modules = lib.filter isModule allFiles;
in
{
  imports = modules;
}
```

## Example Darwin System Module

```nix
{ config, lib, pkgs, ... }:

{
  options.hallwack.darwin.core.enable =
    lib.mkEnableOption "Enable core Darwin configuration";

  config = lib.mkIf config.hallwack.darwin.core.enable {
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    environment.systemPackages = with pkgs; [
      curl
      git
      vim
      wget
    ];

    system.defaults.dock.autohide = true;
    system.defaults.finder.AppleShowAllExtensions = true;
  };
}
```

## Reusing Home Manager Modules

Good candidates for macOS reuse:

```text
modules/home-manager/cli/git.nix
modules/home-manager/cli/shell.nix
modules/home-manager/cli/nodejs.nix
modules/home-manager/cli/rust.nix
modules/home-manager/editors/neovim.nix
modules/home-manager/terminal/ghostty.nix
modules/home-manager/terminal/kitty.nix
```

Linux-only modules should either be disabled on macOS or guarded:

```text
modules/home-manager/desktop/niri.nix
modules/home-manager/desktop/noctalia.nix
modules/nixos/*
```

Use guards for Linux-specific Home Manager settings:

```nix
gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;

dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
  "org/gnome/desktop/input-sources" = {
    xkb-options = [ "caps:escape" ];
  };
};
```

## Do Not Reuse NixOS Modules On Darwin

Do not import `modules/nixos` into a Darwin system. These options are Linux/NixOS-specific:

```nix
services.xserver
services.pipewire
services.blueman
programs.niri
hardware.bluetooth
boot.loader
```

Create Darwin equivalents under `modules/darwin`.

## Suggested Migration Plan

1. Add the `nix-darwin` input.
2. Add `modules/darwin/default.nix`.
3. Add minimal Darwin modules under `modules/darwin/system/`.
4. Add `hosts/macbook/default.nix`.
5. Add `hosts/macbook/configuration.nix`.
6. Add `hosts/macbook/home.nix`.
7. Reuse only Home Manager modules that are cross-platform or guarded.
8. Run `darwin-rebuild switch --flake .#macbook` on the Mac.
