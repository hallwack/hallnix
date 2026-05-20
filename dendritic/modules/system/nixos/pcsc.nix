{
  ...
}: {
  flake.modules.nixos.pcsc = {pkgs, ...}: {
    users.groups.plugdev = {};

    services.pcscd = {
      enable = true;
      plugins = with pkgs; [ccid pcsc-tools];
    };

    boot.blacklistedKernelModules = ["nfc" "pn533" "pn533_usb"];
  };
}
