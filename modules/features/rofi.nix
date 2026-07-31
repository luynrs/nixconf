{ config, ... }:
let
  theme = config.theme;
  withAlpha = color: alpha: color + alpha;
in
{
  flake.modules.homeManager.rofi = { pkgs, ... }: {
    home.packages = [ pkgs.rofi ];

    xdg.configFile = {
      "rofi/config.rasi".source = ./files/rofi/config.rasi;
      "rofi/launcher.rasi".source = ./files/rofi/launcher.rasi;
      "rofi/powermenu.rasi".source = ./files/rofi/powermenu.rasi;
      "rofi/wallpaper-switcher.rasi".source = ./files/rofi/wallpaper-switcher.rasi;
      "rofi/shared/colors.rasi".text = ''
        * {
          background: ${withAlpha theme.bg "E6"};
          background-alt: ${withAlpha theme.bgDark "E6"};
          foreground: ${theme.fg};
          urgent: ${withAlpha theme.accent "E6"};
          active-window: ${withAlpha theme.green "E6"};

          borderColor: ${theme.fgAlt}99;

        }
      '';
      "rofi/scripts/powermenu.sh" = {
        source = ./files/rofi/scripts/powermenu.sh;
        executable = true;
      };
      "rofi/scripts/wallpapermenu.sh" = {
        source = ./files/rofi/scripts/wallpapermenu.sh;
        executable = true;
      };
    };
  };
}
