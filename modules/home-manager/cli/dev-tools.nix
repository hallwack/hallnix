{
  config,
  lib,
  repoRoot,
  ...
}:

{
  options.hallwack.cli.devtools.enable = lib.mkEnableOption "Enable hallwack cli devtools module";

  config = lib.mkIf config.hallwack.cli.devtools.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "${repoRoot}/config/fastfetch/logo.txt";
          type = "file";
          color = {
            "1" = "#F3A2BB";
            "2" = "#EEAE7B";
            "3" = "#B5C77D";
            "4" = "#6DD3C0";
            "5" = "#80C6F8";
            "6" = "#C7AFF5";
          };
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "shell"
          "packages"
          "uptime"
          "break"
          "cpu"
          "gpu"
          "memory"
          "disk"
          "break"
          "de"
          "wm"
          "theme"
          "terminal"
          "break"
          "colors"
        ];
      };
    };
  };
}
