{
  flake.homeModules.fastfetch = { pkgs, config, ... }: {
    home.packages = [ pkgs.fastfetch ];

    xdg.configFile = {
      "caelestia/templates/fastfetch.jsonc".source = ./config.jsonc;

      "fastfetch/config.jsonc".source =
        config.lib.file.mkOutOfStoreSymlink "${config.xdg.stateHome}/caelestia/theme/fastfetch.jsonc";

      "fastfetch/logo.png".source = ./logo.png;
    };
  };
}
