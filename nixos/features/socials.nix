{
  flake.homeModules.socials =
    { pkgs, lib, ... }:
    {
      home.packages = [
        pkgs.ayugram-desktop
        (pkgs.discord.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];

      home.activation.seedVencordPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/.config/Vencord/settings"
        if [ ! -f "$HOME/.config/Vencord/settings/settings.json" ]; then
          echo '{}' > "$HOME/.config/Vencord/settings/settings.json"
        fi
        ${pkgs.jq}/bin/jq \
          '.plugins.FakeNitro.enabled = true |
           .plugins.VolumeBooster.enabled = true |
           .plugins.PlatformIndicators.enabled = true' \
          "$HOME/.config/Vencord/settings/settings.json" \
        > "$HOME/.config/Vencord/settings/settings.json.tmp" \
        && mv "$HOME/.config/Vencord/settings/settings.json.tmp" \
           "$HOME/.config/Vencord/settings/settings.json"
      '';
    };
}
