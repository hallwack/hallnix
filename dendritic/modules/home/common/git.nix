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
      enable = true;
      userName = "hallwack";
      userEmail = "hallwack.id@gmail.com";
      extraConfig.init.defaultBranch = "main";
    };
  };
}
