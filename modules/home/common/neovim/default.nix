{
  ...
}: {
  flake.modules.homeManager.neovim = {pkgs, ...}: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    xdg.configFile."nvim".source = ./config;

    home.packages = with pkgs; [
      ripgrep
      fd
      gcc
    ];
  };
}
