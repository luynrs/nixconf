{ inputs, self, ... }:
{
  flake.nixosModules.caelestia =
    { config, ... }:
    {
      security.sudo.extraRules = [
        {
          users = [ config.preferences.user.name ];
          commands = [
            {
              command = "/run/current-system/sw/bin/mkdir -p /etc/chromium/policies/managed";
              options = [ "NOPASSWD" ];
            }
            {
              command = "/run/current-system/sw/bin/tee /etc/chromium/policies/managed/caelestia.json";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };

  flake.homeModules.caelestia =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      programs.caelestia = {
        enable = true;
        cli.enable = true;
        cli.settings.theme = {
          enableChromium = true;
          postHook = "hyprctl reload";
        };

        systemd.enable = false;

        package =
          inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs
            (_old: {
              src = self + /vendor/caelestia-shell;
            });
      };

      # User templates rendered by the caelestia CLI into
      # ~/.local/state/caelestia/theme/ on every scheme change.
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
        read_only = " "
        read_only_style = "bold #{{ red.hex }}"

        [git_branch]
        symbol = "  "
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
        symbol = "  "
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

      home.activation.caelestiaScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${config.programs.caelestia.cli.package}/bin/caelestia scheme set -n catppuccin -f mocha -m dark || true
      '';

      home.activation.caelestiaShellDefaults =
        let
          shellDefaults = pkgs.writeText "caelestia-shell-defaults.json" (
            builtins.toJSON {
              appearance = {
                deformScale = 0;
                transparency.enabled = true;
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
                showOnHover = false;
                statusIcons = [
                  { id = "battery"; enabled = false; }
                  { id = "kbLayout"; enabled = true; }
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
              dashboard.performance.showBattery = false;
              services = {
                audioIncrement = 0.05;
                brightnessIncrement = 0.05;
                useFahrenheit = false;
                useTwelveHourClock = false;
              };
              utilities.toasts.kbLayoutChanged = false;
            }
          );
        in
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          mkdir -p "$HOME/.config/caelestia"
          if [ ! -e "$HOME/.config/caelestia/shell.json" ]; then
            install -m644 ${shellDefaults} "$HOME/.config/caelestia/shell.json"
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
