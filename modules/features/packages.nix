{ ... }:
{
  flake.modules.homeManager.packages = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      git
      wget
      eza
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
      btop

      ayugram-desktop
      discord

      (pkgs.writeShellScriptBin "claude" ''
        export HTTP_PROXY="http://127.0.0.1:20171"
        export HTTPS_PROXY="http://127.0.0.1:20171"
        export ALL_PROXY="socks5://127.0.0.1:20170"
        export NO_PROXY="localhost,127.0.0.1,::1"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      '')
    ];

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
          accents = [ "sapphire" ];
        };
        name = "catppuccin-mocha-sapphire-standard";
      };
      iconTheme = {
        package = pkgs.adwaita-icon-theme;
        name = "Adwaita";
      };
      gtk3.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
      gtk4.extraConfig = {
        "gtk-application-prefer-dark-theme" = true;
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "catppuccin-mocha-sapphire-standard";
          icon-theme = "Adwaita";
          enable-animations = false;
        };
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk3";
      style = {
        package = pkgs.adwaita-qt;
        name = "adwaita-dark";
      };
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
