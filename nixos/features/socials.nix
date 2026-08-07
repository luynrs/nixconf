{
  flake.homeModules.socials =
    { pkgs, lib, ... }:
    {
      home.packages = [
        pkgs.ayugram-desktop
        (pkgs.discord.override { withVencord = true; })
      ];

      # Seed Vencord settings on first run only: FakeNitro on by default.
      # The file stays user-owned afterwards, so Vencord can keep writing it.
      home.activation.seedVencord = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                if [ ! -f "$HOME/.config/Vencord/settings/settings.json" ]; then
                  mkdir -p "$HOME/.config/Vencord/settings"
                  cat > "$HOME/.config/Vencord/settings/settings.json" <<'EOF'
        {
          "plugins": {
            "FakeNitro": { "enabled": true }
          }
        }
        EOF
                fi
      '';
    };
}
