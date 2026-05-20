{
  inputs,
  ...
}: {
  flake.modules.homeManager.noctalia = {
    pkgs,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        settingsVersion = 0;
        bar = {
          barType = "simple";
          position = "top";
          showCapsule = true;
          backgroundOpacity = 0.93;
        };
      };
    };
  };
}
