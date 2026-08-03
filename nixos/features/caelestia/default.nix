{ inputs, self, ... }:
{
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
          enableChromium = false;
          postHook = "hyprctl reload";
        };

        systemd.enable = false;

        package =
          inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.with-cli.overrideAttrs
            (_old: {
              src = self + /vendor/caelestia-shell;
            });
      };

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
                tray = {
                  background = true;
                  compact = false;
                  recolour = true;
                };
                workspaces = {
                  activeIndicator = true;
                  activeTrail = true;
                  occupiedBg = false;
                };
              };
              dashboard.performance.showBattery = false;
              services = {
                audioIncrement = 0.05;
                brightnessIncrement = 0.05;
                useFahrenheit = false;
                useTwelveHourClock = false;
              };
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
          # Plain Material "standard" ease (cubic-bezier(0.4, 0, 0.2, 1)) — no overshoot,
          # no multi-segment "expressive" pacing, applied uniformly so nothing feels springy.
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
