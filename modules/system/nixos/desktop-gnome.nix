{
  ...
}:
{
  flake.modules.nixos.desktop-gnome =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.desktop-gnome;
    in
    {
      options.desktop-gnome.enable = lib.mkEnableOption "GNOME desktop";

      config = lib.mkIf cfg.enable {
        services.xserver = {
          enable = true;

          xkb.layout = "us";
          xkb.options = "caps:escape";
        };

        services.desktopManager.gnome.enable = true;

        services.displayManager.gdm = {
          enable = true;
        };

        services.udev.packages = with pkgs; [
          gnome-settings-daemon
          pcsc-tools
          brave
          wl-clipboard
          apple-cursor
        ];

        programs.dconf.enable = true;
        services.libinput.enable = true;
      };
    };
}
