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

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim";
    recursive = false; # penting! jangan expand isi direktori
  };

  home.packages = with pkgs; [
    ripgrep
    fd
    gcc
  ];
}
