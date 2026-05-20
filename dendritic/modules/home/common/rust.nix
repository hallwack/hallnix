{
  ...
}: {
  flake.modules.homeManager.rust = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      rustup
      rust-analyzer
      cargo-edit
      cargo-watch
    ];
  };
}
