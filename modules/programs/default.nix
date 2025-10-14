{
  config,
  pkgs,
  ...
}: let
  dotfiles = "${config.home.homeDirectory}/hallnix/config";
in {
  imports = [
    ./direnv.nix
    ./fastfetch.nix
    ./git.nix
    ./starship.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # GTK
  gtk = {
    enable = true;
    theme.name = "Adwaita-dark";
    iconTheme.name = "Papirus";
  };

  # Dconf
  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      xkb-options = ["caps:escape"];
    };
  };

  # Symlink config files
  xdg.configFile = {
    "nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
    "kitty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/kitty";
    "hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hyprland";
    "ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/ghostty";
    "waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    "rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/rofi";
  };
}
