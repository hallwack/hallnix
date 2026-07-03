{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  options.hallwack.desktop.hyprland.enable =
    lib.mkEnableOption "Enable hallwack desktop hyprland module";

  config = lib.mkIf config.hallwack.desktop.hyprland.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
    programs.gpu-screen-recorder.enable = true;

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      brightnessctl
      playerctl
      apple-cursor
      brave
      wl-clipboard
    ];
  };
}
