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
        nvidiaSettings = true;
        package = pkgs.linuxPackages.nvidiaPackages.stable;

        # ponytail: open kernel module needs Turing (RTX 20xx) or newer.
        # Flip to false if this laptop's GPU predates that.
        open = true;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          # ponytail: bus IDs are physical, unknowable without the real
          # hardware. Run `lspci | grep -E "VGA|3D"` after install and fix.
          intelBusId = lib.mkDefault "PCI:0:2:0";
          nvidiaBusId = lib.mkDefault "PCI:1:0:0";
        };
      };

      boot.kernelParams = [ "nvidia-drm.modeset=1" ];

      # Wayland/Hyprland needs to be told to render through the nvidia driver.
      environment.sessionVariables = {
        LIBVA_VA_DRIVER_NAME = "nvidia";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
}
