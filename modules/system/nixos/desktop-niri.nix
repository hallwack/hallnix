{
  ...
}:
{
  flake.modules.nixos.desktop-niri =
    {
      pkgs,
      ...
    }:
    {
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
          default = [ "gnome" "gtk" ];
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        brightnessctl
        fuzzel
        apple-cursor
        brave
        wl-clipboard
      ];
    };
}
