{ ... }:
{
  flake.homeModules.chromium =
    { ... }:
    {
      programs.chromium = {
        enable = true;
        commandLineArgs = [
          "--ozone-platform=wayland"
          "--font-render-hinting=full"
        ];
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
          "mnbndgmknlpdjntjjkklckcocgohadmo" # SponsorBlock
        ];
      };
    };
}
