{
  ...
}: {
  flake.modules.nixos.desktop-gnome = {pkgs, ...}: {
    services.xserver.enable = true;
    services.xserver = {
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      desktopManager.gnome.enable = true;
      xkb.layout = "us";
      xkb.options = "caps:escape";
    };

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
      pcsc-tools
    ];

    programs.dconf.enable = true;
    services.libinput.enable = true;
  };
}
