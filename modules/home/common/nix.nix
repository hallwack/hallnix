{
  ...
}: {
  flake.modules.homeManager.nix = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      nixpkgs-fmt
      nixd
    ];
  };
}
