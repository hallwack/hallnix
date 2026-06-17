# hallnix

Konfigurasi NixOS pribadi berbasis `flake-parts`, NixOS modules, dan Home Manager.

Repository ini memakai pola dendritic: setiap fitur dipisah sebagai module kecil, lalu host memilih module dan feature flag yang ingin diaktifkan.

## Struktur Utama

```text
.
├── flake.nix
├── hosts/
│   └── hallnet/
├── modules/
│   ├── system/nixos/
│   └── home/
├── config/
└── pkgs/
```

## Entry Point

- `flake.nix` adalah entrypoint utama flake.
- `hosts/hallnet/default.nix` mendefinisikan `nixosConfigurations.hallnet`.
- `hosts/hallnet/hardware-configuration.nix` berisi konfigurasi hardware hasil generate NixOS.

## Module System

Module NixOS berada di:

```text
modules/system/nixos/
```

Module ini mengatur konfigurasi system-level seperti boot, networking, service, desktop, audio, bluetooth, font, user system, shell, dan Nix helper.

Contoh module system:

- `base.nix`
- `desktop-gnome.nix`
- `desktop-hyprland.nix`
- `desktop-niri.nix`
- `audio.nix`
- `bluetooth.nix`
- `fonts.nix`
- `pcsc.nix`
- `shell.nix`
- `user-hallwack.nix`

Semua module system diekspor sebagai:

```nix
config.flake.modules.nixos.<nama>
```

## Module Home Manager

Module Home Manager berada di:

```text
modules/home/
├── common/
└── linux/
```

`modules/home/common/` berisi konfigurasi user yang umum, seperti shell, Git, Neovim, terminal, dan language tooling.

`modules/home/linux/` berisi konfigurasi user yang spesifik Linux desktop atau Wayland.

Semua module Home Manager diekspor sebagai:

```nix
config.flake.modules.homeManager.<nama>
```

## Desktop Modules

Desktop sekarang dipisahkan menjadi dua layer:

- NixOS/system layer berada di `modules/system/nixos/desktop-*.nix`.
- Home Manager/user layer berada di `modules/home/linux/` jika desktop tersebut punya konfigurasi user.

### GNOME

System module:

```nix
config.flake.modules.nixos.desktop-gnome
```

Feature flag:

```nix
desktop-gnome.enable = true;
```

GNOME saat ini hanya punya konfigurasi system-level. Tidak ada module Home Manager khusus GNOME.

### Niri

System module:

```nix
config.flake.modules.nixos.desktop-niri
```

Home Manager modules:

```nix
config.flake.modules.homeManager.niri
config.flake.modules.homeManager.noctalia
```

Feature flag:

```nix
desktop-niri.enable = true;
```

Saat `desktop-niri.enable = true;`, module system Niri juga meneruskan enable ke Home Manager user:

```nix
home-manager.users.hallwack.desktop-niri.enable = true;
```

Efeknya:

- Niri system enablement aktif.
- XDG portal untuk Niri aktif.
- Config user Niri dari `config/niri` terhubung.
- Noctalia shell ikut aktif.

### Hyprland

System module:

```nix
config.flake.modules.nixos.desktop-hyprland
```

Home Manager module:

```nix
config.flake.modules.homeManager.desktop-hyprland
```

Feature flag:

```nix
desktop-hyprland.enable = true;
```

Saat `desktop-hyprland.enable = true;`, module system Hyprland juga meneruskan enable ke Home Manager user:

```nix
home-manager.users.hallwack.desktop-hyprland.enable = true;
```

## Mengaktifkan Desktop

Desktop diaktifkan dari `hosts/hallnet/default.nix`.

Contoh:

```nix
{
  desktop-gnome.enable = true;
  desktop-niri.enable = true;
  # desktop-hyprland.enable = true;
}
```

Module desktop tetap perlu di-import di list `modules`:

```nix
config.flake.modules.nixos.desktop-gnome
config.flake.modules.nixos.desktop-hyprland
config.flake.modules.nixos.desktop-niri
```

Module Home Manager desktop yang punya konfigurasi user tetap perlu masuk ke `home-manager.sharedModules`:

```nix
config.flake.modules.homeManager.desktop-hyprland
config.flake.modules.homeManager.niri
config.flake.modules.homeManager.noctalia
```

## Dotfiles

Direktori `config/` menyimpan konfigurasi aplikasi mentah yang disymlink oleh Home Manager.

Contoh:

- `config/niri`
- `config/hypr`
- `config/nvim`
- `config/ghostty`
- `config/kitty`
- `config/zsh`
- `config/starship.toml`

Dotfiles ini tidak aktif sendiri. Module Home Manager yang menghubungkannya ke `$HOME/.config`.

## Package Lokal

Package custom berada di:

```text
pkgs/
├── helium-browser/
└── zennotes/
```

Package ini bisa dipakai dari module NixOS atau Home Manager.

## Rebuild

Dengan `nixos-rebuild`:

```sh
sudo nixos-rebuild switch --flake /home/hallwack/hallnix#hallnet
```

Dengan `nh`:

```sh
nh os switch
```

## Dokumentasi Tambahan

- `STRUCTURE.md` menjelaskan struktur repository secara lebih detail.
- `ADDING_PACKAGES.md` menjelaskan cara menambah package.
- `FLAKES_VS_HOME_MANAGER.md` menjelaskan perbedaan flakes dan Home Manager.
- `MIGRATING_TO_DENDRITIC.md` berisi catatan migrasi struktur dendritic.
- `MACOS.md` berisi catatan macOS.
