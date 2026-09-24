{
  flake.homeModules.foot =
    { config, ... }:
    {
      programs.foot = {
        enable = true;

        settings = {
          main = {
            font = "JetBrainsMono Nerd Font:size=12, Noto Color Emoji:size=12";
            pad = "24x24";
            include = "${config.xdg.stateHome}/caelestia/theme/foot.ini";
          };

          cursor = {
            style = "beam";
            blink = "no";
          };
        };
      };
    };
}
