{
  lib, config, pkgs, repoRoot,
  ...
}: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    xdg.configFile."nvim".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim");

    home.packages = with pkgs; [
      ripgrep
      fd
      gcc
    ];
}
