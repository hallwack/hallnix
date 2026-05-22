{ ...
}: {
  flake.modules.nixos.desktop-niri =
    { pkgs
    , ...
    }: {
      programs.niri.enable = true;

      security.polkit.enable = true;
      services.gnome.gnome-keyring.enable = true;

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.niri = {
          "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        };
      };

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        fuzzel
        apple-cursor
        brave
      ];
    };
}
