{
  config,
  lib,
  pkgs,
  repoRoot,
  ...
}:

{
  options.hallwack.terminal.ghostty.enable = lib.mkEnableOption "Ghostty terminal";

  config = lib.mkIf config.hallwack.terminal.ghostty.enable {
    home.packages = with pkgs; [
      ghostty
    ];

    xdg.configFile."ghostty".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/ghostty"
    );
  };
}
