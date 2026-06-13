{
  inputs,
  ...
}: {
  flake.modules.homeManager.user-hallwack = {
    pkgs,
    self,
    ...
  }: {
    home.username = "hallwack";
    home.homeDirectory = "/home/hallwack";
    home.stateVersion = "25.05";
    home.pointerCursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 26;
      gtk.enable = true;
      x11.enable = true;
    };

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
      jq
      obsidian
      ferdium

      inputs.hallnix.packages.${pkgs.stdenv.hostPlatform.system}.helium-browser
      inputs.hallnix.packages.${pkgs.stdenv.hostPlatform.system}.zennotes
    ];

    programs.home-manager.enable = true;

    gtk.enable = true;

    dconf.settings = {
      "org/gnome/desktop/input-sources" = {
        xkb-options = ["caps:escape"];
      };
    };
  };
}
