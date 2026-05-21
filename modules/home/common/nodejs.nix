{
  ...
}: {
  flake.modules.homeManager.nodejs = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      nodejs
      nodePackages.pnpm
      nodePackages.typescript-language-server
      nodePackages.prettier
    ];
  };
}
