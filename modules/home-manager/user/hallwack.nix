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
        vscode
        bat
        dbeaver-bin
        lazygit
        zed-editor
        pass
        spotify
        jq
        obsidian
        obs-studio

        inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.zennotes.packages.${pkgs.stdenv.hostPlatform.system}.zennotes-desktop
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
