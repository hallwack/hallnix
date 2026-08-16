{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.system.shell.enable = lib.mkEnableOption "Enable hallwack system shell module";

  config = lib.mkIf config.hallwack.system.shell.enable {
    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 3";
      };
      flake = "/home/hallwack/hallnix";
    };

    programs.zsh.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    environment.systemPackages = with pkgs; [
      devenv
    ];
  };
}
