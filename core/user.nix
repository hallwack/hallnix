{
  config,
  pkgs,
  ...
}: {
  users.groups.plugdev = {};
  
  users.users.hallwack = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "input" "pcscd" "plugdev"];
    shell = pkgs.zsh;
    packages = with pkgs; [
      tree
      gnomeExtensions.just-perfection
      gnomeExtensions.dash-to-dock
      kitty
      brave
      gnome-tweaks
      neovim
      wl-clipboard
      unzip
      fastfetch
    ];
  };
  
  programs.zsh.enable = true;
}

