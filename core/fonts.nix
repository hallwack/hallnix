{
  config,
  pkgs,
  ...
}: {
  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
    };
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      nerd-fonts.geist-mono
      nerd-fonts.ubuntu
    ];
  };
}

