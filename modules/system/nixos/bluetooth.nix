{
  ...
}:
{
  flake.modules.nixos.bluetooth =
    { pkgs, ... }:
    {
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = false;
      services.blueman.enable = true;

      environment.systemPackages = with pkgs; [
        bluez
        bluez-tools
        blueman
      ];
    };
}
