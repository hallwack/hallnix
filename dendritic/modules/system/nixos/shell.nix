{
  ...
}: {
  flake.modules.nixos.shell = {
    ...
  }: {
    programs.zsh.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
  };
}
