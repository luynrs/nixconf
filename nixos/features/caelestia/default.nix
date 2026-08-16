{ inputs, ... }:
{
  flake.homeModules.caelestia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (pkgs.stdenv.hostPlatform) system;
      upstream = inputs.caelestia-shell;

      caelestiaCli = upstream.inputs.caelestia-cli.packages.${system}.default.overrideAttrs (old: {
        src = pkgs.applyPatches {
          name = "caelestia-cli-src";
          src = old.src;
          patches = [ ./cli.patch ];
        };
      });

      shellSettings = {
        appearance = {
          deformScale = 0;
          transparency.enabled = true;
        };

        general = {
          showOverFullscreen = true;
          idle.timeouts = [
            {
              timeout = 180;
              idleAction = "lock";
            }
            {
              timeout = 600;
              idleAction = "dpms off";
              returnAction = "dpms on";
            }
          ];
        };

        bar = {
          activeWindow = {
            compact = true;
            inverted = true;
            showOnHover = false;
          };
          clock = {
            background = true;
            showDate = false;
            showIcon = false;
          };
          popouts = {
            activeWindow = false;
            tray = true;
          };
          scrollActions = {
            brightness = false;
            volume = false;
            workspaces = true;
          };
          showOnHover = false;
          statusIcons = [
            {
              enabled = true;
              id = "kbLayout";
            }
            {
              enabled = false;
              id = "audio";
            }
            {
              enabled = false;
              id = "microphone";
            }
            {
              enabled = true;
              id = "network";
            }
            {
              enabled = true;
              id = "bluetooth";
            }
            {
              enabled = true;
              id = "lockStatus";
            }
          ];
          tray = {
            background = true;
            compact = false;
            recolour = true;
          };
          workspaces = {
            activeIndicator = true;
            activeTrail = true;
            occupiedBg = false;
            shown = 5;
          };
        };

        dashboard = {
          performance.showBattery = false;
          showOnHover = false;
        };

        launcher = {
          hiddenApps = [
            "com.mitchellh.ghostty"
            "kvantummanager"
          ];
          useFuzzy.apps = true;
        };

        notifs = {
          defaultExpireTimeout = 3000;
          openExpanded = false;
        };

        sidebar = {
          showOnHover = true;
          minHoverThreshold = 30;
        };

        services = {
          audioIncrement = 0.05;
          brightnessIncrement = 0.05;
          useFahrenheit = false;
          useTwelveHourClock = false;
        };

        utilities = {
          enabled = false;
          quickToggles = [
            {
              enabled = true;
              id = "wifi";
            }
            {
              enabled = true;
              id = "bluetooth";
            }
            {
              enabled = true;
              id = "mic";
            }
            {
              enabled = true;
              id = "settings";
            }
            {
              enabled = true;
              id = "gameMode";
            }
            {
              enabled = false;
              id = "dnd";
            }
            {
              enabled = true;
              id = "vpn";
            }
          ];
          toasts = {
            configLoaded = false;
            kbLayoutChanged = false;
            nowPlaying = false;
          };
          vpn = {
            enabled = false;
            provider = [ ];
            selectedProvider = "";
          };
        };
      };
    in
    {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      programs.caelestia = {
        enable = true;
        cli.enable = true;
        cli.package = caelestiaCli;
        cli.settings = {
          theme.postHook = ''
            hyprctl reload
            systemctl --user reload app-com.mitchellh.ghostty.service || true
          '';
          record.extraArgs = [
            "-k"
            "av1"
            "-bm"
            "cbr"
            "-q"
            "12000"
          ];
        };

        systemd.enable = false;

        package =
          pkgs.callPackage
            "${
              pkgs.applyPatches {
                name = "caelestia-shell-src";
                src = upstream;
                patches = [ ./shell.patch ];
                patchFlags = [
                  "-p1"
                  "-E"
                ];
              }
            }/nix"
            {
              inherit (upstream.inputs) m3shapes;
              inherit (upstream) rev;
              stdenv = pkgs.clangStdenv;
              quickshell = upstream.inputs.quickshell.packages.${system}.default.override {
                withX11 = false;
                withI3 = false;
              };
              caelestia-cli = caelestiaCli;
              withCli = true;
            };
      };

      xdg.configFile."caelestia/templates/fish-colors.fish".text = ''
        # Unquoted, unprefixed hex: a leading "#" starts a fish comment.
        set -g fish_color_normal {{ onSurface.hex }}
        set -g fish_color_command {{ teal.hex }}
        set -g fish_color_keyword {{ mauve.hex }}
        set -g fish_color_quote {{ yellow.hex }}
        set -g fish_color_redirection {{ onSurface.hex }}
        set -g fish_color_end {{ peach.hex }}
        set -g fish_color_error {{ red.hex }}
        set -g fish_color_param {{ mauve.hex }}
        set -g fish_color_comment {{ surface2.hex }}
        set -g fish_color_selection --background={{ surface0.hex }}
        set -g fish_color_search_match --background={{ surface0.hex }}
        set -g fish_color_operator {{ green.hex }}
        set -g fish_color_escape {{ mauve.hex }}
        set -g fish_color_autosuggestion {{ surface2.hex }}

        set -g fish_pager_color_progress {{ surface2.hex }}
        set -g fish_pager_color_prefix {{ teal.hex }}
        set -g fish_pager_color_completion {{ onSurface.hex }}
        set -g fish_pager_color_description {{ surface2.hex }}
      '';

      xdg.configFile."caelestia/templates/starship.toml".text = ''
        add_newline = false

        format = "$directory$git_branch$git_status$nix_shell$cmd_duration\n$character"

        [directory]
        style = "bold #{{ blue.hex }}"
        format = "[$path]($style) "
        truncation_length = 3
        truncate_to_repo = true
        home_symbol = "~"
        read_only = " "
        read_only_style = "bold #{{ red.hex }}"

        [git_branch]
        symbol = "  "
        style = "bold #{{ mauve.hex }}"
        format = "[$symbol$branch]($style) "

        [git_status]
        style = "bold #{{ yellow.hex }}"
        format = "([$all_status$ahead_behind]($style) )"
        conflicted = "="
        ahead = "⇡"
        behind = "⇣"
        diverged = "⇕"
        untracked = "?"
        stashed = "*"
        modified = "!"
        staged = "+"
        renamed = "»"
        deleted = "✕"

        [nix_shell]
        symbol = "  "
        style = "bold #{{ teal.hex }}"
        format = "[$symbol$name]($style) "
        impure_msg = ""
        pure_msg = ""

        [cmd_duration]
        min_time = 2000
        style = "#{{ surface2.hex }}"
        format = "[$duration]($style) "

        [character]
        success_symbol = "[❯](bold #{{ green.hex }})"
        error_symbol = "[❯](bold #{{ red.hex }})"
        vimcmd_symbol = "[❮](bold #{{ lavender.hex }})"
      '';

      xdg.configFile."caelestia/templates/ghostty.conf".text = ''
        background = #{{ background.hex }}
        foreground = #{{ onBackground.hex }}
        cursor-color = #{{ primary.hex }}
        cursor-text = #{{ onPrimary.hex }}
        selection-background = #{{ primary.hex }}
        selection-foreground = #{{ onPrimary.hex }}
        palette = 0=#{{ term0.hex }}
        palette = 1=#{{ term1.hex }}
        palette = 2=#{{ term2.hex }}
        palette = 3=#{{ term3.hex }}
        palette = 4=#{{ term4.hex }}
        palette = 5=#{{ term5.hex }}
        palette = 6=#{{ term6.hex }}
        palette = 7=#{{ term7.hex }}
        palette = 8=#{{ term8.hex }}
        palette = 9=#{{ term9.hex }}
        palette = 10=#{{ term10.hex }}
        palette = 11=#{{ term11.hex }}
        palette = 12=#{{ term12.hex }}
        palette = 13=#{{ term13.hex }}
        palette = 14=#{{ term14.hex }}
        palette = 15=#{{ term15.hex }}
      '';

      home.activation.caelestiaScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -e "${config.xdg.stateHome}/caelestia/scheme.json" ]; then
          ${config.programs.caelestia.cli.package}/bin/caelestia scheme set -n catppuccin -f mocha -m dark || true
        fi
      '';

      home.activation.caelestiaShellConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        target="${config.xdg.configHome}/caelestia/shell.json"
        mkdir -p "$(dirname "$target")"
        cat > "$target" <<'SHELL_JSON'
        ${builtins.toJSON shellSettings}
        SHELL_JSON
      '';

      xdg.configFile."caelestia/shell-tokens.json".text =
        let
          simpleCurve = [
            0.4
            0
            0.2
            1
            1
            1
          ];
          curveNames = [
            "emphasized"
            "emphasizedAccel"
            "emphasizedDecel"
            "standard"
            "standardAccel"
            "standardDecel"
            "expressiveFastSpatial"
            "expressiveDefaultSpatial"
            "expressiveSlowSpatial"
            "expressiveFastEffects"
            "expressiveDefaultEffects"
            "expressiveSlowEffects"
          ];
        in
        builtins.toJSON {
          appearance.curves = lib.genAttrs curveNames (_: simpleCurve);
        };
    };
}
