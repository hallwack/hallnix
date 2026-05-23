{
  ...
}:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      networking.hostName = "hallnet";
      networking.networkmanager.enable = true;

      time.timeZone = "Asia/Jakarta";

      boot.loader.grub.enable = true;
      boot.loader.grub.device = "/dev/nvme0n1";

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        persistent = true;
        randomizedDelaySec = "45min";
      };

      services.printing.enable = true;
      services.openssh.enable = true;
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
        fastfetch
        btop
        libnotify
      ];

      system.stateVersion = "25.05";
    };
}
