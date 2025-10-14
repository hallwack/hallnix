{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./user.nix
    ./nix.nix
    ./fonts.nix
  ];
}
