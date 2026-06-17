# Struktur Repository

Repository ini berisi konfigurasi NixOS berbasis `flake-parts`. Struktur utamanya memisahkan entrypoint host, module NixOS, module Home Manager, dotfiles, dan package lokal.

## Ringkasan

```text
.
├── flake.nix
├── flake.lock
├── hosts/
├── modules/
│   ├── system/
│   └── home/
├── config/
├── pkgs/
└── *.md
```

## `flake.nix`

`flake.nix` adalah entrypoint utama repository.

Perannya:

- Mendeklarasikan input flake seperti `nixpkgs`, `home-manager`, `flake-parts`, `nur`, dan dependency lain.
- Menggunakan `flake-parts.lib.mkFlake` sebagai kerangka utama.
- Mengimpor semua module yang mendefinisikan output flake.
- Mengekspos formatter per-system.

Module yang ada di `modules/` tidak langsung menjadi konfigurasi aktif hanya karena ada di filesystem. Module tersebut harus diimpor di `flake.nix`, lalu dipakai oleh host melalui `config.flake.modules.*`.

## `flake.lock`

`flake.lock` menyimpan versi pasti dari semua input flake.

Perannya:

- Membuat build reproducible.
- Mengunci revision `nixpkgs`, `home-manager`, dan input lain.
- Berubah saat menjalankan update input, misalnya `nix flake update`.

## `hosts/`

Direktori `hosts/` berisi entrypoint untuk setiap mesin.

Struktur saat ini:

```text
hosts/
└── hallnet/
    ├── default.nix
    └── hardware-configuration.nix
```

### `hosts/hallnet/default.nix`

File ini mendefinisikan konfigurasi NixOS untuk host `hallnet`.

Perannya:

- Membuat `flake.nixosConfigurations.hallnet`.
- Memanggil `inputs.nixpkgs.lib.nixosSystem`.
- Menentukan `system`, misalnya `x86_64-linux`.
- Mengatur `specialArgs` untuk nilai global seperti `repoRoot`, `self`, `lib`, `appleFonts`, dan `codex`.
- Mengimpor module NixOS dari `config.flake.modules.nixos.*`.
- Mengaktifkan Home Manager melalui `inputs.home-manager.nixosModules.home-manager`.
- Mengatur `home-manager.sharedModules` untuk module Home Manager user.
- Menjadi tempat deklarasi feature flag host, misalnya `desktop-niri.enable = true;`.

### `hosts/hallnet/hardware-configuration.nix`

File ini berisi konfigurasi hardware hasil generate NixOS.

Perannya:

- Mendefinisikan filesystem, disk, initrd, kernel modules, dan opsi hardware lain.
- Biasanya tidak diedit manual kecuali ada perubahan hardware atau layout disk.

## `modules/system/nixos/`

Direktori ini berisi module NixOS/system-level.

Struktur saat ini:

```text
modules/system/nixos/
├── audio.nix
├── base.nix
├── bluetooth.nix
├── desktop-gnome.nix
├── desktop-hyprland.nix
├── desktop-niri.nix
├── fonts.nix
├── pcsc.nix
├── shell.nix
└── user-hallwack.nix
```

Peran umum:

- Mengatur konfigurasi yang berada di level sistem.
- Mengaktifkan service NixOS.
- Menambahkan package system-wide.
- Mengatur user system, audio, bluetooth, font, desktop environment, dan shell tooling.
- Mengekspor module sebagai `flake.modules.nixos.<nama>`.

Contoh pola:

```nix
{
  flake.modules.nixos.shell = { ... }: {
    programs.zsh.enable = true;
  };
}
```

### `base.nix`

Konfigurasi dasar host.

Biasanya berisi:

- Hostname.
- NetworkManager.
- Timezone.
- Bootloader.
- Nix settings.
- Garbage collection.
- Service dasar seperti printing dan SSH.
- Package CLI dasar.
- `system.stateVersion`.

### `desktop-gnome.nix`

Konfigurasi sistem untuk GNOME.

Biasanya berisi:

- X server.
- Keyboard layout.
- GNOME desktop manager.
- GDM display manager.
- Dconf.
- Libinput.

### `desktop-niri.nix`

Konfigurasi sistem untuk Niri.

Biasanya berisi:

- `programs.niri.enable`.
- Polkit.
- GNOME keyring.
- XDG portal.
- Package pendukung Wayland/Niri.
- Forwarding flag ke Home Manager user jika dipakai.

