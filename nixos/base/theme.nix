{ inputs, lib, ... }:
let
  mocha =
    (builtins.fromJSON (
      builtins.readFile "${inputs.catppuccin.packages.x86_64-linux.palette}/palette.json"
    )).mocha.colors;
  hex = name: mocha.${name}.hex;
in
{
  options.theme = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
    description = "Theme palette — single source of truth for all components";
  };

  config.theme = {
    bgDark = hex "mantle";
    fg = hex "text";
    comment = hex "surface2";
    accent = hex "lavender";
    red = hex "red";
    green = hex "green";
    yellow = hex "yellow";
    blue = hex "blue";
    magenta = hex "mauve";
    cyan = hex "teal";
    orange = hex "peach";
    selection = hex "surface0";
    borderActive1 = hex "lavender";
    borderActive2 = hex "mauve";
    borderInactive = hex "surface1";
  };
}
