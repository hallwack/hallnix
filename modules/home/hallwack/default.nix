{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../programs
  ];

  home = {
    username = "hallwack";
    homeDirectory = "/home/hallwack";
    stateVersion = "25.05";
  };

  home.packages = with pkgs; [
    docker
    ripgrep
    nodejs
    rustup
    gcc
    vscode
    ghostty
    bat
    dbeaver-bin
    pass
    spotify
  ];

  programs.home-manager.enable = true;
}
