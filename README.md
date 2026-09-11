
# A LOT OF CONFIG WAS VIBECODED 🥀

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#luynar   # десктоп
sudo nixos-rebuild switch --flake .#laptop   # ноут
# без #host — сама подхватит по имени машины, если оно совпадает с атрибутом
nh home switch                                # или home-manager
nix fmt                                       # форматирование (nixfmt)
```

## Структура

```
flake.nix                        собирает *.nix во всём репо автоматически (кроме _префиксных)
nixos/base/                      база: система, disko, impermanence, пользователь, keymap, мониторы
nixos/extra/                     опциональное железо (gpu-amd, gpu-nvidia, openrgb)
nixos/features/<name>/           каждая фича: default.nix + конфиги рядом
nixos/features/nvim/             nvim на nixvim (плагины из Nix, Lua-конфиг в lua/)
nixos/hosts/main/                nixosConfigurations.luynar — десктоп, AMD GPU
nixos/hosts/laptop/               nixosConfigurations.laptop — ноут, Nvidia GPU
Wallpapers/                      обои для рофл-свитчера
```

Файлы с `_` в начале имени (`_binds.nix`, `_rules.nix`, ...) не импортируются автоматически —
это не самостоятельные flake-модули, а куски, которые явно подключают другие файлы.

## Архитектура

- **Корень (`/`)**: `tmpfs` (RAM). Стирается при перезагрузке.
- **Хранилище (Btrfs)**: `@nix` (`/nix`), `@persist` (`/persist`), `@log` (`/var/log`).
- **Персистентность (`impermanence`)**: всё сохраняемое лежит в `/persist` (сеть, ssh-ключи, `~/.ssh`, браузер, проекты, стим и т.д.).

## Установка

### 1. Дуалбут (сохраняя Windows на одном SSD)

1. Делаем раздел 5 загрузочным EFI:
   ```bash
   sudo sgdisk -t 5:ef00 /dev/nvme0n1
   ```
2. Форматируем и монтируем разделы через Disko:
   ```bash
   sudo nix run github:nix-community/disko -- -m format,mount --flake github:luynrs/nixconf#luynar
   ```
3. Ставим систему:
   ```bash
   sudo nixos-install --flake github:luynrs/nixconf#luynar --no-root-passwd
   ```

### 2. Полный вайп диска (когда решишь снести Windows)

1. В `nixos/hosts/main/configuration.nix` убери строчку `preferences.disko.dualboot = true;`
2. Запусти:
   ```bash
   sudo nix run github:nix-community/disko -- -m disko --flake github:luynrs/nixconf#luynar
   sudo nixos-install --flake github:luynrs/nixconf#luynar --no-root-passwd
   ```

После первой загрузки:

```bash
nh os switch
```
