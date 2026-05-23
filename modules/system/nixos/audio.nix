{
  ...
}:
{
  flake.modules.nixos.audio =
    {
      lib,
      pkgs,
      ...
    }:
    {
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      programs.gnupg.agent = {
        enable = true;
        pinentryPackage = lib.mkForce pkgs.pinentry-gnome3;
      };
    };
}
