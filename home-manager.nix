{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/hallnix/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    kitty = "kitty";
  };
in {
  home.username = "hallwack";
  home.homeDirectory = "/home/hallwack";
  home.stateVersion = "25.05";

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      # List, jadi bisa ditambahin opsi lain juga
      xkb-options = ["caps:escape"];
    };
  };

  programs.git = {
    enable = true;
    extraConfig = {
      user.name = "hallwack";
      user.email = "hallwack.id@gmail.com";
      init.defaultBranch = "main";
    };
  };

  home.file.".config/fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "logo": {
        "padding": {
          "top": 1,
          "left": 6,
          "right": 4
        }
      },
      "display": {
        "separator": "",
        "size": {
          "binaryPrefix": "si",
          "ndigits": 0
        },
        "percent": {
          "type": 2
        },
        "bar": {
          "charElapsed": "",
          "charTotal": " "
        },
        "key": {
          "width": 6
        }
      },
      "modules": [
        {
          "type": "title",
          "color": {
            "user": "35",
            "host": "36"
          }
        },
        {
          "type": "separator",
          "string": "▔"
        },
        {
          "type": "os",
          "key": "╭─",
          "format": "{3} ({12})",
          "keyColor": "32"
        },
        {
          "type": "host",
          "key": "├─󰟀",
          "keyColor": "32"
        },
        {
          "type": "kernel",
          "key": "├─󰒔",
          "format": "{1} {2}",
          "keyColor": "32"
        },
        {
          "type": "shell",
          "key": "├─$",
          "format": "{1} {4}",
          "keyColor": "32"
        },
        {
          "type": "packages",
          "key": "├─",
          "keyColor": "32"
        },
        {
          "type": "uptime",
          "key": "╰─󰔚",
          "keyColor": "32"
        },
        "break",
        {
          "type": "cpu",
          "key": "╭─",
          "keyColor": "34",
          "freqNdigits": 1
        },
        {
          "type": "board",
          "key": "├─󱤓",
          "keyColor": "34"
        },
        {
          "type": "gpu",
          "key": "├─󰢮",
          "format": "{1} {2} ({3})",
          "keyColor": "34"
        },
        {
          "type": "sound",
          "key": "├─󰓃",
          "format": "{2}",
          "keyColor": "34"
        },
        {
          "type": "battery",
          "key": "├─󰁹",
          "keyColor": "34"
        },
        {
          "type": "memory",
          "key": "├─",
          "keyColor": "34"
        },
        {
          "type": "swap",
          "key": "├─󰿡",
          "keyColor": "34"
        },
        {
          "type": "disk",
          "key": "├─󰋊",
          "keyColor": "34"
        },
        {
          "type": "localip",
          "key": "╰─󱦂",
          "keyColor": "34",
          "showIpv4": true,
          "compact": true
        },
        "break",
        {
          "type": "display",
          "key": "╭─󰹑",
          "keyColor": "33",
          "compactType": "original"
        },
        {
          "type": "de",
          "key": "├─󰧨",
          "keyColor": "33"
        },
        {
          "type": "wm",
          "key": "├─",
          "keyColor": "33"
        },
        {
          "type": "theme",
          "key": "├─󰉼",
          "keyColor": "33"
        },
        {
          "type": "icons",
          "key": "├─",
          "keyColor": "33"
        },
        {
          "type": "cursor",
          "key": "├─󰳽",
          "keyColor": "33"
        },
        {
          "type": "font",
          "key": "├─",
          "format": "{2}",
          "keyColor": "33"
        },
        {
          "type": "terminal",
          "key": "╰─",
          "format": "{3}",
          "keyColor": "33"
        },
        "break",
        {
          "type": "colors",
          "symbol": "block"
        },
        "break"
      ]
    }
  '';

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
    settings = {
      add_newline = true;
      format = "[](#D65D0E)$os(#D65D0E)$username[](bg:#D79921 fg:#D65D0E)$directory[](fg:#D79921 bg:#689D6A)$git_branch$git_status[](fg:#689D6A bg:#83A598)$c$bun$rust$golang$nodejs$php$java$kotlin$haskell$python[](fg:#83A598 bg:#458588)$direnv[](fg:#458588 bg:#665C54)$docker_context$conda[](fg:#665C54 bg:#3C3836)$time[ ](fg:#3C3836)$line_break$character";
      username = {
        format = "[ $user ]($style)";
        show_always = true;
        style_root = "bg:#D65D0E fg:#FBF1C7";
        style_user = "bg:#D65D0E fg:#FBF1C7";
      };
      os = {
        disabled = false;
        style = "bg:#D65D0E fg:#FBF1C7";
      };
      os.symbols = {
        Windows = "󰍲 ";
        Ubuntu = "󰕈 ";
        SUSE = " ";
        Raspbian = "󰐿 ";
        Mint = "󰣭 ";
        Macos = "󰀵 ";
        Manjaro = " ";
        Linux = "󰌽 ";
        Gentoo = "󰣨 ";
        Fedora = "󰣛 ";
        Alpine = " ";
        Android = " ";
        Arch = "󰣇 ";
        Artix = "󰣇 ";
        CentOS = " ";
        Debian = "󰣚 ";
        Redhat = "󱄛 ";
        RedHatEnterprise = "󱄛 ";
        NixOS = " ";
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
      direnv = {
        disabled = false;
        format = "[[ $symbol$loaded/$allowed ](fg:#FBF1C7 bg:#458588)]($style)";
        style = "bg:#458588";
        symbol = "📦 ";
      };
      git_branch = {
        symbol = " ";
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
      php = {
        symbol = "🐘 ";
        style = "bg:#83A598";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#83A598)]($style)";
      };
      nodejs = {
        symbol = " ";
        style = "bg:#83A598";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#83A598)]($style)";
      };
      rust = {
        symbol = " ";
        style = "bg:#83A598";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#83A598)]($style)";
      };
      python = {
        symbol = " ";
        style = "bg:#83A598";
        format = "[[ $symbol( $version) ](fg:#FBF1C7 bg:#83A598)]($style)";
      };
      docker_context = {
        symbol = " ";
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
      cat = "bat";
      cd = "z";
      switch = "sudo nixos-rebuild switch --flake ~/hallnix#hallnet";
    };
    oh-my-zsh = {
      enable = true;
      theme = "";
      plugins = ["git" "vi-mode" "web-search"];
    };
    initContent = ''
      # custom function
      mkcp() { mkdir -p "$1" && cd "$1"; }
    '';
  };

  xdg.configFile =
    builtins.mapAttrs
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
    dbeaver-bin

    pass
    spotify
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",1920x1080@60,auto,1";

      env = ["XCURSOR_THEME,Adawaita" "XCURSOR_SIZE,24"];

      input = {
        follow_mouse = 2;
        touchpad = {
          natural_scroll = true;
        };
      };

      cursor = {
        no_warps = true;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, T, exec, kitty"
        "$mainMod, C, killactive"
        "$mainMod, M, exit"
        "$mainMod, E, exec, nautilus"
        "$mainMod, V, togglefloating"
        "$mainMod, SPACE, exec, rofi -show drun"
        "$mainMod, P, pseudo"
        "$mainMod, B, exec, brave"
        "$mainMod, s, togglesplit"
        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, F, fullscreen"
        "ALT, TAB, cyclenext"
        "ALT, TAB, bringactivetotop"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Papirus";
  };
}
