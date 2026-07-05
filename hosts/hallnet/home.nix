{
  username,
  ...
}:

{
  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.05";
  };

  hallwack.cli.devtools.enable = true;
  hallwack.cli.git.enable = true;
  hallwack.cli.gpg.enable = true;
  hallwack.cli.nix.enable = true;
  hallwack.cli.nodejs.enable = true;
  hallwack.cli.rust.enable = true;
  hallwack.cli.shell.enable = true;

  hallwack.desktop.niri.enable = true;
  hallwack.desktop.noctalia.enable = true;

  hallwack.editors.neovim.enable = true;

  hallwack.terminal.kitty.enable = true;
  hallwack.terminal.ghostty.enable = true;

  hallwack.user.enable = true;
}
