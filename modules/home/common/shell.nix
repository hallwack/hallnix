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
      enableCompletion = false;
      autosuggestion.enable = false;
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
      history = {
        size = 10000;
        path = "$HOME/.zsh_history";
      };
    };

    xdg.configFile."starship.toml".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/starship.toml");

    home.file.".zshrc".source =
      lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/.zshrc");
  };
}
