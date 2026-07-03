{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.gpg.enable = lib.mkEnableOption "Enable hallwack cli gpg module";

  config = lib.mkIf config.hallwack.cli.git.enable {
    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