### `desktop-hyprland.nix`

Konfigurasi sistem untuk Hyprland.

Biasanya berisi:

- `programs.hyprland.enable`.
- XWayland.
- Package pendukung seperti `waybar`, `rofi`, `mako`, `hyprlock`, dan tool Wayland lain.
- Forwarding flag ke Home Manager user jika dipakai.

### `audio.nix`

Konfigurasi audio system.

Biasanya berisi:

- PipeWire.
- ALSA.
- PulseAudio compatibility.
- Pinentry untuk GnuPG agent.

### `bluetooth.nix`

Konfigurasi Bluetooth system.

Biasanya berisi:

- `hardware.bluetooth`.
- Blueman service.
- Package Bluetooth seperti `bluez`, `bluez-tools`, dan `blueman`.

### `fonts.nix`

Konfigurasi font system.

Biasanya berisi:

- Fontconfig.
- Nerd Fonts.
- Apple fonts.
- Noto fonts.
- Default font families.

### `pcsc.nix`

Konfigurasi smart card / PCSC.

Biasanya berisi:

- Group `plugdev`.
- `services.pcscd`.
- CCID plugin.
- Blacklist kernel module NFC tertentu.

### `shell.nix`

Konfigurasi shell dan tooling system.

Saat ini berisi:

- Zsh.
- Direnv.
- Nix-direnv.
- `nh` sebagai Nix helper.

### `user-hallwack.nix`

Konfigurasi user system `hallwack`.

Biasanya berisi:

- User normal.
- Extra groups.
- Default shell.
- Package user di level NixOS.

## `modules/home/`

Direktori ini berisi module Home Manager.

Home Manager mengatur konfigurasi user-level, bukan system-level. Contohnya dotfiles, package user, shell config user, editor config, terminal config, dan app config.

Struktur utama:

```text
modules/home/
├── common/
└── linux/
```

## `modules/home/common/`

Module Home Manager yang bersifat umum dan bisa dipakai lintas platform.

Struktur saat ini:

```text
modules/home/common/
├── bun.nix
├── dev-tools.nix
├── ghostty/
├── git.nix
├── kitty/
├── neovim/
├── nix.nix
├── nodejs.nix
├── rust.nix
├── shell.nix
└── user-hallwack.nix
```

Peran umum:

- Mengatur package dan konfigurasi user-level.
- Mengekspor module sebagai `flake.modules.homeManager.<nama>`.
- Dipakai melalui `home-manager.sharedModules`.

### `user-hallwack.nix`

Profil Home Manager user `hallwack`.

Biasanya berisi:

- `home.username`.
- `home.homeDirectory`.
- `home.stateVersion`.
- Cursor.
- Package user.
- Enable Home Manager.
- GTK.
- Dconf user settings.

### `shell.nix`

Konfigurasi shell user.

Biasanya berisi:

- Zsh Home Manager config.
- Oh My Zsh.
- Zsh plugin.
- Alias.
- History.
- Starship.
- Zoxide.
- Direnv.
- Symlink config dari `config/zsh` dan `config/starship.toml`.

### `git.nix`

Konfigurasi Git user.

Biasanya berisi:

- Package `git`.
- Nama user.
- Email.
- Default branch.

### `dev-tools.nix`

Tooling development umum.

Saat ini mengatur:

- Fastfetch.
- Config Fastfetch.

### `nix.nix`

Tooling development untuk Nix.

Biasanya berisi:

- `nixpkgs-fmt`.
- `nixd`.

### `nodejs.nix`, `bun.nix`, `rust.nix`

Module bahasa pemrograman/runtime.

Perannya:

- `nodejs.nix` mengatur Node.js.
- `bun.nix` mengatur Bun.
- `rust.nix` mengatur Rust tooling seperti `rustup`, `cargo-edit`, dan `cargo-watch`.

### `ghostty/`, `kitty/`, `neovim/`

Module aplikasi yang punya konfigurasi lebih dari satu file atau layout khusus.

Perannya:

- Menginstall package terkait.
- Menghubungkan konfigurasi dari `config/` ke `$HOME/.config`.
- Memisahkan konfigurasi aplikasi agar module tetap mudah dibaca.

## `modules/home/linux/`

Module Home Manager yang khusus Linux atau desktop Linux.

Struktur saat ini:

