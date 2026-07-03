{
  description = "hallwack nixos configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";

    flake-parts.url = "github:hercules-ci/flake-parts";

    hallnix.url = "github:hallwack/hallwack-nix-pkgs";

    zennotes.url = "github:ZenNotes/zennotes";

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./hosts/hallnet
      ];

      systems = [
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.alejandra;
        };
    };
}
