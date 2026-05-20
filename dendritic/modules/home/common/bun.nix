{
  ...
}: {
  flake.modules.homeManager.bun = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      bun
    ];
  };
}
