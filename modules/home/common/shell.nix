{
  ...
}: {
  flake.modules.homeManager.shell = {
    config,
    lib,
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
        source "${config.xdg.configHome}/zsh/custom.zsh"
      '';
      history = {
        size = 10000;
        path = "$HOME/.zsh_history";
      };
    };

    xdg.configFile."starship.toml".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/starship.toml");

    xdg.configFile."zsh/custom.zsh".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/zsh/custom.zsh");
  };
}
