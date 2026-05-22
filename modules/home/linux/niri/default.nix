{
  ...
}: {
  flake.modules.homeManager.niri = {
    config,
    lib,
    repoRoot,
    ...
  }: {
    xdg.configFile."niri".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri");
  };
}
