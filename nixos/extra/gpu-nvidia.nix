{
  flake.nixosModules.gpuNvidia =
    { config, ... }:
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      hardware.nvidia = {
        modesetting.enable = true;

        powerManagement.enable = true;
        powerManagement.finegrained = true;

        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
        open = true;
        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
        };
      };
    };
}
