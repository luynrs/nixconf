{ ... }:
{
  flake.nixosModules.hyprland =
    { config, lib, ... }:
    let
      monitors = lib.mapAttrsToList (name: m: {
        output = name;
        mode = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
        position = "${toString m.x}x${toString m.y}";
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
      inline = lib.generators.mkLuaInline;
      hyprshot = import ./_hyprshot.nix { inherit lib pkgs; };
      animations = import ./_animations.nix;
      rules = import ./_rules.nix;
      binds = import ./_binds.nix { inherit lib; };
      autostart = import ./_autostart.nix { inherit lib pkgs; };
    in
    {
      home.packages = [
        hyprshot
        pkgs.hyprpicker
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
            _var = "librewolf";
          };
          picker = {
            _var = "hyprpicker -a";
          };

          config = {
            general = {
              gaps_in = 5;
              gaps_out = 8;
              border_size = 1;
              col.active_border = {
                colors = inline ''
                  (function()
                    local ok, s = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/scheme/current.lua")
                    if ok and s and s.primary and s.secondary then
                      return { "rgba(" .. s.primary .. "ee)", "rgba(" .. s.secondary .. "ee)" }
                    end
                  end)()
                '';
                angle = 45;
              };
              col.inactive_border = inline ''
                (function()
                  local ok, s = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/scheme/current.lua")
                  if ok and s and s.outlineVariant then
                    return "rgba(" .. s.outlineVariant .. "aa)"
                  end
                end)()
              '';
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
          inherit (rules) env window_rule;

          bind = binds;
          on = autostart;
        };
      };
    };
}
