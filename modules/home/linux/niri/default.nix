{
  ...
}:
{
  flake.modules.homeManager.niri =
    {
      config,
      lib,
      repoRoot,
      ...
    }:
    let
      cfg = config.desktop-niri;
    in
    {
      options.desktop-niri.enable = lib.mkEnableOption "Niri desktop user configuration";

      config = lib.mkIf cfg.enable {
        xdg.configFile."niri".source = lib.mkForce (
          config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri"
        );
      };
    };
}
