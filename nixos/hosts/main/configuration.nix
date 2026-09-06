{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.luynar = inputs.nixpkgs.lib.nixosSystem {
    modules = [ self.nixosModules.main ];
  };

  flake.nixosModules.main = {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.hyprland
      self.nixosModules.fish
      self.nixosModules.openrgb
      self.nixosModules.gpuAmd
      self.nixosModules.gaming
      self.nixosModules.bluetooth
    ];

    preferences = {
      disko.dualboot = true;

      monitors."DP-1" = {
        width = 1920;
        height = 1080;
        refreshRate = 165;
      };
    };
  };
}
