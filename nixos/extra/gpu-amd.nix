{
  flake.nixosModules.gpuAmd =
    { pkgs, ... }:
    {
      boot.kernelParams = [ "amdgpu.reset_method=4" ];

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr
          rocmPackages.clr.icd
        ];
      };

      hardware.amdgpu.overdrive.enable = true;
      services.lact.enable = true;
    };
}
