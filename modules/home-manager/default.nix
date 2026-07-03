{ lib, ... }:

let
  allFiles = lib.filesystem.listFilesRecursive ./.;

  isModule =
    file:
    let
      path = builtins.toString file;
      name = builtins.baseNameOf file;
    in
    lib.hasSuffix ".nix" path && name != "default.nix" && !(lib.hasInfix "/_" path);

  modules = lib.filter isModule allFiles;
in
{
  imports = modules;
}
