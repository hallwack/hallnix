{
  hostname,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = hostname;
  nixpkgs.config.allowUnfree = true;

  hallwack.services.android.enable = true;
  hallwack.services.docker.enable = true;
  hallwack.services.openssh.enable = true;

  hallwack.system.audio.enable = true;
  hallwack.system.bluetooth.enable = true;
  hallwack.system.core.enable = true;
  hallwack.system.fonts.enable = true;
  hallwack.system.pcsc.enable = true;
  hallwack.system.shell.enable = true;
  hallwack.system.users.enable = true;

  hallwack.desktop.gnome.enable = true;
  hallwack.desktop.hyprland.enable = false;
  hallwack.desktop.niri.enable = true;
}
