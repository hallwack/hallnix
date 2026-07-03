local programs = {}

programs.terminal = "kitty"
programs.fileManager = "kitty yazi"
programs.menu = "/home/matteo/.local/bin/smart_menu.sh"
programs.bar = "quickshell"
programs.rog = "rog-control-center"
programs.screenshot = 'grim -g "$(slurp)" - | wl-copy'
programs.browser = "helium-browser"
programs.powermenu = "/home/matteo/.local/bin/smart_powermenu.sh"
programs.lock = "hyprlock"
programs.note = "obsidian"
programs.dock = ""

return programs
