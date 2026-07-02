{
  config,
  lib,
  ...
}:

{
  options.hallwack.cli.git.enable = lib.mkEnableOption "Enable hallwack cli git module";

  config = lib.mkIf config.hallwack.cli.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "hallwack";
        user.email = "hallwack.id@gmail.com";
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };
  };
}
