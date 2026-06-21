{
  ...
}:
{
  flake.modules.nixos.desktop-niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.desktop-niri;
    in
    {
      options.desktop-niri.enable = lib.mkEnableOption "Niri desktop";

      config = lib.mkIf cfg.enable {
        programs.niri.enable = true;

        home-manager.users.hallwack.desktop-niri.enable = lib.mkDefault true;

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
          brave
          wl-clipboard
        ];
      };
    };
}
