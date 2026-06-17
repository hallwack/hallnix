{
  ...
}:
{
  flake.modules.homeManager.desktop-hyprland =
    {
      config,
      lib,
      repoRoot,
      ...
    }:
    let
      cfg = config.desktop-hyprland;
    in
    {
      options.desktop-hyprland.enable = lib.mkEnableOption "Hyprland desktop user configuration";

      config = lib.mkIf cfg.enable {
        # xdg.configFile = {
        #   "hypr".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/hyprland");
        #   "waybar".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/waybar");
        #   "rofi".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/rofi");
        #   "mako".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/mako");
        #   "swaync".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/swaync");
        # };
      };
    };
}
