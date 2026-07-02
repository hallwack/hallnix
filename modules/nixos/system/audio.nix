{ config, lib, ... }:

{
  options.hallwack.system.audio.enable = lib.mkEnableOption "Enable hallwack system audio module";

  config = lib.mkIf config.hallwack.system.audio.enable {
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
