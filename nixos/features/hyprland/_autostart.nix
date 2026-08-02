{ lib, pkgs }:
let
  inline = lib.generators.mkLuaInline;
  toLua = lib.generators.toLua { };
  polkitAgent = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
in
[
  {
    _args = [
      "hyprland.start"
      (inline ''
        function()
          hl.exec_cmd("waybar")
          hl.exec_cmd("awww-daemon")
          hl.exec_cmd(${toLua polkitAgent})
          hl.exec_cmd("dunst")

          hl.exec_cmd(browser)
          hl.exec_cmd("vesktop")
          hl.exec_cmd("AyuGram")
          hl.exec_cmd("zeditor")
          hl.exec_cmd("steam")
        end
      '')
    ];
  }
]
