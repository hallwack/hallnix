{
  ...
}: {
  flake.modules.homeManager.kitty = {pkgs, ...}: {
    home.packages = with pkgs; [
      kitty
    ];

    xdg.configFile."kitty".source = ./config;
  };
}
