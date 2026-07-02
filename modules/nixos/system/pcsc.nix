{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.system.pcsc.enable = lib.mkEnableOption "Enable hallwack system pcsc module";

  config = lib.mkIf config.hallwack.system.pcsc.enable {
    users.groups.plugdev = { };

    services.pcscd = {
      enable = true;
      plugins = with pkgs; [
        ccid
      ];
    };

    boot.blacklistedKernelModules = [
      "nfc"
      "pn533"
      "pn533_usb"
    ];
  };
}
