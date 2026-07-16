{
  config,
  lib,
  pkgs,
  repoRoot,
  ...
}:

{
  options.hallwack.cli.shell.enable = lib.mkEnableOption "Enable hallwack cli shell module";

  config = lib.mkIf config.hallwack.cli.shell.enable {
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
        lgit = "lazygit";
        ldock = "lazydocker";
        switch = "sudo nixos-rebuild switch --flake ${repoRoot}#hallnet";
        hg = "history | fzf --tac +s --tiebreak=index --preview 'echo {}' | awk '{print \$1}' | xargs -r zsh -c 'cd \$(history -p \!\!) && exec \$SHELL'";
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
