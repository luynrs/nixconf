{ ... }:
{
  flake.modules.homeManager.packages = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      git
      gh
      wget
      eza
      nodejs
      procps
      nixd
      nil
      ruff
      brightnessctl
      playerctl
      nautilus
      pavucontrol
      google-chrome
      loupe
      showtime
      mpv

      steam

      ayugram-desktop

      (pkgs.writeShellScriptBin "claude" ''
        export HTTP_PROXY="http://127.0.0.1:20171"
        export HTTPS_PROXY="http://127.0.0.1:20171"
        export ALL_PROXY="socks5://127.0.0.1:20170"
        export NO_PROXY="localhost,127.0.0.1,::1"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      '')
    ];

    programs.btop.enable = true;

    programs.vesktop.enable = true;

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      font = {
        name = "Noto Sans";
        size = 12;
      };
      theme = {
        package = pkgs.catppuccin-gtk.override {
          variant = "mocha";
          accents = [ "lavender" ];
        };
        name = "catppuccin-mocha-lavender-standard";
      };
      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
      gtk4.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style.name = "kvantum";
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "catppuccin-mocha-lavender-standard";
          icon-theme = "Papirus-Dark";
          enable-animations = false;
        };
      };
    };

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
