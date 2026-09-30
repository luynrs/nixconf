{
  flake.homeModules.browser =
    { pkgs, ... }:
    {
      programs.chromium = {
        enable = true;
        package = pkgs.chromium.override {
          enableWideVine = true;
        };
        commandLineArgs = [
          "--ozone-platform-hint=auto"
          "--enable-features=VaapiVideoDecodeLinuxGL,VaapiVideoEncoder,CanvasOopRasterization"
          "--enable-zero-copy"
          "--ignore-gpu-blocklist"
          "--enable-gpu-rasterization"
        ];
        extensions = [
          # uBlock Origin Lite
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; }
        ];
      };
    };
}
