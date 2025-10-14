{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "hallnet";
  networking.networkmanager.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  time.timeZone = "Asia/Jakarta";

  services.udev.packages = with pkgs; [gnome-settings-daemon pcsc-tools];

  services.xserver.enable = true;
  services.xserver = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    desktopManager.gnome.enable = true;
  };
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:escape";

  services.printing.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.libinput.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.blueman.enable = true;

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [ccid pcsc-tools];
  };
  boot.blacklistedKernelModules = ["nfc" "pn533" "pn533_usb"];

  programs.firefox.enable = true;
  programs.nix-ld.enable = true;
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.lib.mkForce pkgs.pinentry-gnome3;
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    zip
    gnupg
    pinentry-all
    usbutils
    
    # Hyprland essentials
    waybar
    rofi-wayland
    mako
    bluez
    bluez-tools
    blueman
  ];

  system.stateVersion = "25.05";

  services.openssh.enable = true;
}
