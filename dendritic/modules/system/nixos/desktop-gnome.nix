{
  ...
}: {
  flake.modules.nixos.desktop-gnome = {pkgs, ...}: {
    services.xserver = {
      enable = true;

      xkb.layout = "us";
      xkb.options = "caps:escape";
    };
      
    services.desktopManager.gnome.enable = true;

    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    services.udev.packages = with pkgs; [
      gnome-settings-daemon
      pcsc-tools
    ];

    programs.dconf.enable = true;
    services.libinput.enable = true;
  };
}
