{
  ...
}:
{
  flake.modules.nixos.desktop-hyprland =
    { pkgs, ... }:
    {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

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
}
