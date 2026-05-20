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
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/dendritic/modules/home/linux/niri/config");
  };
}
