{ ... }:
{
  flake.modules.homeManager.foot = { pkgs, ... }: {
    home.packages = [ pkgs.foot ];

    programs.foot = {
      enable = true;

      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=12";
          shell = "fish";
          pad = "29x29";
        };

        scrollback.lines = 10000;

        cursor = {
          style = "beam";
          beam-thickness = 1.5;
        };

        "colors-dark" = {
          alpha = 0.9;
          blur = true;
        };

        "key-bindings" = {
          scrollback-up-page = "Shift+Page_Up Shift+KP_Page_Up Page_Up";
          scrollback-down-page = "Shift+Page_Down Shift+KP_Page_Down Page_Down";
          search-start = "Control+Shift+r Control+f";
          font-decrease = "Control+minus Control+underscore Control+KP_Subtract";
        };
      };
    };
  };
}
