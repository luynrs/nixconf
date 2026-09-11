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
            "identity.fxaccounts.toolbar.enabled" = false;
            "gfx.webrender.quality.force-subpixel-aa-where-possible" = true;

            "media.peerconnection.enabled" = false;
            "media.eme.enabled" = true;
            "network.trr.mode" = 2;

            "layout.css.prefers-color-scheme.content-override" = 2;

            "browser.startup.page" = 3;
            "browser.sessionstore.resume_session_once" = false;

            "middlemouse.paste" = false;

            "gfx.webrender.all" = true;
            "media.ffmpeg.vaapi.enabled" = true;

            "layout.frame_rate" = 0;

            "browser.cache.disk.enable" = false;
            "browser.cache.memory.enable" = true;
            "browser.cache.memory.capacity" = 524288;

            "extensions.pocket.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "toolkit.telemetry.enabled" = false;
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
          };

          extensions = {
            force = true;
            packages = with pkgs.nur.repos.rycee.firefox-addons; [
              ublock-origin
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
