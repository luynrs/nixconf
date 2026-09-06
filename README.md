
#A LOT OF CONFIG WAS VIBECODED 🥀

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#luynar   # десктоп
sudo nixos-rebuild switch --flake .#laptop   # ноут
# без #host — сама подхватит по имени машины, если оно совпадает с атрибутом
nh home switch                                # или home-manager
nix fmt                                       # форматирование (nixfmt)
```

## Хоткеи

| Клавиша                | Действие                          |
| ---------------------- | --------------------------------- |
| `SUPER + RETURN`       | Терминал                          |
| `CTRL + SHIFT + Escape` | Процессы (btop)                   |
| `SUPER + Q`            | Закрыть окно                      |
| `SUPER + E`            | Файловый менеджер (nautilus)      |
| `SUPER + W`            | Браузер (firefox)                 |
| `SUPER + L`            | Лок (caelestia)                    |
| `SUPER + SHIFT + Q`    | Power menu (caelestia)             |
| `SUPER + S`            | Ланчер (caelestia)                 |
| `SUPER + A`            | Dashboard (caelestia)              |
| `SUPER + V`            | История буфера (caelestia)         |
| `SUPER + SHIFT + R`    | Перезапуск виджетов (caelestia)    |
| `SUPER + D` / `F`      | Maximize / Fullscreen             |
| `SUPER + SPACE`        | Float toggle                      |
| `SUPER + P` / `J`      | Pseudo / togglesplit              |
| `SUPER + SHIFT + S`    | Скрин области (в буфер)           |
| `PRINT`                | Скрин всего (в буфер)             |
| `SUPER + SHIFT + C`    | Пайпетка (цвет)                   |
| `SUPER + 1..0`         | Воркспейсы (с SHIFT — перенос)    |
| `SUPER + стрелки`      | Фокус                             |
| `XF86Audio*`           | Громкость/яркость/медиа           |

В nvim: `Space + E` — дерево проекта, `Space + Shift + E` — найти текущий файл,
`Tab` / `Shift + Tab` — следующий/предыдущий файл, `Space + BB` — предыдущий файл,
`Space + BD` — закрыть текущий файл, `Space + FF` — найти файл.

Приложения закреплены по воркспейсам: firefox=1, equibop/ayugram=2, zed=3, игры (`steam_app_*`)=4, steam=5.

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

Чтобы Disko не стёр Windows, он настроен на разделы `p5` (1G boot) и `p6` (root).
Создать сами границы разделов в свободном месте (400GB) можно заранее в Windows через «Управление дисками» / PowerShell, либо одной строкой в инсталляторе:

```bash
# Если разделы 5 и 6 ещё не созданы в неразмеченном месте (разово):
sudo sgdisk -n 5:0:+1G -t 5:ef00 /dev/nvme0n1 && sudo sgdisk -n 6:0:0 -t 6:8300 /dev/nvme0n1

# 1. Disko форматирует, создаёт btrfs subvolumes, tmpfs и монтирует всё в /mnt:
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode disko --flake github:luynrs/nixconf#luynar

# 2. Установка системы:
sudo nixos-install --flake github:luynrs/nixconf#luynar --no-root-passwd
```

### 2. Полный вайп диска (когда решишь снести Windows)

1. В `nixos/hosts/main/configuration.nix` поставь `preferences.disko.dualboot = false;`
2. Запусти те же 2 команды:
   ```bash
   sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- \
     --mode disko --flake github:luynrs/nixconf#luynar

   sudo nixos-install --flake github:luynrs/nixconf#luynar --no-root-passwd
   ```

После первой загрузки:

```bash
nh os switch
```

## Темизация

Палитра — Catppuccin Mocha, акцент lavender, везде. GTK/Qt/курсор/иконки заданы напрямую в
`nixos/features/appearance.nix` (adw-gtk3-dark, MoreWaita поверх Adwaita, Bibata). nvim берёт catppuccin
через встроенную colorscheme в nixvim. Hyprland-бордеры, цвета fish и starship — не статичные
nix-значения, а шаблоны, которые перерисовывает caelestia (ниже) при каждой смене схемы.

Бар, ланчер, powermenu и уведомления — caelestia-shell (`nixos/features/caelestia/`),
собирается из апстрима с наложенным `shell.patch` (см. «Форк caelestia» ниже).
Схема цветов у caelestia — не плоский hex, а полная
палитра Material 3, поэтому вместо ручного маппинга из `theme.nix` используется встроенная
схема `catppuccin/mocha` (её акцент `lavender` уже совпадает с этим репо), проставляется
через `caelestia scheme set` в `home.activation` — ровно один раз, пока нет
`~/.local/state/caelestia/scheme.json`, чтобы ребилд не сбрасывал текущую схему.

## Форк caelestia

Свои правки к shell лежат одним файлом — `nixos/features/caelestia/shell.patch`, он
накладывается на пин инпута `caelestia-shell` (`applyPatches` + вызов package-выражения
самого апстрима). Важно, что патчится именно исходник: `overrideAttrs { src = ...; }` не
работает, потому что QML-плагин, extras и m3shapes — отдельные деривации со своим `src`,
и правки в C++ (`plugin/`) до них не доезжают.

Править так — обычным git, никакого вендоринга:

```bash
REV=$(nix eval --raw --impure --expr '(builtins.getFlake (toString ./.)).inputs.caelestia-shell.rev')
git clone https://github.com/caelestia-dots/shell /tmp/cael && cd /tmp/cael && git checkout $REV
git apply ~/nixconf/nixos/features/caelestia/shell.patch
# правим QML/C++, git add -N для новых файлов
git add -A -N && git diff > ~/nixconf/nixos/features/caelestia/shell.patch
cd ~/nixconf && nh home switch
```
