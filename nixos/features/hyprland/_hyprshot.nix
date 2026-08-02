{
  lib,
  pkgs,
  theme,
}:
let
  # Vendored hyprshot, patched for a styled slurp selection.
  hyprshotScript = pkgs.writeText "hyprshot" (
    lib.replaceStrings
      [ "__BORDER__" "__BG__" ]
      [
        (lib.removePrefix "#" theme.accent)
        (lib.removePrefix "#" theme.bgDark)
      ]
      (builtins.readFile ./hyprshot)
  );
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "hyprshot";
  version = "1.3.0-luynar";
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  installPhase = ''
    install -Dm755 ${hyprshotScript} $out/bin/hyprshot
    wrapProgram $out/bin/hyprshot --prefix PATH : ${
      lib.makeBinPath (
        with pkgs;
        [
          hyprland
          jq
          grim
          slurp
          wl-clipboard
          libnotify
          hyprpicker
        ]
      )
    }
  '';
}
