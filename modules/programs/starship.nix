{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
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
}
