{
  config,
  lib,
  pkgs,
  repoRoot,
  ...
}:

{
  options.hallwack.editors.neovim.enable = lib.mkEnableOption "Neovim terminal";

  config = lib.mkIf config.hallwack.editors.neovim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      sideloadInitLua = true;

      # Download treesitter languages
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];

      extraPackages = with pkgs; [
        # Treesitter Build tools
        tree-sitter
        gcc
        gnumake

        # Tools required
        ripgrep
        fd
        fzf

        # Language Servers and Formatters
        # Lua
        lua-language-server
        stylua

        # Nix
        nixd
        nixfmt
      ];

      withPython3 = false;
      withRuby = false;
    };

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
    };

    home.shellAliases = {
      vi = "nvim";
      vim = "nvim";
    };

    xdg.configFile."nvim".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/nvim"
    );
  };
}
