{
  config,
  lib,
  pkgs,
  repoRoot,
  ...
}:

{
  options.hallwack.terminal.kitty.enable = lib.mkEnableOption "Kitty terminal";

  config = lib.mkIf config.hallwack.terminal.kitty.enable {
    home.packages = with pkgs; [
      kitty
    ];

    xdg.configFile."kitty".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/kitty"
    );
  };
}
