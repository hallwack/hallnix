{
  inputs,
  self,
  ...
}:

let
  system = "x86_64-linux";
  username = "hallwack";
  hostname = "hallnet";
  repoRoot = "/home/hallwack/hallnix";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs.lib.nixosSystem {
    inherit system;

    specialArgs = {
      inherit
        inputs
        self
        system
        username
        hostname
        repoRoot
        ;
      appleFonts = inputs.apple-fonts.packages.${system};
      codex = inputs.codex-cli-nix.packages.${system}.default;
    };
    modules = [
      ./configuration.nix
      ../../modules/nixos

      inputs.nur.modules.nixos.default
      inputs.home-manager.nixosModules.home-manager

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
            inherit
              inputs
              self
              system
              username
              hostname
              repoRoot
              ;
            appleFonts = inputs.apple-fonts.packages.${system};
            codex = inputs.codex-cli-nix.packages.${system}.default;
          };
        };
      }
    ];
  };
}
