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

            "network.trr.mode" = 2;
            "network.proxy.type" = 1;
            "network.proxy.socks" = "127.0.0.1";
            "network.proxy.socks_port" = 10808;
            "network.proxy.socks_version" = 5;
            "network.proxy.socks_remote_dns" = true;
            "network.proxy.no_proxies_on" = "localhost,127.0.0.1";

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
