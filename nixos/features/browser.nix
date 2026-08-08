{ ... }:
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
            "browser.startup.page" = 3;
            "browser.sessionstore.resume_from_crash" = true;
          };

          userChrome = ''
            #urlbar-searchmode-switcher { display: none !important; }
          '';

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
              privacy-badger
              foxyproxy-standard
            ];
            settings."foxyproxy@eric.h.jung".settings = {
              mode = "disable";
              passthrough = "";
              data = [
                {
                  active = true;
                  title = "SOCKS";
                  type = "socks5";
                  hostname = "127.0.0.1";
                  port = "1080";
                  username = "";
                  password = "";
                  cc = "";
                  city = "";
                  color = "#0adc4d";
                  proxyDNS = true;
                  include = [ ];
                  exclude = [ ];
                  tabProxy = [ ];
                }
              ];
            };
          };

          search = {
            force = true;
            default = "google";
          };
        };
      };
    };
}
