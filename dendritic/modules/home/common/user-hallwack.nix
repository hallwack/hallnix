{
  ...
}: {
  flake.modules.homeManager.user-hallwack = {
    pkgs,
    ...
  }: {
    home.username = "hallwack";
    home.homeDirectory = "/home/hallwack";
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
      docker
      ripgrep
      gcc
      vscode
      bat
      dbeaver-bin
      lazygit
      zed-editor
      pass
      spotify
      starship
      zoxide
    ];

    programs.home-manager.enable = true;

    gtk = {
      enable = true;
      theme.name = "Adwaita-dark";
      iconTheme.name = "Papirus";
    };

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:escape"];
      };
    };
  };
}
