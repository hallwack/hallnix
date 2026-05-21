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
  version = "0.12.4.1";

  architectures = {
    "x86_64-linux" = {
      arch = "x86_64";
      hash = "sha256-OgS8HkLBseFrEhNFJxMwp1bg0gzPdfY1VaySAAp7vq0=";
    };
    "aarch64-linux" = {
      arch = "arm64";
      hash = "sha256-y0NY7bLOultaKE+icbVRaQFiO2Epu19vw6RqxRKoC2o=";
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
    license = licenses.gpl3Only;
    mainProgram = pname;
    platforms = builtins.attrNames architectures;
  };
}