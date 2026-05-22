{ ...
}: {
  flake.modules.homeManager.kitty = { pkgs, lib, config, repoRoot, ... }: {
    home.packages = with pkgs; [
      kitty
    ];

    xdg.configFile."config/kitty".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty");
  };
}
