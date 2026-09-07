{ inputs, ... }:
{
  flake.homeModules.work =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.antigravity-cli ];

      home.file.".gemini/config/rules/AGENTS.md".source = ./work/AGENTS.md;
      home.file.".gemini/config/skills/commit/SKILL.md".source = ./work/command-commit.md;
      home.file.".gemini/config/plugins/ponytail".source = inputs.ponytail;
      home.file.".gemini/config/mcp_config.json".source = ./work/mcp_config.json;

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
            default_width = 260;
          };

          assistant = {
            button = true;
            dock = "right";
            default_width = 260;
            flexible = false;
          };

          git_panel = {
            button = true;
            dock = "right";
            default_width = 260;
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
