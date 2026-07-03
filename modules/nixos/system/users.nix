{
  config,
  lib,
  pkgs,
  codex,
  ...
}:

{
  options.hallwack.system.users.enable = lib.mkEnableOption "Enable hallwack system users module";

  config = lib.mkIf config.hallwack.system.users.enable {
    environment.shells = with pkgs; [ zsh ];

    users.users.hallwack = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "audio"
        "video"
        "input"
        "pcscd"
        "plugdev"
      ];
      shell = pkgs.zsh;
      packages = with pkgs; [
        gnomeExtensions.just-perfection
        gnomeExtensions.dash-to-dock
        gnomeExtensions.blur-my-shell
        gnome-tweaks
        codex
      ];
    };
  };
}
