{
  ...
}: {
  flake.modules.homeManager.niri = {
    ...
  }: {
    xdg.configFile."niri".source = ./config;
  };
}
