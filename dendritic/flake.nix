{
  description = "hallwack dendritic sketch with flake-parts";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nur.url = "github:nix-community/NUR";
    flake-parts.url = "github:hercules-ci/flake-parts";
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.flake-parts.flakeModules.modules
        ./modules/system/nixos/base.nix
        ./modules/system/nixos/desktop-gnome.nix
        ./modules/system/nixos/desktop-hyprland.nix
        ./modules/system/nixos/desktop-niri.nix
        ./modules/system/nixos/audio.nix
        ./modules/system/nixos/bluetooth.nix
        ./modules/system/nixos/pcsc.nix
        ./modules/system/nixos/fonts.nix
        ./modules/system/nixos/user-hallwack.nix
        ./modules/system/nixos/shell.nix
        ./modules/home/common/user-hallwack.nix
        ./modules/home/common/shell.nix
        ./modules/home/common/git.nix
        ./modules/home/common/dev-tools.nix
        ./modules/home/common/nodejs.nix
        ./modules/home/common/rust.nix
        ./modules/home/common/bun.nix
        ./modules/home/common/ghostty
        ./modules/home/common/kitty
        ./modules/home/common/neovim
        ./modules/home/linux/desktop-hyprland.nix
        ./modules/home/linux/niri
        ./modules/home/linux/noctalia
        ./hosts/hallnet/default.nix
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.alejandra;
      };
    };
}
