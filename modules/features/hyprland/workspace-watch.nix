{ pkgs }:
# Signals waybar's custom/wsN modules on workspace change (Waybar#5008 workaround).
pkgs.writeShellScriptBin "hypr-workspace-watch" ''
  socket="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
  ${pkgs.socat}/bin/socat -U - "UNIX-CONNECT:$socket" | while IFS= read -r line; do
    case "$line" in
      workspace*|createworkspace*|destroyworkspace*|moveworkspace*)
        ${pkgs.procps}/bin/pkill -RTMIN+8 waybar
        ;;
    esac
  done
''
