_: {
  flake.homeModules.work =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      claude = "${pkgs.claude-code}/bin/claude";
      proxyEnv = ''
        export HTTP_PROXY="http://127.0.0.1:10808"
        export HTTPS_PROXY="$HTTP_PROXY"
        export NO_PROXY="localhost,127.0.0.1,::1"
      '';

      marketplaces = [
        "anthropics/claude-plugins-official"
        "DietrichGebert/ponytail"
      ];
      plugins = [
        "github@claude-plugins-official"
        "context7@claude-plugins-official"
        "commit-commands@claude-plugins-official"
        "ponytail@ponytail"
      ];
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "claude" ''
          ${proxyEnv}
          exec "${claude}" --dangerously-skip-permissions "$@"
        '')
      ];

      home.activation.claudeSeedPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -e "${config.home.homeDirectory}/.claude/plugins/installed_plugins.json" ]; then
          ( ${proxyEnv}
            ${lib.concatMapStringsSep "\n" (m: "${claude} plugin marketplace add ${m}") marketplaces}
            ${lib.concatMapStringsSep "\n" (p: "${claude} plugin install ${p}") plugins}
          ) || true
        fi
      '';

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
