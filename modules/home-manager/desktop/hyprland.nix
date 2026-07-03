{
  config,
  lib,
  repoRoot,
  ...
}:

{
  options.hallwack.desktop.hyprland.enable =
    lib.mkEnableOption "Enable hallwack desktop hyprland module";

  config = lib.mkIf config.hallwack.desktop.hyprland.enable {
    xdg.configFile."hypr".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/hypr"
    );
  };
}
