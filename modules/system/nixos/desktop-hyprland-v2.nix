{
  ...
}:
{
  flake.modules.nixos.desktop-hyprland-v2 =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.desktop-hyprland-v2;
    in
    {
      options.desktop-hyprland-v2.enable = lib.mkEnableOption "Hyprland desktop v2";

      config = lib.mkIf cfg.enable {
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
        };

        home-manager.users.hallwack.desktop-hyprland-v2.enable = lib.mkDefault true;

        environment.systemPackages = with pkgs; [
          hyprpaper
          hyprlock
          hypridle
          hyprshot
          hyprsunset
          hyprcursor

          quickshell
          waybar
          tofi
          wob

          cliphist
          grimshot
          slurp
          jq
          networkmanagetapplet
          yazi

          brightnessctl
          playerctl
          brave
          wl-clipboard
          apple-cursor
        ];
      };
    };
}
