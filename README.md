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
| `SUPER + стрелки`      | Фокус                            |
| `XF86Audio*`           | Громкость/яркость/медиа           |

Приложения закреплены по воркспейсам: firefox=1, vesktop/ayugram=2, zed=3, игры (`steam_app_*`)=4, steam=5.

## Структура

```
flake.nix                        собирает *.nix во всём репо автоматически (кроме _префиксных)
nixos/base/                      база: система, пользователь, keymap, мониторы
nixos/extra/                     опциональное железо (gpu-amd, gpu-nvidia, openrgb)
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

# ВАЖНО: инпут justxray тянется по git+ssh, так что в инсталляторе нужен ssh-ключ
# от github, иначе шаг 4 упадёт на резолве инпутов:
#   mkdir -p ~/.ssh && cp /путь/к/id_ed25519 ~/.ssh/ && chmod 600 ~/.ssh/id_ed25519

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
`amdgpuBusId`/`nvidiaBusId` в `nixos/extra/gpu-nvidia.nix` (текущий ноут — AMD iGPU +
Nvidia dGPU; на Intel-машине переименуй ключ в `intelBusId`), и поправь
`preferences.monitors."eDP-1"` в `nixos/hosts/laptop/configuration.nix`, если разрешение
не 1920x1080.

После первой загрузки — репо в `~/nixconf` (так его ждёт `programs.nh.flake`), закоммить.
Плагины для claude ставятся отдельно и один раз: `claude-seed-plugins` (нужен поднятый
justxray-прокси; в активацию это не вынесено намеренно — ребилд не должен зависеть от сети).

Дальше на любой из машин просто:

```bash
nh os switch
```

Без флагов и без `#host` — `nh` берёт хост по `networking.hostName`, а он у каждой машины
уже свой (`luynar` на десктопе, `laptop` на ноуте) и совпадает с именем в
`nixosConfigurations`, так что один и тот же алиас работает одинаково везде.

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

Если после `nix flake update caelestia-shell` патч перестал накладываться — это ровно то,
чего мы хотим: апстрим уехал, конфликт виден при сборке, а не молча в рантайме. Разрешается
тем же `git apply -3` в клоне выше.

## Мусор

`nix.gc` (еженедельно, `--delete-older-than 14d`) и `nix.optimise` включены в
`nixos/base/system.nix`, руками чистить не надо. Разово: `nh clean all`.
