{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      vi = "nvim";
      cls = "clear";
      cat = "bat";
      cd = "z";
      ll = "ls -l";
      switch = "sudo nixos-rebuild switch --flake ~/hallnix#hallnet";
    };
    
    oh-my-zsh = {
      enable = true;
      plugins = ["git" "vi-mode" "web-search"];
    };
    
    initContent = ''
      mkcp() { mkdir -p "$1" && cd "$1"; }
    '';
    
    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
    };
  };
}