```text
modules/home/linux/
├── desktop-hyprland.nix
├── niri/
└── noctalia/
```

### `desktop-hyprland.nix`

Konfigurasi user-level untuk Hyprland.

Perannya:

- Menyediakan tempat untuk symlink config Hyprland, Waybar, Rofi, Mako, dan SwayNC.
- Saat ini sebagian konfigurasi masih berupa komentar.

### `niri/default.nix`

Konfigurasi user-level untuk Niri.

Perannya:

- Menghubungkan `config/niri` ke `$HOME/.config/niri`.
- Dipakai bersama module system `desktop-niri.nix`.

### `noctalia/default.nix`

Konfigurasi user-level untuk Noctalia shell.

Perannya:

- Mengimpor module Home Manager dari input `noctalia`.
- Mengatur `programs.noctalia-shell`.
- Menyimpan setting bar, widget, appearance, behavior, dan desktop widget.

## `config/`

Direktori `config/` berisi dotfiles atau konfigurasi aplikasi mentah yang akan disymlink oleh Home Manager.

Struktur utama:

```text
config/
├── ghostty/
├── hypr/
├── kitty/
├── niri/
├── nvim/
├── starship.toml
└── zsh/
```

Peran umum:

- Menjadi sumber konfigurasi aplikasi.
- Tidak langsung aktif sendiri.
- Biasanya dihubungkan ke `$HOME/.config/<app>` melalui `xdg.configFile` di Home Manager.

Contoh:

```nix
xdg.configFile."niri".source =
  lib.mkForce (config.lib.file.mkOutOfStoreSymlink "${repoRoot}/config/niri");
```

## `pkgs/`

Direktori `pkgs/` berisi package lokal atau package custom.

Struktur saat ini:

```text
pkgs/
├── helium-browser/
└── zennotes/
```

Perannya:

- Menyimpan derivation Nix custom.
- Bisa dipakai dari module Home Manager atau NixOS.
- Cocok untuk package yang belum ada di nixpkgs atau butuh override lokal.

## File Markdown Lain

Repository juga punya beberapa dokumentasi tambahan:

```text
ADDING_PACKAGES.md
FLAKES_VS_HOME_MANAGER.md
MACOS.md
MIGRATING_TO_DENDRITIC.md
README.md
```

Perannya:

- `README.md` menjelaskan gambaran umum repository.
- `ADDING_PACKAGES.md` menjelaskan cara menambah package.
- `FLAKES_VS_HOME_MANAGER.md` menjelaskan perbedaan flakes dan Home Manager.
- `MACOS.md` berisi catatan macOS.
- `MIGRATING_TO_DENDRITIC.md` berisi catatan migrasi struktur dendritic.

## Alur Evaluasi Konfigurasi

Alur ringkasnya:

```text
flake.nix
└── imports module flake-parts
    └── hosts/hallnet/default.nix
        └── flake.nixosConfigurations.hallnet
            ├── module NixOS dari modules/system/nixos/
            └── Home Manager sharedModules dari modules/home/
```

Dengan pola ini:

- `flake.nix` bertugas mengumpulkan module.
- `hosts/hallnet/default.nix` bertugas memilih module dan mengaktifkan fitur untuk mesin `hallnet`.
- `modules/system/nixos/` bertugas mengatur sistem.
- `modules/home/` bertugas mengatur user.
- `config/` menyimpan dotfiles yang dipakai oleh module Home Manager.
- `pkgs/` menyimpan package custom.

## Konvensi Penamaan

Konvensi yang disarankan:

- Gunakan prefix `desktop-*` untuk module desktop system-level, misalnya `desktop-niri.nix`.
- Gunakan nama yang konsisten untuk module Home Manager desktop, misalnya `desktop-niri`, `desktop-hyprland`, dan `desktop-gnome` jika masing-masing punya konfigurasi user.
- Gunakan `common/` untuk module Home Manager yang tidak spesifik Linux desktop.
- Gunakan `linux/` untuk module Home Manager yang spesifik Linux atau Wayland desktop.
- Gunakan folder aplikasi jika konfigurasi aplikasi punya banyak file, misalnya `neovim/default.nix`.

## Rebuild

Untuk menerapkan konfigurasi host:

```sh
sudo nixos-rebuild switch --flake /home/hallwack/hallnix#hallnet
```

Jika `nh` sudah aktif:

```sh
nh os switch
```
