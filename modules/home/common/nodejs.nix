{
  ...
}: {
  flake.modules.homeManager.nodejs = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      nodejs
      pnpm
      typescript-language-server
      prettier
    ];
  };
}
