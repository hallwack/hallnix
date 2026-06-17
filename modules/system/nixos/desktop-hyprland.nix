{
  ...
}:
{
  flake.modules.nixos.desktop-hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.desktop-hyprland;
    in
    {
      options.desktop-hyprland.enable = lib.mkEnableOption "Hyprland desktop";

      config = lib.mkIf cfg.enable {
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
        };

        home-manager.users.hallwack.desktop-hyprland.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [
          hyprpaper
          hyprlock
          hypridle
          hyprshot
          hyprcursor
          wlogout
          waybar
          rofi
          mako
          swaynotificationcenter
          brightnessctl
          playerctl
          brave
          wl-clipboard
          apple-cursor
        ];
      };
    };
}
