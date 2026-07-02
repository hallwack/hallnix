{
  config,
  lib,
  repoRoot,
  ...
}:

{
  options.hallwack.desktop.niri.enable = lib.mkEnableOption "Enable hallwack desktop niri module";

  config = lib.mkIf config.hallwack.desktop.niri.enable {
    xdg.configFile."niri".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri"
    );
  };
}
