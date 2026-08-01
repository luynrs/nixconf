{ config, ... }:
let
  theme = config.theme;
in
{
  flake.modules.nixos.hyprland = {
    programs.hyprland.enable = true;
  };

  flake.modules.homeManager.hyprland =
    { pkgs, lib, ... }:
    let
      hyprshot = import ./hyprshot.nix { inherit lib pkgs theme; };
      hyprWorkspaceWatch = import ./workspace-watch.nix { inherit pkgs; };
      animations = import ./animations.nix;
      rules = import ./rules.nix;
      binds = import ./binds.nix { inherit lib; };
      autostart = import ./autostart.nix { inherit lib pkgs; };
    in
    {
      home.packages = [
        hyprshot
        hyprWorkspaceWatch
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

          monitor = {
            output = "";
            mode = "1920x1080@165";
            position = "auto";
            scale = 1;
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

            input = {
              kb_layout = "us,ru";
              kb_options = "grp:alt_shift_toggle";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad.natural_scroll = false;
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
