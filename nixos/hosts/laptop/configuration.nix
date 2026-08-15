{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.laptop = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [ self.nixosModules.laptop ];
  };

  flake.nixosModules.laptop = {
    networking.hostName = "laptop";

    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.hyprland
      self.nixosModules.fish
      self.nixosModules.gpuNvidia
      self.nixosModules.gaming
      self.nixosModules.bluetooth
    ];

    preferences = {
      user = {
        name = "luynar";
        description = "luynar";
      };

      monitors."eDP-1" = {
        width = 1920;
        height = 1080;
        refreshRate = 144;
      };
    };
  };
}
