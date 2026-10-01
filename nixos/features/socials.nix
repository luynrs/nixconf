{
  flake.homeModules.socials =
    { pkgs, ... }:
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
    };
}
