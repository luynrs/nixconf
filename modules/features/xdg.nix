{ lib, ... }:
{
  flake.modules.homeManager.xdg = { pkgs, ... }: {
    xdg.desktopEntries.google-chrome = {
      name = "Google Chrome";
      genericName = "Web Browser";
      icon = "google-chrome";
      exec = "${pkgs.google-chrome}/bin/google-chrome-stable --force-dark-mode --enable-features=WebUIDarkMode %U";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeType = [
        "text/html"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications =
        let
          images = [
            "image/png"
            "image/jpeg"
            "image/gif"
            "image/webp"
            "image/bmp"
            "image/svg+xml"
          ];
          videos = [
            "video/mp4"
            "video/x-matroska"
            "video/webm"
            "video/quicktime"
            "video/x-msvideo"
          ];
          audio = [
            "audio/mpeg"
            "audio/flac"
            "audio/ogg"
            "audio/wav"
          ];
        in
        (lib.genAttrs images (_: "org.gnome.Loupe.desktop"))
        // (lib.genAttrs videos (_: "org.gnome.Showtime.desktop"))
        // (lib.genAttrs audio (_: "mpv.desktop"));
    };
  };
}
