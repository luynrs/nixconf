{
  flake.homeModules.firefox =
    { pkgs, lib, ... }:
    let
      caelestiafoxId = "caelestiafox@caelestia.org";

      caelestiafoxXpi =
        pkgs.runCommand "caelestiafox-xpi"
          {
            nativeBuildInputs = [ pkgs.zip ];
            passthru.addonId = caelestiafoxId;
          }
          ''
            mkdir -p "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}"
            cp -r ${./caelestiafox/extension} extension
            chmod -R u+w extension
            cd extension
            zip -r -X "$out/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}/${caelestiafoxId}.xpi" manifest.json dist
          '';

      caelestiafoxApp =
        pkgs.runCommand "caelestiafox-native-app" { nativeBuildInputs = [ pkgs.makeWrapper ]; }
          ''
            install -Dm755 ${./caelestiafox/native-app.fish} $out/bin/caelestiafox
            wrapProgram $out/bin/caelestiafox \
              --prefix PATH : ${
                lib.makeBinPath [
                  pkgs.fish
                  pkgs.jq
                  pkgs.inotify-tools
                ]
              }
          '';
    in
    {
      home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

      home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
        name = "caelestiafox";
        description = "Native app for CaelestiaFox extension.";
        path = "${caelestiafoxApp}/bin/caelestiafox";
        type = "stdio";
        allowed_extensions = [ caelestiafoxId ];
      };

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
            "network.proxy.socks_port" = 1080;
            "network.proxy.socks_version" = 5;
            "network.proxy.socks_remote_dns" = true;
            "network.proxy.no_proxies_on" = "localhost,127.0.0.1";

            "privacy.sanitize.sanitizeOnShutdown" = true;
            "privacy.clearOnShutdown.cookies" = false;
            "privacy.clearOnShutdown.sessions" = false;

            "layout.css.prefers-color-scheme.content-override" = 1;

            "browser.startup.page" = 3;
            "browser.sessionstore.resume_session_once" = false;
          };

          extensions = {
            force = true;
            packages =
              (with pkgs.nur.repos.rycee.firefox-addons; [
                ublock-origin
                privacy-badger
                tab-session-manager
              ])
              ++ [ caelestiafoxXpi ];
          };

          search = {
            force = true;
            default = "google";
          };
        };
      };
    };
}
