{
  flake.homeModules.firefox =
    { pkgs, ... }:
    {
      home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

      programs.firefox = {
        enable = true;
        profiles.default = {
          settings = {
            "extensions.autoDisableScopes" = 0;
            "browser.urlbar.oneOffSearches" = false;
            "identity.fxaccounts.toolbar.enabled" = false;
            "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;

            "media.peerconnection.enabled" = false;
            "network.trr.mode" = 2;

            "layout.css.prefers-color-scheme.content-override" = 2;

            "browser.startup.page" = 3;
            "browser.sessionstore.resume_session_once" = false;

            "middlemouse.paste" = false;
          };

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              privacy-badger
              tab-session-manager
            ];
          };

          search = {
            force = true;
            default = "google";
          };
        };
      };
    };
}
