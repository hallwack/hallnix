{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.desktop.niri.enable = lib.mkEnableOption "Enable hallwack desktop niri module";

  config = lib.mkIf config.hallwack.desktop.niri.enable {
    programs.niri.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      config.niri = {
        default = [
          "gnome"
          "gtk"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
      playerctl
      apple-cursor
      wl-clipboard
      networkmanagerapplet

      grim
      slurp
      satty
    ];
  };
}
