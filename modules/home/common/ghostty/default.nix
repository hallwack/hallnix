{
  ...
}: {
  flake.modules.homeManager.ghostty = {pkgs, ...}: {
    home.packages = with pkgs; [
      ghostty
    ];

    xdg.configFile."ghostty".source = ./config;
  };
}
