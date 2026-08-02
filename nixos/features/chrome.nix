{ ... }:
{
  flake.homeModules.chrome = { pkgs, ... }: {
    home.packages = [ pkgs.google-chrome ];

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
  };
}
