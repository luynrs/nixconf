{ inputs, self, ... }:
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
      inherit (self) guiApps;
      apps = guiApps;
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
          apps = {
            explorer = [
              apps.explorer
              "--new-window"
            ];
            playback = [ apps.playback ];
            terminal = [ apps.terminal ];
          };
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
            "${apps.terminal}"
            "${apps.terminal}client"
            "${apps.terminal}-server"
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
          maxToasts = 3;
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
            dndChanged = false;
            gameModeChanged = false;
            kbLayoutChanged = false;
            nowPlaying = false;
            numLockChanged = false;
          };
          vpn = {
            enabled = false;
            provider = [
              {
                connectCmd = [
                  "jray"
                  "up"
                  "--tun"
                ];
                disconnectCmd = [
                  "jray"
                  "up"
                  "--proxy"
                ];
                displayName = "justray";
                id = "vpn-mt4hvdiz-42oig";
                interface = "justray";
                name = "justray";
              }
            ];
            selectedProvider = "vpn-mt4hvdiz-42oig";
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

      xdg.configFile."caelestia/templates/foot.ini".text = ''
        [colors-dark]
        alpha = 0.5
        blur = yes
        background = {{ background.hex }}
        foreground = {{ onBackground.hex }}
        cursor = {{ onPrimary.hex }} {{ primary.hex }}
        selection-background = {{ primary.hex }}
        selection-foreground = {{ onPrimary.hex }}
        regular0 = {{ term0.hex }}
        regular1 = {{ term1.hex }}
        regular2 = {{ term2.hex }}
        regular3 = {{ term3.hex }}
        regular4 = {{ term4.hex }}
        regular5 = {{ term5.hex }}
        regular6 = {{ term6.hex }}
        regular7 = {{ term7.hex }}
        bright0 = {{ term8.hex }}
        bright1 = {{ term9.hex }}
        bright2 = {{ term10.hex }}
        bright3 = {{ term11.hex }}
        bright4 = {{ term12.hex }}
        bright5 = {{ term13.hex }}
        bright6 = {{ term14.hex }}
        bright7 = {{ term15.hex }}
      '';

      home.activation.caelestiaShellConfig = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        target="${config.xdg.configHome}/caelestia/shell.json"
        mkdir -p "$(dirname "$target")"
        tmp="$(mktemp "$(dirname "$target")/.shell.json.XXXXXX")"
        cat > "$tmp" <<'SHELL_JSON'
        ${builtins.toJSON shellSettings}
        SHELL_JSON
        mv -f "$tmp" "$target"
      '';

      home.activation.caelestiaScheme = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        cli=${config.programs.caelestia.cli.package}/bin/caelestia
        scheme="${config.xdg.stateHome}/caelestia/scheme.json"
        if [ ! -e "$scheme" ]; then
          "$cli" scheme set -n dynamic || true
        else
          "$cli" scheme set \
            -n "$(${pkgs.jq}/bin/jq -r .name "$scheme")" \
            -f "$(${pkgs.jq}/bin/jq -r .flavour "$scheme")" \
            -m "$(${pkgs.jq}/bin/jq -r .mode "$scheme")" || true
        fi
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
