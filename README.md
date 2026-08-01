# nix-config

Личный конфиг NixOS + Home Manager: Hyprland (lua), Catppuccin Mocha, fish + starship, kitty, waybar, rofi, dunst.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#luynar   # система
nh home switch                                # или home-manager
nix fmt                                       # форматирование (nixfmt)
```

Новые файлы перед сборкой: `git add` (flake видит только отслеживаемые).

## Хоткеи (Hyprland)

| Клавиша                | Действие                          |
| ---------------------- | --------------------------------- |
| `SUPER + RETURN`       | Терминал                          |
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

Приложения закреплены по воркспейсам: chrome=1, vesktop/ayugram=2, zed=3, steam=10, игры=4.

## Структура

```
flake.nix                        входы + фичи (imports)
modules/core/theme.nix           палитра — единый источник цветов
modules/core/desktop.nix         базовый NixOS (boot, users, audio, greetd)
modules/core/hosts/luynar.nix    сборка всего в nixosConfigurations
modules/features/<name>/         каждая фича: default.nix + конфиги рядом
Wallpapers/                      обои для рофл-свитчера
```

## Темизация

Цвета задаются один раз в `theme.nix` → `config.theme.*`, дальше уходят в hyprland/kitty/starship нативно, а в waybar/dunst/rofi/hyprshot через `lib.replaceStrings` по плейсхолдерам.

## Запатчено

- `kitty/disable-resize-text.patch` — убран оверлей «N by N cells» при ресайзе (опции в kitty больше нет).
- `hyprland/hyprshot` — тематизированный регион slurp.
- `kitty/search.py` — скроллбек-поиск (ctrl+f).
- `rofi/scripts/*.sh` — powermenu и обои (из adi1090x).
