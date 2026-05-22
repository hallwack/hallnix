{ ...
}: {
  flake.modules.nixos.fonts = { pkgs, appleFonts, ... }: {
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        enable = true;
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
      packages = with pkgs; [
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.geist-mono
        nerd-fonts.hack
        nerd-fonts.ubuntu
        inter
        appleFonts.sf-pro
        appleFonts.sf-mono
      ];
    };
  };
}
