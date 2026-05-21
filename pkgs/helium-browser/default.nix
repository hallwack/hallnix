{
  stdenv,
  lib,
  appimageTools,
  fetchurl,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  pname = "helium-browser";
  version = "0.12.4";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-3a04bc1e42c1b1e16b121345271330a756e0d20ccf75f63555ac92000a7bbead";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-cb4358edb2ceba5b5a284fa271b5516901623b6129bb5f6fc3a46ac512a80b6a";
    };
  };

  system = 
    architectures.${stdenv.hostPlatform.system} or (  
      throw "Unsupported system: ${stdenv.hostPlatform.system}. Supported systems are: ${lib.attrNames architectures}"
    );

  src =
    let
      inherit (system) arch hash;
    in
    fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${arch}.AppImage";
      inherit hash;
    };
in
appimageTools.wrapType2 {
  inherit pname version src;
  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Helium Browser";
      exec = "${pname}";
      icon = "${src}/helium.png";
      categories = ["Network" "WebBrowser"];
    })
  ];
  meta = with lib; {
    description = "Internet without interruptions.";
    homepage = "https://helium.computer/";
    license = licenses.unfree;
    mainProgram = pname;
    platforms = builtins.attrNames architectures;
  };
}