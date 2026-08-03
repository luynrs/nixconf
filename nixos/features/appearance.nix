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
        package = pkgs.adw-gtk3;
        name = "adw-gtk3-dark";
      };
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
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
      platformTheme = {
        name = "qtengine";
        package = pkgs.qtengine;
      };
      style.name = "kvantum";
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          gtk-theme = "adw-gtk3-dark";
          icon-theme = "Papirus-Dark";
          enable-animations = false;
        };
      };
    };
  };
}
