{ ... }:
{
  flake.homeModules.chromium =
    { ... }:
    {
      programs.chromium = {
        enable = true;
        commandLineArgs = [ "--ozone-platform=wayland" ];
        extensions = [
          "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
          "mnbndgmknlpdjntjjkklckcocgohadmo" # SponsorBlock
        ];
      };
    };
}
