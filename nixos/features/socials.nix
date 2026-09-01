{
  flake.homeModules.socials =
    { pkgs, lib, ... }:
    {
      home.packages = [
        pkgs.ayugram-desktop
        (pkgs.equibop.overrideAttrs (old: {
          postFixup = old.postFixup + ''
            wrapProgram $out/bin/equibop \
              --add-flags "--ozone-platform-hint=wayland --disable-xcb"
          '';
        }))
      ];

      home.activation.seedEquibopPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ${pkgs.jq}/bin/jq \
          '.plugins.FakeNitro.enabled = true |
           .plugins.VolumeBooster.enabled = true |
           .plugins.PlatformIndicators.enabled = true' \
          "$HOME/.config/equibop/settings/settings.json" \
        > "$HOME/.config/equibop/settings/settings.json.tmp" \
        && mv "$HOME/.config/equibop/settings/settings.json.tmp" \
           "$HOME/.config/equibop/settings/settings.json"
      '';
    };
}
