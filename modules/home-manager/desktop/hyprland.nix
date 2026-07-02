{
  config,
  lib,
  ...
}:

{
  options.hallwack.desktop.hyprland.enable =
    lib.mkEnableOption "Enable hallwack desktop hyprland module";

  config = lib.mkIf config.hallwack.desktop.hyprland.enable {
  };
}
