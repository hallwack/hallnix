{ ...
}: {
  flake.modules.homeManager.ghostty = { pkgs, lib, config, repoRoot, ... }: {
    home.packages = with pkgs; [
      ghostty
    ];

    xdg.configFile."config/ghostty".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/ghostty");
  };
}
