{ ... }:
{
  flake.nixosModules.gpu = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
