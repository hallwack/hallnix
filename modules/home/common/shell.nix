{
  ...
}: {
  flake.modules.homeManager.shell = {
    repoRoot,
    ...
  }: {
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
      settings.add_newline = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "";
        plugins = ["git" "vi-mode" "web-search"];
      };
      shellAliases = {
        vi = "nvim";
        cls = "clear";
        cat = "bat";
        cd = "z";
        ll = "ls -l";
        switch = "sudo nixos-rebuild switch --flake ${repoRoot}#hallnet";
      };
      initContent = ''
        mkcp() { mkdir -p "$1" && cd "$1"; }
      '';
      history = {
        size = 10000;
        path = "$HOME/.zsh_history";
      };
    };
  };
}
