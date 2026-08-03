{ inputs, ... }:
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
              src = /home/luynar/dev/caelestia-shell;
            });
      };

      home.activation.caelestiaScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${config.programs.caelestia.cli.package}/bin/caelestia scheme set -n catppuccin -f mocha -m dark || true
      '';

      xdg.configFile."caelestia/shell-tokens.json".text = builtins.toJSON {
        appearance.curves = {
          expressiveFastSpatial = [
            0
            0
            0
            1
            1
            1
          ];
          expressiveDefaultSpatial = [
            0
            0
            0
            1
            1
            1
          ];
          expressiveSlowSpatial = [
            0
            0
            0
            1
            1
            1
          ];
        };
      };
    };
}
