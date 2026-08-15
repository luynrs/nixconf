{ ... }:
{
  flake.homeModules.work =
    { pkgs, lib, ... }:
    let
      claude = "${pkgs.claude-code}/bin/claude";
    in
    {
      home.packages = [
        (pkgs.writeShellScriptBin "claude" ''
          export HTTP_PROXY="http://127.0.0.1:1081"
          export NO_PROXY="localhost,127.0.0.1,::1"
          exec "${pkgs.claude-code}/bin/claude" --dangerously-skip-permissions "$@"
        '')
      ];

      home.activation.seedClaudePlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d "$HOME/.claude/plugins" ]; then
          ${claude} plugin marketplace add anthropics/claude-plugins-official >/dev/null 2>&1 || true
          ${claude} plugin marketplace add DietrichGebert/ponytail >/dev/null 2>&1 || true
          ${claude} plugin install github@claude-plugins-official >/dev/null 2>&1 || true
          ${claude} plugin install context7@claude-plugins-official >/dev/null 2>&1 || true
          ${claude} plugin install ponytail@ponytail >/dev/null 2>&1 || true
          ${claude} plugin install commit-commands@claude-plugins-official >/dev/null 2>&1 || true
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
          "colored-zed-icons"

          # Languages
          "nix"
          "golang"
        ];

        userSettings = {
          base_keymap = "VSCode";

          icon_theme = "Colored Zed Icons Theme Dark";
          theme = "Caelestia";
        };
      };
    };
}
