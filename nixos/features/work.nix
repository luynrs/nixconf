_: {
  flake.homeModules.work =
    { pkgs, ... }:
    let
      claude = "${pkgs.claude-code}/bin/claude";
      proxyEnv = ''
        export HTTP_PROXY="http://127.0.0.1:1081"
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

        (pkgs.writeShellScriptBin "claude-seed-plugins" ''
          set -eu
          ${proxyEnv}
          ${pkgs.lib.concatMapStringsSep "\n" (m: "${claude} plugin marketplace add ${m}") marketplaces}
          ${pkgs.lib.concatMapStringsSep "\n" (p: "${claude} plugin install ${p}") plugins}
        '')
      ];

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
