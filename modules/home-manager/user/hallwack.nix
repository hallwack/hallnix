{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.user.enable = lib.mkEnableOption "Enable hallwack user module";

  config = lib.mkIf config.hallwack.user.enable {
    home = {
      pointerCursor = lib.mkIf pkgs.stdenv.isLinux {
        package = pkgs.apple-cursor;
        name = "macOS";
        size = 26;
        gtk.enable = true;
        x11.enable = true;
      };

      packages = with pkgs; [
        docker
        vscode
        bat
        dbeaver-bin
        lazygit
        zed-editor
        pass
        spotify
        jq
        obsidian
        ferdium

        inputs.hallnix.packages.${pkgs.stdenv.hostPlatform.system}.helium-browser
        inputs.zennotes.packages.${pkgs.system}.zennotes-desktop
      ];
    };

    programs.home-manager.enable = true;

    gtk.enable = lib.mkIf pkgs.stdenv.isLinux true;

    dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
      "org/gnome/desktop/input-sources" = {
        xkb-options = [ "caps:escape" ];
      };
    };

  };
}
