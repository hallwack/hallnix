{ ...
}: {
  flake.modules.homeManager.neovim =
    { config
    , lib
    , pkgs
    , repoRoot
    , ...
    }: {
      home.packages = with pkgs; [
        neovim
        ripgrep
        fd
        gcc
        stylua
        lua-language-server
        tree-sitter
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        SUDO_EDITOR = "nvim";
      };

      home.shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };

      xdg.configFile."nvim".source =
        lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim");
    };
}
