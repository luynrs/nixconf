{
  flake.homeModules.socials =
    { pkgs, lib, ... }:
    let
      discordOpenH264 = pkgs.openh264.overrideAttrs {
        version = "2.5.1";
        src = pkgs.fetchFromGitHub {
          owner = "cisco";
          repo = "openh264";
          tag = "2.5.1";
          hash = "sha256-UN6cs9XUBgOyzbn2OCQZaLgfg7EfhasIawBAgiNck8M=";
        };
        patches = [ ];
      };
    in
    {
      home.packages = [
        pkgs.ayugram-desktop
        (pkgs.discord.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];

      xdg.configFile."discord/discord_asset_cache/openh264/libopenh264-2.5.1-linux64.7.so" = {
        source = "${discordOpenH264}/lib/libopenh264.so.7";
        force = true;
      };

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
