_: {
  flake.homeModules.ghostty =
    { config, ... }:
    {
      programs.ghostty = {
        enable = true;

        settings = {
          config-file = "?${config.xdg.stateHome}/caelestia/theme/ghostty.conf";

          font-family = "JetBrainsMono Nerd Font";

          window-padding-x = 29;
          window-padding-y = 29;

          cursor-style = "bar";
          cursor-style-blink = false;

          background-opacity = 0.9;

          resize-overlay = "never";
          confirm-close-surface = false;

          quit-after-last-window-closed = true;
          quit-after-last-window-closed-delay = "5m";
        };
      };
    };
}
