{
  ...
}:
{
  flake.modules.nixos.shell =
    {
      ...
    }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
        flake = "/home/hallwack/hallnix";
      };

      programs.zsh.enable = true;
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;
    };
}
