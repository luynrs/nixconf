{ inputs, ... }:
{
  flake.homeModules.work =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.antigravity-cli ];

        file = {
          ".codex/AGENTS.md".force = true;

          ".gemini/config/rules/AGENTS.md" = {
            source = ./work/AGENTS.md;
            force = true;
          };

          ".gemini/config/skills/commit/SKILL.md" = {
            source = ./work/command-commit.md;
            force = true;
          };

          ".gemini/config/plugins/ponytail" = {
            source = inputs.ponytail;
            force = true;
          };

          ".gemini/config/mcp_config.json" = {
            source = ./work/mcp_config.json;
            force = true;
          };
        };
      };

      xdg.configFile."zed/AGENTS.md" = {
        source = ./work/AGENTS.md;
        force = true;
      };

      programs.codex = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "codex-${pkgs.codex.version}";
          paths = [ pkgs.codex ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/codex --set HTTPS_PROXY socks5h://127.0.0.1:10808
          '';
        };
        context = ./work/AGENTS.md;
        skills = {
          commit = ./work/command-commit.md;
          ponytail = inputs.ponytail + "/skills/ponytail";
          ponytail-review = inputs.ponytail + "/skills/ponytail-review";
          ponytail-audit = inputs.ponytail + "/skills/ponytail-audit";
          ponytail-debt = inputs.ponytail + "/skills/ponytail-debt";
          ponytail-gain = inputs.ponytail + "/skills/ponytail-gain";
          ponytail-help = inputs.ponytail + "/skills/ponytail-help";
        };
      };

      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "luynrs";
            email = "157303229+luynrs@users.noreply.github.com";
            signingkey = "~/.ssh/id_ed25519.pub";
          };
          commit.gpgsign = true;
          tag.gpgsign = true;
          gpg.format = "ssh";
          credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
        };
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
            dock = "left";
            default_width = 260;
          };

          assistant = {
            dock = "right";
            default_width = 260;
            flexible = false;
          };

          git_panel = {
            dock = "right";
            default_width = 260;
          };

          outline_panel.button = false;
          collaboration_panel.button = false;
        };
      };
    };
}
