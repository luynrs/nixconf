{ lib, ... }:
{
  flake.homeModules.media = { pkgs, ... }: {
    home.packages = with pkgs; [
      loupe
      showtime
      mpv
    ];

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
        // (lib.genAttrs audio (_: "mpv.desktop"))
        // {
          "inode/directory" = "org.gnome.Nautilus.desktop";
        };
    };
  };
}
