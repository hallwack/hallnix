{
  ...
}: {
  flake.modules.homeManager.neovim = {
    config,
    lib,
    pkgs,
    repoRoot,
    ...
  }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = false;
      withRuby = false;
    };

      home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if [ -e "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
      rm -rf "$HOME/.config/nvim"
    fi
    ln -sfn "${repoRoot}/config/nvim" "$HOME/.config/nvim"
  '';

    home.packages = with pkgs; [
      ripgrep
      fd
      gcc
    ];
  };
}