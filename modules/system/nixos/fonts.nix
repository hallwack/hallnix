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
          nerd-fonts.fira-code
          nerd-fonts.jetbrains-mono
          nerd-fonts.geist-mono
          nerd-fonts.hack
          nerd-fonts.ubuntu
          inter
          appleFonts.sf-pro
          appleFonts.sf-mono
          appleFonts.ny
        ];

        fontconfig = {
          defaultFonts = {
            serif = [
              "SF Pro"
            ];
            sansSerif = [
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
