{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.system.core.enable = lib.mkEnableOption "Enable hallwack system core module";

  config = lib.mkIf config.hallwack.system.core.enable {
    networking.networkmanager.enable = true;

    time.timeZone = "Asia/Jakarta";

    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/nvme0n1";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    services.printing.enable = true;
    programs.firefox.enable = true;
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      wget
      git
      curl
      gnupg
      pinentry-all
      usbutils
      unzip
      zip
      tree
      btop
      libnotify
      gnumake
    ];

    nix.settings.trusted-users = [ "root" "@wheel" "hallwack" ];

    system.stateVersion = "25.05";
  };
}
