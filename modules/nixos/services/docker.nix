{ config, lib, ... }:

{
  options.hallwack.services.docker.enable = lib.mkEnableOption "Enable Docker service";

  config = lib.mkIf config.hallwack.services.docker.enable {
    virtualisation.docker.enable = true;
  };
}
