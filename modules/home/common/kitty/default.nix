{
  ...
}:
{
  flake.modules.homeManager.kitty =
    {
      pkgs,
      config,
      repoRoot,
      lib,
      ...
    }:
    {
      home.packages = with pkgs; [
        kitty
      ];

      xdg.configFile."kitty".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty"
      );
    };
}
