{
  config,
  ...
}:
let
  theme = config.theme;
in
{
  flake.nixosModules.hyprland =
    { config, lib, ... }:
    let
      monitors = lib.mapAttrsToList (name: m: {
        output = name;
        mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "auto";
        scale = 1;
      }) (lib.filterAttrs (_: m: m.enabled) config.preferences.monitors);
      layouts = lib.concatStringsSep "," config.preferences.keymap.layouts;
    in
    {
      programs.hyprland.enable = true;

      home-manager.users.${config.preferences.user.name}.wayland.windowManager.hyprland.settings = {
        monitor = monitors;
        config.input = {
          kb_layout = layouts;
          kb_options = config.preferences.keymap.options;
          follow_mouse = 1;
          sensitivity = 0;
          touchpad.natural_scroll = false;
        };
      };
    };
  flake.homeModules.hyprland =
    { pkgs, lib, ... }:
    let
      hyprshot = import ./_hyprshot.nix { inherit lib pkgs theme; };
      animations = import ./_animations.nix;
      rules = import ./_rules.nix;
      binds = import ./_binds.nix { inherit lib; };
      autostart = import ./_autostart.nix { inherit lib pkgs; };
    in
    {
      home.packages = [
        hyprshot
        pkgs.hyprpicker
        pkgs.awww
        pkgs.wl-clipboard
      ];

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";

        settings = {
          mainMod = {
            _var = "SUPER";
          };
          terminal = {
            _var = "foot";
          };
          fileManager = {
            _var = "nautilus";
          };
          browser = {
            _var = "google-chrome-stable --force-dark-mode --enable-features=WebUIDarkMode";
          };
          wallpaper = {
            _var = "$HOME/.config/rofi/scripts/wallpapermenu.sh";
          };
          powermenu = {
            _var = "$HOME/.config/rofi/scripts/powermenu.sh";
          };
          picker = {
            _var = "hyprpicker -a";
          };

          config = {
            general = {
              gaps_in = 5;
              gaps_out = 5;
              border_size = 1;
              col.active_border = {
                colors = [
                  "rgba(${lib.removePrefix "#" theme.borderActive1}ee)"
                  "rgba(${lib.removePrefix "#" theme.borderActive2}ee)"
                ];
                angle = 45;
              };
              col.inactive_border = "rgba(${lib.removePrefix "#" theme.borderInactive}aa)";
              allow_tearing = false;
              layout = "dwindle";
              resize_on_border = true;
            };

            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 1.0;

              shadow.enabled = false;

              blur = {
                enabled = true;
                size = 1;
                passes = 4;
                vibrancy = 0.1696;
              };
            };

            animations.enabled = true;

            dwindle.preserve_split = true;

            misc = {
              force_default_wallpaper = -1;
              focus_on_activate = true;
            };
          };

          inherit (animations) curve animation;
          inherit (rules) env layer_rule window_rule;

          bind = binds;
          on = autostart;
        };
      };
    };
}
