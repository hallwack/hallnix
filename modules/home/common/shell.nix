{
  ...
}:
{
  flake.modules.homeManager.shell =
    {
      config,
      pkgs,
      lib,
      repoRoot,
      ...
    }:
    {
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = false;
        autosuggestion.enable = false;
        syntaxHighlighting.enable = true;
        plugins = [
          {
            name = "zsh-vi-mode";
            src = pkgs.zsh-vi-mode;
            file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          }
        ];
        oh-my-zsh = {
          enable = true;
          theme = "";
          plugins = [
            "git"
            "web-search"
          ];
        };
        shellAliases = {
          vi = "nvim";
          cls = "clear";
          cat = "bat";
          cd = "z";
          ll = "ls -l";
          switch = "sudo nixos-rebuild switch --flake ${repoRoot}#hallnet";
        };
        history = {
          size = 10000;
          path = "$HOME/.zsh_history";
        };
        initContent = ''
          source "${config.xdg.configHome}/zsh/custom.zsh"
        '';
      };

      xdg.configFile."starship.toml".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/starship.toml"
      );

      xdg.configFile."zsh/custom.zsh".source = lib.mkForce (
        config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/zsh/custom.zsh"
      );
    };
}
