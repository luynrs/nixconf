{ self, ... }:
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
    in
    {
      programs.hyprland.enable = true;

      home-manager.users.luynar.wayland.windowManager.hyprland.settings = {
        monitor = monitors;
      }
      // import ./_input.nix { inherit lib; };
    };
  flake.homeModules.hyprland =
    { pkgs, lib, ... }:
    let
      apps = self.guiApps;
      inline = lib.generators.mkLuaInline;
      animations = import ./_animations.nix;
      rules = import ./_rules.nix { inherit pkgs; };
      binds = import ./_binds.nix { inherit lib; };
      autostart = import ./_autostart.nix { inherit lib pkgs; };
    in
    {
      home.packages = [
        pkgs.hyprpicker
        pkgs.cliphist
        pkgs.fuzzel
        pkgs.wl-clipboard
      ];

      xdg.configFile."hypr/xdph.conf".text = ''
        screencopy {
          allow_token_by_default = true
        }
      '';

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";

        settings = {
          mainMod = {
            _var = "SUPER";
          };
          terminal = {
            _var = apps.terminal;
          };
          fileManager = {
            _var = apps.explorer;
          };
          browser = {
            _var = apps.browser;
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
                size = 8;
                passes = 3;
                new_optimizations = true;
                vibrancy = 0.1696;
              };
            };

            animations.enabled = true;

            dwindle.preserve_split = true;

            misc = {
              animate_manual_resizes = false;
              animate_mouse_windowdragging = false;

              disable_hyprland_logo = true;
              force_default_wallpaper = 0;

              on_focus_under_fullscreen = 2;
              allow_session_lock_restore = true;
              middle_click_paste = false;
              focus_on_activate = true;
              session_lock_xray = true;

              mouse_move_enables_dpms = true;
              key_press_enables_dpms = true;

              background_color = inline ''
                (function()
                  local ok, s = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/scheme/current.lua")
                  if ok and s and s.surfaceContainer then
                    return "rgb(" .. s.surfaceContainer .. ")"
                  end
                end)()
              '';
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
