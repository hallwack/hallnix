mkcp() { mkdir -p "$1" && cd "$1"; }

export EDITOR="nvim"
export VISUAL="nvim"

if command -v fastfetch >/dev/null 2>&1; then
  fastfetch --logo-type none
fi
