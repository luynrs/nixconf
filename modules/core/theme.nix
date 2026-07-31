{ lib, ... }:
{
  options.theme = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Theme palette — single source of truth for all components";
  };

  config.theme = {
    bg = "#1e1e2e";
    bgDark = "#181825";
    fg = "#cdd6f4";
    fgAlt = "#bac2de";
    comment = "#585b70";
    accent = "#b4befe";
    red = "#f38ba8";
    green = "#a6e3a1";
    yellow = "#f9e2af";
    blue = "#89b4fa";
    magenta = "#cba6f7";
    cyan = "#94e2d5";
    orange = "#fab387";
    selection = "#313244";
    borderActive1 = "#b4befe";
    borderActive2 = "#cba6f7";
    borderInactive = "#45475a";
  };
}
