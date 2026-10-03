{ inputs, ... }:
{
  flake.homeModules.work =
    { pkgs, ... }:
    {
      home = {
        packages = [ pkgs.antigravity-cli ];

        file = {
          "instructions" = {
            source = ./work/instructions;
            recursive = true;
            force = true;
          };

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

      xdg.configFile."instructions" = {
        source = ./work/instructions;
        recursive = true;
        force = true;
      };

      xdg.configFile."zed/AGENTS.md" = {
        source = ./work/AGENTS.md;
        force = true;
      };

      programs.codex = {
        enable = true;
        package = pkgs.symlinkJoin {
          name = "codex";
          paths = [ inputs.codex-cli.packages.${pkgs.stdenv.hostPlatform.system}.default ];
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

          agent = {
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

      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/plain" = "dev.zed.Zed.desktop";
          "text/markdown" = "dev.zed.Zed.desktop";
          "text/x-nix" = "dev.zed.Zed.desktop";
          "text/x-shellscript" = "dev.zed.Zed.desktop";
          "text/x-python" = "dev.zed.Zed.desktop";
          "text/x-rust" = "dev.zed.Zed.desktop";
          "text/x-csrc" = "dev.zed.Zed.desktop";
          "text/x-c++src" = "dev.zed.Zed.desktop";
          "text/x-go" = "dev.zed.Zed.desktop";
          "application/json" = "dev.zed.Zed.desktop";
          "application/toml" = "dev.zed.Zed.desktop";
          "application/x-yaml" = "dev.zed.Zed.desktop";
        };
      };
    };
}
