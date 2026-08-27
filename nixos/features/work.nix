_: {
  flake.homeModules.work =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "opencode" ''
          if [ $# -eq 0 ]; then
            exec "${pkgs.opencode}/bin/opencode" --auto
          else
            exec "${pkgs.opencode}/bin/opencode" "$@"
          fi
        '')
      ];

      xdg.configFile."opencode/opencode.json".source = ./work/opencode.json;
      xdg.configFile."opencode/AGENTS.md".source = ./work/opencode-agents.md;
      xdg.configFile."opencode/tui.json".source = ./work/tui.json;
      xdg.configFile."opencode/command/commit.md".source = ./work/command-commit.md;

      programs.git = {
        enable = true;
        settings.user = {
          name = "luynrs";
          email = "157303229+luynrs@users.noreply.github.com";
        };
      };

      programs.zed-editor = {
        enable = true;

        extensions = [
          "nix"
          "golang"
        ];

        userSettings = {
          base_keymap = "VSCode";

          theme = "Caelestia";
        };
      };
    };
}
