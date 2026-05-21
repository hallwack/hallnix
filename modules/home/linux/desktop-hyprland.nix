{
  ...
}: {
  flake.modules.homeManager.desktop-hyprland = {
    config,
    lib,
    repoRoot,
    ...
  }: {
    # xdg.configFile = {
    #   "hypr".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/hyprland");
    #   "waybar".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/waybar");
    #   "rofi".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/rofi");
    #   "mako".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/mako");
    #   "swaync".source = lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/swaync");
    # };
  };
}
