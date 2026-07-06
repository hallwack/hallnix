{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

{
  options.hallwack.editors.antigravity.enable = lib.mkEnableOption "Antigravity IDE";

  config = lib.mkIf config.hallwack.editors.antigravity.enable {
    home.packages = [
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-ide
      inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli
    ];
  };
}
