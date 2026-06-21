{
  ...
}:
{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
      hardware.bluetooth.settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
      };

      services.blueman.enable = true;

      environment.systemPackages = with pkgs; [
        bluez
        bluez-tools
        blueman
      ];
    };
}
