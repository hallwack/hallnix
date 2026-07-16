{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.docker.enable = lib.mkEnableOption "Enable hallwack cli docker home module";

  config = lib.mkIf config.hallwack.cli.docker.enable {
    home.packages = with pkgs; [
      lazydocker
      dive
    ];
  };
}
