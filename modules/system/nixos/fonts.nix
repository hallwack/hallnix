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
          appleFonts.sf-pro-nerd
        ];

        fontconfig = {
          defaultFonts = {
            serif = [
              "New York"
              "New York Large"
              "New York Small"
            ];
            sansSerif = [
              "SF Pro Display"
              "SF Pro Text"
              "SF Pro"
            ];
            emoji = [
              "Noto Color Emoji"
            ];
          };
        };
      };
    };
}
