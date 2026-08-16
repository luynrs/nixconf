_: {
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

        nvidiaSettings = true;
        package = pkgs.linuxPackages.nvidiaPackages.stable;
        open = true;
        prime = {
          sync.enable = true;
          amdgpuBusId = lib.mkDefault "PCI:6:0:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };

      environment.sessionVariables = {
        LIBVA_VA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
}
