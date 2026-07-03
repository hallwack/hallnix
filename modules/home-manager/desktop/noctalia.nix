{
  config,
  lib,
  repoRoot,
  inputs,
  ...
}:

{
  options.hallwack.desktop.noctalia.enable =
    lib.mkEnableOption "Enable hallwack desktop noctalia module";

  config = lib.mkIf config.hallwack.desktop.noctalia.enable {

    home.packages = with config.pkgs; [
      inputs.noctalia.packages.${pkgs.system}.default
    ];

    xdg.configFile."noctalia".source = lib.mkForce (
      config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/noctalia"
    );
  };
}
