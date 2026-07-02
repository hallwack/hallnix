{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.nodejs.enable = lib.mkEnableOption "Enable hallwack cli nodejs module";

  config = lib.mkIf config.hallwack.cli.nodejs.enable {
    home.packages = with pkgs; [
      nodejs
    ];
  };
}
