{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hallwack.cli.rust.enable = lib.mkEnableOption "Enable hallwack cli rust module";

  config = lib.mkIf config.hallwack.cli.rust.enable {
    home.packages = with pkgs; [
      rustup
      cargo-edit
      cargo-watch
    ];
  };
}
