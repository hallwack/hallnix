{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.system.bluetooth.enable =
    lib.mkEnableOption "Enable hallwack system bluetooth module";

  config = lib.mkIf config.hallwack.system.bluetooth.enable {
    environment.systemPackages = with pkgs; [
      bluez
      bluez-tools
      blueman
    ];

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = false;
    hardware.bluetooth.settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
    };

    services.blueman.enable = true;
  };
}
