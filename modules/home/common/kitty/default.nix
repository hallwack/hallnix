{ ...
}: {
  flake.modules.homeManager.kitty = { pkgs, config, repoRoot, ... }: {
    home.packages = with pkgs; [
      kitty
    ];

    xdg.configFile."kitty".source = config.lib.file.mkOutOfStoreSymlink
      "${repoRoot}/config/kitty";
  };
}
