{ config, pkgs, ... }:

let 
  dotfiles = "${config.home.homeDirectory}/hallnix/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    kitty = "kitty";
  };
in

{
  home.username = "hallwack";
  home.homeDirectory = "/home/hallwack";
  home.stateVersion = "25.05";

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "hallwack";
      user.email = "hallwack.id@gmail.com";
      init.defaultBranch = "main";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "[](#D65D0E)$os$username[](bg:#D79921 fg:#D65D0E)$directory[](fg:#D79921 bg:#689D6A)$git_branch$git_status[](fg:#689D6A bg:#458588)$c$bun$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:#458588 bg:#665C54)$docker_context$conda[](fg:#665C54 bg:#3C3836)$time[ ](fg:#3C3836)$line_break$character";
      username = {
        format = "[ $user ]($style)";
        show_always = true;
        style_root = "bg:#D65D0E fg:#FBF1C7";
        style_user = "bg:#D65D0E fg:#FBF1C7";
      };
      directory = {
        style = "fg:#FBF1C7 bg:#D79921";
        format = "[ $path ]($style)";
        truncation_length = 5;
        truncation_symbol = "…/";
      };
      directory.substitutions = {
        "Documents" = " ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
        "Important " = " ";
      };
      git_branch = {
        symbol = "";
        style = "bg:#689D6A";
        format = "[[ $symbol $branch ](fg:#FBF1C7 bg:#689D6A)]($style)";
      };
      git_status = {
        style = "bg:#689D6A";
        format = "[[($all_status$ahead_behind )](fg:#FBF1C7 bg:#689D6A)]($style)";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
      };
      nodejs = {
        symbol = "";
        style = "bg:#458588";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#458588)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:#458588";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#458588)]($style)";
      };
      python = {
        symbol = "";
        style = "bg:#458588";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#458588)]($style)";
      };
      docker_context = {
        symbol = "";
        style = "bg:#665C54";
        format = "[[ $symbol( $context) ](fg:#83A598 bg:#665C54)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#3C3836";
        format = "[[  $time ](fg:#FBF1C7 bg:#3C3836)]($style)";
      };
      line_break.disabled = false;
      character = {
        disabled = false;
        success_symbol = "[](bold fg:#98971A) ";
        error_symbol = "[](bold fg:#CC241D) ";
        vimcmd_symbol = "[](bold fg:#98971A) ";
        vimcmd_visual_symbol = "[](bold fg:#D79921) ";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      vi = "nvim";
      cls = "clear";
      cat = "batcat";
      cd = "z";
    };
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = [ "git" "vi-mode" "web-search" ];
    };
    initExtra = ''
      # custom function
      mkcp() { mkdir -p "$1" && cd "$1"; }
    '';
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    docker
    ripgrep
    nodejs
    rustup
    gcc
    vscode
    ghostty
    starship
    zoxide
    bat

    pass
    spotify
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",1920x1080@60,auto,1";
    };
  };
}
