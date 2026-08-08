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

  flake.nixosModules.laptop =
    { config, ... }:
    {
      networking.hostName = "laptop";

      imports = [
        self.nixosModules.base
        self.nixosModules.hyprland
        self.nixosModules.fish
        self.nixosModules.gpuNvidia
        self.nixosModules.gaming
        self.nixosModules.bluetooth

        inputs.home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";

          home-manager.users.${config.preferences.user.name} = {
            imports = [ self.homeModules.general ];
          };
        }
      ];

      preferences = {
        user = {
          name = "luynar";
          description = "luynar";
        };

        keymap = {
          layouts = [
            "us"
            "ru"
          ];
          options = "grp:alt_shift_toggle";
        };

        monitors."eDP-1" = {
          width = 1920;
          height = 1080;
          refreshRate = 144;
        };
      };
    };
}
