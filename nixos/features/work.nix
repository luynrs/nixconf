_: {
  flake.homeModules.work =
    { pkgs, ... }:
    {
      xdg.configFile."zed/AGENTS.md".source = ./work/AGENTS.md;

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
            commit_message_instructions = ''
              Review the currently staged changes (`git diff --cached`) and create a single git commit for them. Follow these rules:
              - Use the Conventional Commits format: `type(scope): summary`
              - Keep the summary under 72 characters, imperative mood, no trailing period
              - Add a short body only if the "why" is not obvious from the diff
              - Never commit secrets, credentials, or unrelated files
              - Do not push after committing
            '';
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

          agent_servers = {
            codex = { };
            antigravity-acp = { };
          };

          context_servers = {
            context7 = {
              url = "https://mcp.context7.com/mcp";
            };
          };
        };
      };

      systemd.user.services.antigravity-acp = {
        Unit = {
          Description = "Antigravity ACP Warm Daemon";
          After = [ "default.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.nodejs}/bin/node %h/.local/share/zed/external_agents/registry/antigravity-acp/v_1.1.1_c5752c93158aa0bc_eef079d17742fe39/daemon/daemon.js";
          Restart = "always";
          RestartSec = 2;
          Environment = [
            "NIX_LD=/run/current-system/sw/share/nix-ld/lib/ld.so"
            "NIX_LD_LIBRARY_PATH=/run/current-system/sw/share/nix-ld/lib"
            "SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
            "NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-bundle.crt"
          ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
