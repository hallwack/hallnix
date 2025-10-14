{...}: {
  programs.git = {
    enable = true;
    userName = "hallwack";
    userEmail = "hallwack.id@gmail.com";
    extraConfig.init.defaultBranch = "main";
  };
}
