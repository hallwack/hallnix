{ config
, pkgs
, repoRoot
, ...
}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withPython3 = false;
    withRuby = false;
  };

  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink
      "${repoRoot}/config/nvim";

  home.packages = with pkgs; [
    ripgrep
    fd
    gcc
  ];
}
