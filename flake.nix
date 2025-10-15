{
  description = "hallwack flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nur.url = "github:nix-community/NUR";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nur,
    ...
  }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.hallnet = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit nur;};
      modules = [
        ./configuration.nix
        nur.modules.nixos.default
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.hallwack = import ./home-manager.nix;
            backupFileExtension = "backup";
            sharedModules = [
              nur.modules.homeManager.default
            ];
          };
        }
      ];
    };
  };
}
