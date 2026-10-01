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
          hl.exec_cmd(${toLua polkitAgent})
          hl.exec_cmd("wl-paste --watch cliphist -max-items 25 store")

          hl.exec_cmd(browser)
          hl.exec_cmd("discord")
          hl.exec_cmd("AyuGram")
          hl.exec_cmd("zeditor")
          hl.exec_cmd("steam")
        end
      '')
    ];
  }
  {
    _args = [
      "window.active"
      (inline ''
        function(win)
          if win and win.class == "foot" then
            hl.exec_cmd("hyprctl switchxkblayout all 0")
          end
        end
      '')
    ];
  }
]
