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
      inline = lib.generators.mkLuaInline;
      toLua = lib.generators.toLua { };
      polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";

      # Vendored hyprshot (files/hyprshot/hyprshot), patched for a styled slurp selection.
      hyprshotScript = pkgs.writeText "hyprshot" (
        lib.replaceStrings
          [ "__BORDER__" "__BG__" ]
          [
            (lib.removePrefix "#" theme.accent)
            (lib.removePrefix "#" theme.bgDark)
          ]
          (builtins.readFile ./files/hyprshot/hyprshot)
      );
      hyprshot = pkgs.stdenvNoCC.mkDerivation {
        pname = "hyprshot";
        version = "1.3.0-luynar";
        dontUnpack = true;
        nativeBuildInputs = [ pkgs.makeWrapper ];
        installPhase = ''
          install -Dm755 ${hyprshotScript} $out/bin/hyprshot
          wrapProgram $out/bin/hyprshot --prefix PATH : ${
            lib.makeBinPath (
              with pkgs;
              [
                hyprland
                jq
                grim
                slurp
                wl-clipboard
                libnotify
                hyprpicker
              ]
            )
          }
        '';
      };

      # Signals waybar.nix's custom/wsN modules on workspace change (Waybar#5008 workaround).
      hyprWorkspaceWatch = pkgs.writeShellScriptBin "hypr-workspace-watch" ''
        socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
        ${pkgs.socat}/bin/socat -U - "UNIX-CONNECT:$socket" | while IFS= read -r line; do
          case "$line" in
            workspace*|createworkspace*|destroyworkspace*|moveworkspace*)
              ${pkgs.procps}/bin/pkill -RTMIN+8 waybar
              ;;
          esac
        done
      '';
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
            _var = "kitty";
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
              border_size = 2;
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
            };

            decoration = {
              rounding = 10;
              active_opacity = 1.0;
              inactive_opacity = 1.0;

              shadow = {
                enabled = true;
                range = 4;
                render_power = 3;
                color = "rgba(1a1a1aee)";
              };

              blur = {
                enabled = true;
                size = 1;
                passes = 4;
                vibrancy = 0.1696;
              };
            };

            animations.enabled = true;

            dwindle.preserve_split = true;

            misc.force_default_wallpaper = -1;

            input = {
              kb_layout = "us,ru";
              kb_options = "grp:alt_shift_toggle";
              follow_mouse = 1;
              sensitivity = 0;
              touchpad.natural_scroll = false;
            };
          };

          curve = [
            {
              _args = [
                "easeOutQuint"
                {
                  type = "bezier";
                  points = [
                    [
                      0.23
                      1
                    ]
                    [
                      0.32
                      1
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "easeInOutCubic"
                {
                  type = "bezier";
                  points = [
                    [
                      0.65
                      0.05
                    ]
                    [
                      0.36
                      1
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "linear"
                {
                  type = "bezier";
                  points = [
                    [
                      0
                      0
                    ]
                    [
                      1
                      1
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "almostLinear"
                {
                  type = "bezier";
                  points = [
                    [
                      0.5
                      0.5
                    ]
                    [
                      0.75
                      1.0
                    ]
                  ];
                }
              ];
            }
            {
              _args = [
                "quick"
                {
                  type = "bezier";
                  points = [
                    [
                      0.15
                      0
                    ]
                    [
                      0.1
                      1
                    ]
                  ];
                }
              ];
            }
          ];

          animation = [
            {
              leaf = "global";
              enabled = true;
              speed = 10;
              bezier = "default";
            }
            {
              leaf = "border";
              enabled = true;
              speed = 5.39;
              bezier = "easeOutQuint";
            }
            {
              leaf = "windows";
              enabled = true;
              speed = 4.79;
              bezier = "easeOutQuint";
            }
            {
              leaf = "windowsIn";
              enabled = true;
              speed = 4.1;
              bezier = "easeOutQuint";
              style = "popin 87%";
            }
            {
              leaf = "windowsOut";
              enabled = true;
              speed = 1.49;
              bezier = "linear";
              style = "popin 87%";
            }
            {
              leaf = "fadeIn";
              enabled = true;
              speed = 1.73;
              bezier = "almostLinear";
            }
            {
              leaf = "fadeOut";
              enabled = true;
              speed = 1.46;
              bezier = "almostLinear";
            }
            {
              leaf = "fade";
              enabled = true;
              speed = 3.03;
              bezier = "quick";
            }
            {
              leaf = "layers";
              enabled = true;
              speed = 3.81;
              bezier = "easeOutQuint";
            }
            {
              leaf = "layersIn";
              enabled = true;
              speed = 4;
              bezier = "easeOutQuint";
              style = "fade";
            }
            {
              leaf = "layersOut";
              enabled = true;
              speed = 1.5;
              bezier = "linear";
              style = "fade";
            }
            {
              leaf = "fadeLayersIn";
              enabled = true;
              speed = 1.79;
              bezier = "almostLinear";
            }
            {
              leaf = "fadeLayersOut";
              enabled = true;
              speed = 1.39;
              bezier = "almostLinear";
            }
            {
              leaf = "workspaces";
              enabled = true;
              speed = 3.8;
              bezier = "easeOutQuint";
              style = "slide";
            }
            {
              leaf = "workspacesIn";
              enabled = true;
              speed = 3.8;
              bezier = "easeOutQuint";
              style = "slide";
            }
            {
              leaf = "workspacesOut";
              enabled = true;
              speed = 3.8;
              bezier = "easeOutQuint";
              style = "slide";
            }
          ];

          env = [
            {
              _args = [
                "XCURSOR_SIZE"
                "24"
              ];
            }
            {
              _args = [
                "XCURSOR_THEME"
                "Bibata-Modern-Classic"
              ];
            }
            {
              _args = [
                "HYPRCURSOR_SIZE"
                "24"
              ];
            }
            {
              _args = [
                "HYPRCURSOR_THEME"
                "Bibata-Modern-Classic"
              ];
            }
            {
              _args = [
                "ELECTRON_OZONE_PLATFORM_HINT"
                "auto"
              ];
            }
          ];

          layer_rule = [
            {
              match.namespace = "waybar";
              blur = true;
            }
            {
              match.namespace = "rofi";
              blur = true;
            }
          ];

          bind = [
            {
              _args = [
                (inline ''mainMod .. " + RETURN"'')
                (inline "hl.dsp.exec_cmd(terminal)")
                { description = "Terminal"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + Q"'')
                (inline "hl.dsp.window.close()")
                { description = "Close window"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + E"'')
                (inline "hl.dsp.exec_cmd(fileManager)")
                { description = "File manager"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + W"'')
                (inline "hl.dsp.exec_cmd(browser)")
                { description = "Browser"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + SHIFT + W"'')
                (inline "hl.dsp.exec_cmd(wallpaper)")
                { description = "Wallpaper switcher"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + SHIFT + Q"'')
                (inline "hl.dsp.exec_cmd(powermenu)")
                { description = "Power menu"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + V"'')
                (inline ''hl.dsp.window.float({ action = "toggle" })'')
                { description = "Toggle floating"; }
              ];
            }
            {
              _args = [
                "SUPER + D"
                (inline ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'')
                { description = "Window: Maximize"; }
              ];
            }
            {
              _args = [
                "SUPER + F"
                (inline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
                { description = "Window: Fullscreen"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + S"'')
                (inline ''hl.dsp.exec_cmd("rofi -show drun")'')
                { description = "App launcher"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + P"'')
                (inline "hl.dsp.window.pseudo()")
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + J"'')
                (inline ''hl.dsp.layout("togglesplit")'')
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + SHIFT + C"'')
                (inline "hl.dsp.exec_cmd(picker)")
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + SHIFT + S"'')
                (inline ''hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze")'')
                { description = "Screenshot: area"; }
              ];
            }
            {
              _args = [
                "PRINT"
                (inline ''hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only")'')
                { description = "Screenshot: full screen"; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + left"'')
                (inline ''hl.dsp.focus({ direction = "l" })'')
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + right"'')
                (inline ''hl.dsp.focus({ direction = "r" })'')
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + up"'')
                (inline ''hl.dsp.focus({ direction = "u" })'')
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + down"'')
                (inline ''hl.dsp.focus({ direction = "d" })'')
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + mouse:272"'')
                (inline "hl.dsp.window.drag()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                (inline ''mainMod .. " + mouse:273"'')
                (inline "hl.dsp.window.resize()")
                { mouse = true; }
              ];
            }
            {
              _args = [
                "XF86AudioRaiseVolume"
                (inline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioLowerVolume"
                (inline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioMute"
                (inline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioMicMute"
                (inline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessUp"
                (inline ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86MonBrightnessDown"
                (inline ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-")'')
                {
                  locked = true;
                  repeating = true;
                }
              ];
            }
            {
              _args = [
                "XF86AudioNext"
                (inline ''hl.dsp.exec_cmd("playerctl next")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioPause"
                (inline ''hl.dsp.exec_cmd("playerctl play-pause")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioPlay"
                (inline ''hl.dsp.exec_cmd("playerctl play-pause")'')
                { locked = true; }
              ];
            }
            {
              _args = [
                "XF86AudioPrev"
                (inline ''hl.dsp.exec_cmd("playerctl previous")'')
                { locked = true; }
              ];
            }
          ]
          ++ (lib.genList (
            i:
            let
              ws = i + 1;
              key = if ws == 10 then 0 else ws;
            in
            {
              _args = [
                (inline "mainMod .. \" + \" .. ${toString key}")
                (inline "hl.dsp.focus({ workspace = ${toString ws} })")
              ];
            }
          ) 10)
          ++ (lib.genList (
            i:
            let
              ws = i + 1;
              key = if ws == 10 then 0 else ws;
            in
            {
              _args = [
                (inline "mainMod .. \" + SHIFT + \" .. ${toString key}")
                (inline "hl.dsp.window.move({ workspace = ${toString ws} })")
              ];
            }
          ) 10);

          on = {
            _args = [
              "hyprland.start"
              (inline ''
                function()
                  hl.exec_cmd("waybar")
                  hl.exec_cmd("awww-daemon")
                  hl.exec_cmd(${toLua polkitAgent})
                  hl.exec_cmd("dunst")
                  hl.exec_cmd("hypr-workspace-watch")
                end
              '')
            ];
          };
        };
      };
    };
}
