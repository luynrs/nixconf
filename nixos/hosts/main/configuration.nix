{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.luynar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [ self.nixosModules.main ];
  };

  flake.nixosModules.main =
    { config, ... }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.hyprland
        self.nixosModules.fish
        self.nixosModules.openrgb
        self.nixosModules.gpuAmd
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

        monitors."DP-1" = {
          width = 1920;
          height = 1080;
          refreshRate = 165;
        };
      };
    };
}
