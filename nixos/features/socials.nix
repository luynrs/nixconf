{
  flake.homeModules.socials =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.ayugram-desktop ];

      programs.vesktop = {
        enable = true;

        settings.hardwareVideoAcceleration = true;
        vencord.settings.plugins.FakeNitro.enabled = true;
        vencord.settings.plugins.VolumeBooster.enabled = true;
        vencord.settings.plugins.PlatformIndicators.enabled = true;
      };
    };
}
