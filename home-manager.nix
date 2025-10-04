{ config, pkgs, ... }:

let 
  dotfiles = "${config.home.homeDirectory}/hallnix/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
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
  
  programs.zsh = {
    enable = true;
  };

  home.packages = with pkgs; [
    docker
    ripgrep
    nodejs
    gcc
    vscode
    ghostty

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
