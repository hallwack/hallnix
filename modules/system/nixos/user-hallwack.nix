{
  ...
}: {
  flake.modules.nixos.user-hallwack = {pkgs, codex, ...}: {
    environment.shells = with pkgs; [zsh];

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
        neovim
        codex
      ];
    };
  };
}
