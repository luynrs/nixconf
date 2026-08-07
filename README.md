# nixconf

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
| `SUPER + SHIFT + W`    | Смена обоев (caelestia, `>wallpaper`) |
| `SUPER + SHIFT + Q`    | Power menu (caelestia)             |
| `SUPER + S`            | Ланчер (caelestia)                 |
| `SUPER + D` / `F`      | Maximize / Fullscreen             |
| `SUPER + V`            | Float toggle                      |
| `SUPER + SHIFT + S`    | Скрин области (в буфер)           |
| `PRINT`                | Скрин всего (в буфер)             |
| `SUPER + SHIFT + C`    | Пайпетка (цвет)                   |
| `SUPER + 1..0`         | Воркспейсы (с SHIFT — перенос)    |
| `SUPER + стрелки`      | Фокус                            |
| `XF86Audio*`           | Громкость/яркость/медиа           |

Приложения закреплены по воркспейсам: firefox=1, vesktop/ayugram=2, zed=3, игры (стим)=4, steam=5.

## Структура

```
flake.nix                        собирает *.nix во всём репо автоматически (кроме _префиксных)
nixos/base/                      база: система, тема, пользователь, keymap, мониторы
nixos/extra/                     опциональное железо (gpu-amd, gpu-nvidia, openrgb, v2raya)
nixos/features/<name>/           каждая фича: default.nix + конфиги рядом
nixos/features/nvim/             nvim на nixvim (плагины из Nix, Lua-конфиг в lua/)
nixos/hosts/main/                nixosConfigurations.luynar — десктоп, AMD GPU
nixos/hosts/laptop/               nixosConfigurations.laptop — ноут, Nvidia GPU
Wallpapers/                      обои для рофл-свитчера
```

Файлы с `_` в начале имени (`_binds.nix`, `_rules.nix`, ...) не импортируются автоматически —
это не самостоятельные flake-модули, а куски, которые явно подключают другие файлы.

## Установка (любой хост)

Одна и та же процедура для десктопа, ноута и любой следующей машины — меняется только
`$HOST`. Разметка ручная, обычный ext4 (`/boot` — vfat ESP, `/` — ext4):

```bash
# 1. Разметка — пример для GPT/UEFI, замени /dev/nvme0n1 на свой диск
sudo parted /dev/nvme0n1 -- mklabel gpt
sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MiB 1GiB
sudo parted /dev/nvme0n1 -- set 1 esp on
sudo parted /dev/nvme0n1 -- mkpart primary ext4 1GiB 100%
sudo mkfs.fat -F32 -n boot /dev/nvme0n1p1
sudo mkfs.ext4 -L nixos /dev/nvme0n1p2
sudo mount /dev/nvme0n1p2 /mnt
sudo mkdir -p /mnt/boot
sudo mount /dev/nvme0n1p1 /mnt/boot

# 2. Конфиг + имя хоста (совпадает с nixos/hosts/<host>/ и nixosConfigurations.<host>)
git clone https://github.com/luynrs/nixconf.git /mnt/root/nixconf
cd /mnt/root/nixconf
HOST=laptop

# 3. hardware-configuration.nix — один готовый кусок вывода nixos-generate-config,
# обёрнутый в нужное имя модуля, никакой ручной разборки полей
mkdir -p nixos/hosts/$HOST
{ echo "{ flake.nixosModules.$HOST ="; nixos-generate-config --root /mnt --show-hardware-config; echo "; }"; } \
  > nixos/hosts/$HOST/hardware-configuration.nix

# 4. Установка
sudo nixos-install --flake .#$HOST
```

Для `main`/`laptop` `configuration.nix` уже в репо. Для нового хоста скопируй
`nixos/hosts/laptop/configuration.nix` рядом и поправь `preferences`/железные модули
(`gpu-amd` vs `gpu-nvidia`, `openrgb` и т.п.) под новую машину.

На ноуте отдельно после установки: `lspci | grep -E "VGA|3D"` → впиши bus ID в
`intelBusId`/`nvidiaBusId` в `nixos/extra/gpu-nvidia.nix`, и поправь
`preferences.monitors."eDP-1"` в `nixos/hosts/laptop/configuration.nix`, если разрешение
не 1920x1080.

После первой загрузки — репо в `~/nixconf` (так его ждёт `programs.nh.flake`), закоммить.
Дальше на любой из машин просто:

```bash
nh os switch
```

Без флагов и без `#host` — `nh` берёт хост по `networking.hostName`, а он у каждой машины
уже свой (`luynar` на десктопе, `laptop` на ноуте) и совпадает с именем в
`nixosConfigurations`, так что один и тот же алиас работает одинаково везде.

## Темизация

Палитра — Catppuccin Mocha, акцент lavender, везде. GTK/Qt/курсор/иконки заданы напрямую в
`nixos/features/appearance.nix` (adw-gtk3-dark, Papirus-Dark, Bibata). nvim берёт catppuccin
через встроенную colorscheme в nixvim. Hyprland-бордеры, цвета fish и starship — не статичные
nix-значения, а шаблоны, которые перерисовывает caelestia (ниже) при каждой смене схемы.

Бар, ланчер, powermenu и уведомления — caelestia-shell (`nixos/features/caelestia/`),
собирается из вендоренного чекаута `vendor/caelestia-shell` (правь QML там, `nh home switch`
пересоберёт). Схема цветов у caelestia — не плоский hex, а полная
палитра Material 3, поэтому вместо ручного маппинга из `theme.nix` используется встроенная
схема `catppuccin/mocha` (её акцент `lavender` уже совпадает с этим репо), проставляется
один раз через `caelestia scheme set` в `home.activation`.
