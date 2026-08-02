{ ... }:
{
  flake.homeModules.appearance = { pkgs, ... }: {
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
  };
}
