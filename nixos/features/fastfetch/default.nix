{
  flake.homeModules.fastfetch =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      home.packages = [ pkgs.fastfetch ];

      home.activation.seedFastfetchTheme = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
        themeFile="${config.xdg.stateHome}/caelestia/theme/fastfetch.jsonc"
        if [ ! -e "$themeFile" ]; then
          mkdir -p "$(dirname "$themeFile")"
          cp ${./config.jsonc} "$themeFile"
        fi
      '';

      xdg.configFile = {
        "caelestia/templates/fastfetch.jsonc".source = ./config.jsonc;

        "fastfetch/config.jsonc".source =
          config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/caelestia/theme/fastfetch.jsonc";

        "fastfetch/logo.png".source = ./logo.png;
      };
    };
}
