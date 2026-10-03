{
  flake.homeModules.socials =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.ayugram-desktop
        (pkgs.discord.override {
          withVencord = true;
          withOpenASAR = true;
        })
      ];

      xdg.configFile = {
        "discord/discord_asset_cache/openh264/libopenh264-2.5.1-linux64.7.so" = {
          source = "${pkgs.openh264}/lib/libopenh264.so.7";
          force = true;
        };
        "discord/discord_asset_cache/openh264/libopenh264-2.6.0-linux64.7.so" = {
          source = "${pkgs.openh264}/lib/libopenh264.so.7";
          force = true;
        };
      };
    };
}
