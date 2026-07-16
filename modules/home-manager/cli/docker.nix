{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.docker.enable = lib.mkEnableOption "Enable hallwack cli docker module";

  config = lib.mkIf config.hallwack.cli.docker.enable {
    virtualisation.docker = {
      enable = true;
    };

    home.packages = with pkgs; [
      lazydocker
      dive
    ];
  };
}
