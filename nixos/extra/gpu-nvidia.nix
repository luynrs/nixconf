{ ... }:
{
  flake.nixosModules.gpuNvidia =
    { pkgs, lib, ... }:
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
        package = pkgs.linuxPackages.nvidiaPackages.stable;

        open = true;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };

          intelBusId = lib.mkDefault "PCI:6:0:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };

      boot.kernelParams = [ "nvidia-drm.modeset=1" ];

      environment.sessionVariables = {
        LIBVA_VA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      environment.systemPackages = with pkgs; [
        nvtopPackages.full
      ];
    };
}
