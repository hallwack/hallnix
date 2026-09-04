{ config, lib, pkgs, ... }:

{
  options.hallwack.services.android.enable = lib.mkEnableOption "Enable Android service";

  config = lib.mkIf config.hallwack.services.android.enable {
    programs.adb.enable = true;

    packages = with pkgs; [
      android-tools
    ];
  };
}
