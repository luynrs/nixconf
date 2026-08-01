{ config, lib, ... }:
let
  theme = config.theme;
in
{
  flake.modules.homeManager.dunst = { pkgs, ... }: {
    home.packages = [ pkgs.dunst ];

    xdg.configFile."dunst/dunstrc".text =
      lib.replaceStrings
        [
          "__BG__"
          "__FG__"
          "__FGALT__"
          "__ACCENT__"
          "__RED__"
        ]
        [
          theme.bg
          theme.fg
          theme.fgAlt
          theme.accent
          theme.red
        ]
        (builtins.readFile ./dunstrc);
  };
}
