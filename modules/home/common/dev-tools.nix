{ ...
}: {
  flake.modules.homeManager.dev-tools =
    { ...
    }: {
      programs.fastfetch.enable = true;

      home.file.".config/fastfetch/config.jsonc".text = ''
        {
          "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
          "modules": [
            "title",
            "separator",
            "os",
            "host",
            "kernel",
            "shell",
            "packages",
            "uptime",
            "break",
            "cpu",
            "gpu",
            "memory",
            "disk",
            "break",
            "de",
            "wm",
            "theme",
            "terminal",
            "break",
            "colors"
          ]
        }
      '';
    };
}
