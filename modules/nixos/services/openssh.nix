{ config, lib, ... }:

{
  options.hallwack.services.openssh.enable =
    lib.mkEnableOption "Enable OpenSSH server";

  config = lib.mkIf config.hallwack.services.openssh.enable {
    services.openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
