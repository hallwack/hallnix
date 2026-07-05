{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.nix.enable = lib.mkEnableOption "Enable hallwack cli nix module";

  config = lib.mkIf config.hallwack.cli.nix.enable {
    home.packages = with pkgs; [
      nixd
      nixfmt
    ];
  };
}
