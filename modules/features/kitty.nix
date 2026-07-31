{ config, ... }:
let
  theme = config.theme;
in
{
  flake.modules.homeManager.kitty = { ... }: {
    programs.kitty = {
      enable = true;

      font = {
        name = "JetBrainsMono Nerd Font";
        size = 12.0;
      };

      settings = {
        cursor = theme.fgAlt;
        cursor_shape = "beam";
        cursor_trail = 1;
        url_color = theme.accent;
        confirm_os_window_close = 0;
        shell = "fish";

        window_margin_width = "21.75";

        background = theme.bg;
        foreground = theme.fg;
        background_opacity = "0.9";
        background_blur = 1;

        selection_background = theme.selection;
        selection_foreground = theme.fgAlt;

        color0 = theme.bg;
        color1 = theme.red;
        color2 = theme.green;
        color3 = theme.yellow;
        color4 = theme.blue;
        color5 = theme.magenta;
        color6 = theme.cyan;
        color7 = theme.fgAlt;
        color8 = theme.comment;
        color9 = theme.red;
        color10 = theme.green;
        color11 = theme.yellow;
        color12 = theme.blue;
        color13 = theme.magenta;
        color14 = theme.cyan;
        color15 = theme.fg;
        color16 = theme.orange;
        color17 = theme.orange;
      };

      keybindings = {
        "ctrl+c" = "copy_or_interrupt";
        "ctrl+f" =
          "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
        "kitty_mod+f" =
          "launch --location=hsplit --allow-remote-control kitty +kitten search.py @active-kitty-window-id";
        "page_up" = "scroll_page_up";
        "page_down" = "scroll_page_down";
        "ctrl+plus" = "change_font_size all +1";
        "ctrl+equal" = "change_font_size all +1";
        "ctrl+kp_add" = "change_font_size all +1";
        "ctrl+minus" = "change_font_size all -1";
        "ctrl+underscore" = "change_font_size all -1";
        "ctrl+kp_subtract" = "change_font_size all -1";
        "ctrl+0" = "change_font_size all 0";
        "ctrl+kp_0" = "change_font_size all 0";
      };
    };

    xdg.configFile."kitty/search.py".source = ./files/kitty/search.py;
  };
}
