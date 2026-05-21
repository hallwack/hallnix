{
  ...
}: {
  flake.modules.homeManager.git = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      git
    ];

    programs.git = {
      settings = {
        user.name = "hallwack";
        user.email = "hallwack.id@gmail.com";
        init.defaultBranch = "main";
      };
    };
  };
}
