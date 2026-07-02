{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.desktop.gnome.enable = lib.mkEnableOption "Enable hallwack desktop gnome module";

  config = lib.mkIf config.hallwack.desktop.gnome.enable {
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
    ];

    environment.systemPackages = with pkgs; [
      brave
      wl-clipboard
      apple-cursor
      pcsc-tools
    ];

    programs.dconf.enable = true;
    services.libinput.enable = true;
  };
}
