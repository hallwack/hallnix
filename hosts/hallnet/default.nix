{ config
, inputs
, self
, lib
, ...
}:
let
  repoRoot = "/home/hallwack/hallnix";
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations.hallnet = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit repoRoot self lib system;
      inherit (inputs) nur;
      appleFonts =
        inputs.apple-fonts.packages.${system};
    };
    modules = [
      ./hardware-configuration.nix
      {
        nixpkgs.config.allowUnfree = true;
      }
      inputs.nur.modules.nixos.default
      inputs.home-manager.nixosModules.home-manager
      config.flake.modules.nixos.base
      config.flake.modules.nixos.desktop-gnome
      config.flake.modules.nixos.desktop-niri
      config.flake.modules.nixos.audio
      config.flake.modules.nixos.bluetooth
      config.flake.modules.nixos.pcsc
      config.flake.modules.nixos.fonts
      config.flake.modules.nixos.user-hallwack
      config.flake.modules.nixos.shell
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          sharedModules = [
            config.flake.modules.homeManager.user-hallwack
            config.flake.modules.homeManager.shell
            config.flake.modules.homeManager.git
            config.flake.modules.homeManager.dev-tools
            config.flake.modules.homeManager.nix
            config.flake.modules.homeManager.nodejs
            config.flake.modules.homeManager.rust
            config.flake.modules.homeManager.bun
            config.flake.modules.homeManager.ghostty
            config.flake.modules.homeManager.kitty
            config.flake.modules.homeManager.neovim
            config.flake.modules.homeManager.niri
            config.flake.modules.homeManager.noctalia
          ];
          users.hallwack = { };
          extraSpecialArgs = {
            inherit repoRoot self;
            appleFonts =
              inputs.apple-fonts.packages.${system};
          };
        };
      }
    ];
  };
}
