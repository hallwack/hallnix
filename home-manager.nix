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
      format = "[](0xd65d0e)$os$username[](bg:0xd79921 fg:0xd65d0e)$directory[](fg:0xd79921 bg:0x689d6a)$git_branch$git_status[](fg:0x689d6a bg:0x458588)$c$bun$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:0x458588 bg:0x665c54)$docker_context$conda[](fg:0x665c54 bg:0x3c3836)$time[ ](fg:0x3c3836)$line_break$character";
      username = {
        format = "[ $user ]($style)";
        show_always = true;
        style_root = "bg:0xd65d0e fg:0xfbf1c7";
        style_user = "bg:0xd65d0e fg:0xfbf1c7";
      };
      directory = {
        style = "fg:0xfbf1c7 bg:0xd79921";
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
        style = "bg:0x689d6a";
        format = "[[ $symbol $branch ](fg:0xfbf1c7 bg:0x689d6a)]($style)";
      };
      git_status = {
        style = "bg:0x689d6a";
        format = "[[($all_status$ahead_behind )](fg:0xfbf1c7 bg:0x689d6a)]($style)";
        ahead = "⇡\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        behind = "⇣\${count}";
      };
      nodejs = {
        symbol = "";
        style = "bg:0x458588";
        format = "[[ $symbol( $version) ](fg:0xfbf1c7 bg:0x458588)]($style)";
      };
      rust = {
        symbol = "";
        style = "bg:0x458588";
        format = "[[ $symbol( $version) ](fg:0xfbf1c7 bg:0x458588)]($style)";
      };
      python = {
        symbol = "";
        style = "bg:0x458588";
        format = "[[ $symbol( $version) ](fg:0xfbf1c7 bg:0x458588)]($style)";
      };
      docker_context = {
        symbol = "";
        style = "bg:0x665c54";
        format = "[[ $symbol( $context) ](fg:0x83a598 bg:0x665c54)]($style)";
      };
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:0x3c3836";
        format = "[[  $time ](fg:0xfbf1c7 bg:0x3c3836)]($style)";
      };
      line_break.disabled = false;
      character = {
        disabled = false;
        success_symbol = "[](bold fg:0x98971a) ";
        error_symbol = "[](bold fg:0xcc241d) ";
        vimcmd_symbol = "[](bold fg:0x98971a) ";
        vimcmd_visual_symbol = "[](bold fg:0xd79921) ";
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
