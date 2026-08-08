{ ... }:
{
  flake.homeModules.librewolf =
    { pkgs, ... }:
    {
      home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

      programs.librewolf = {
        enable = true;
        profiles.default = {
          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            privacy-badger
            foxyproxy-standard
          ];

          search = {
            force = true;
            default = "google";
            engines = {
              bing.metaData.hidden = true;
              ddg.metaData.hidden = true;
              ebay.metaData.hidden = true;
              wikipedia.metaData.hidden = true;
            };
          };
        };
      };
    };
}
