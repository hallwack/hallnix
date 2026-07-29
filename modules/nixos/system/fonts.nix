{
  config,
  lib,
  pkgs,
  appleFonts,
  ...
}:

{
  options.hallwack.system.fonts.enable = lib.mkEnableOption "Enable hallwack system fonts module";

  config = lib.mkIf config.hallwack.system.fonts.enable {

    fonts.packages = with pkgs; [
      nerd-fonts.geist-mono
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka
      nerd-fonts.symbols-only

      ioskeley-mono.normal-NL-NF
      ioskeley-mono.normal-term-NF

      inter

      appleFonts.sf-pro
      appleFonts.sf-mono
      appleFonts.ny

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fonts.fontconfig.defaultFonts = {
      serif = [
        "New York"
        "Noto Serif"
      ];
      sansSerif = [
        "SF Pro Display"
        "Noto Sans"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        autohint = false;
        style = "full";
      };
      subpixel = {
        rgba = "rgb";
        lcdfilter = "light";
      };
    };
  };
}
