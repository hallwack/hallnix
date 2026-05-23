{
  ...
}:
{
  flake.modules.nixos.fonts =
    { pkgs, appleFonts, ... }:
    {
      fonts = {
        fontconfig.enable = true;

        packages = with pkgs; [
          nerd-fonts.geist-mono
          nerd-fonts.iosevka-term
          nerd-fonts.iosevka
          nerd-fonts.symbols-only

          inter

          appleFonts.sf-pro
          appleFonts.sf-mono
          appleFonts.ny

          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-color-emoji
        ];

        fontconfig = {
          defaultFonts = {
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
        };
      };
    };
}
