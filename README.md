# nixconf

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#luynar   # система
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
| `SUPER + W`            | Браузер (chrome)                  |
| `SUPER + SHIFT + W`    | Смена обоев (rofi)                |
| `SUPER + SHIFT + Q`    | Power menu (rofi)                 |
| `SUPER + S`            | Ланчер (rofi drun)                |
| `SUPER + D` / `F`      | Maximize / Fullscreen             |
| `SUPER + V`            | Float toggle                      |
| `SUPER + SHIFT + S`    | Скрин области (в буфер)           |
| `PRINT`                | Скрин всего (в буфер)             |
| `SUPER + SHIFT + C`    | Пайпетка (цвет)                   |
| `SUPER + 1..0`         | Воркспейсы (с SHIFT — перенос)    |
| `SUPER + стрелки`      | Фокус                            |
| `XF86Audio*`           | Громкость/яркость/медиа           |

Приложения закреплены по воркспейсам: chrome=1, vesktop/ayugram=2, zed=3, steam=10, игры (стим)=4.

## Структура

```
flake.nix                        собирает *.nix во всём репо автоматически (кроме _префиксных)
nixos/base/                      база: система, тема, пользователь, keymap, мониторы, persist
nixos/extra/                     опциональное железо (gpu, openrgb, v2raya)
nixos/features/<name>/           каждая фича: default.nix + конфиги рядом
nixos/features/nvim/             nvim на nixvim (плагины из Nix, Lua-конфиг в lua/)
nixos/hosts/main/                сборка nixosConfigurations.luynar + разметка диска (_disko.nix)
Wallpapers/                      обои для рофл-свитчера
```

Файлы с `_` в начале имени (`_disko.nix`, `_binds.nix`, ...) не импортируются автоматически —
это не самостоятельные flake-модули, а куски, которые явно подключают другие файлы.

## Переустановка (disko + impermanence)

Разметка диска не делается руками — она описана в `nixos/hosts/main/_disko.nix`
и накатывается одной командой через [disko](https://github.com/nix-community/disko).
После установки `/` — это tmpfs (чистая система на каждой загрузке), `/nix` и `/home`
живут на своих постоянных разделах, так что пакеты, доты через home-manager, ssh-ключи,
браузер, Steam — всё, что лежит в `/home`, — переустановку переживает само. Отдельно
персистится только горстка системных файлов (`/etc/machine-id`, коннекшены NetworkManager)
через `environment.persistence."/persist"`.

**⚠️ `_disko.nix` форматирует диск — необратимо. Перед запуском обязательно закоммить
и запушь всё важное, и убедись что `device` в файле указывает на правильный диск.**

С livecd-установщика NixOS (интернет и git должны быть доступны):

```bash
git clone https://github.com/luynrs/nixconf.git
sudo nix run github:nix-community/disko -- --mode destroy,format,mount ./nixconf/nixos/hosts/main/_disko.nix
sudo nixos-install --flake ./nixconf#luynar
```

После первой загрузки на новом разделе включи персист (он выключен по умолчанию,
чтобы не сломать текущую ext4-систему): в `nixos/hosts/main/configuration.nix` добавь
`persistance.enable = true;` рядом с блоком `preferences` (на одном уровне с ним,
внутри `flake.nixosModules.hostMain`), закоммить и `sudo nixos-rebuild switch --flake .#luynar`.

Данных, которых на диске никогда не было (например ты первый раз ставишь систему на новое
железо), это не восстановит — ssh/gpg-ключи, сессии в мессенджерах и т.п. нужно занести
в `/home` самому (бэкапом/rsync) до или после установки.

## Темизация

Цвета задаются один раз в `theme.nix` → `config.theme.*` (палитра Catppuccin Mocha, тянется из `catppuccin/nix`), дальше уходят в hyprland/foot/starship нативно, а в waybar/dunst/rofi/hyprshot через `lib.replaceStrings` по плейсхолдерам. GTK/Qt Catppuccin Mocha (lavender), иконки Papirus.
