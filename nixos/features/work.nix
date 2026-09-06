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
        settings.credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
      };

      programs.zed-editor = {
        enable = true;

        extensions = [
          "nix"
          "golang"
          "colored-zed-icons-theme"
        ];

        userSettings = {
          base_keymap = "VSCode";

          theme = {
            mode = "system";
            light = "Caelestia";
            dark = "Caelestia";
          };

          icon_theme = {
            mode = "system";
            light = "Colored Zed Icons Theme Light";
            dark = "Colored Zed Icons Theme Dark";
          };

          project_panel = {
            button = true;
            dock = "left";
            default_width = 250;
          };

          agent = {
            button = true;
            dock = "left";
            default_width = 250;
            flexible = false;
          };

          git_panel = {
            button = true;
            dock = "right";
            default_width = 250;
          };

          outline_panel = {
            button = false;
          };

          collaboration_panel = {
            button = false;
          };
        };
      };
    };
}
