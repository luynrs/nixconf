{ ... }:
{
  flake.modules.nixos.gpu = {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
