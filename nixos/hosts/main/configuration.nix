{
  inputs,
  self,
  ...
}:
{
  flake.nixosConfigurations.luynar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [ self.nixosModules.hostMain ];
  };

  flake.nixosModules.hostMain =
    { config, ... }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.hyprland
        self.nixosModules.fish
        self.nixosModules.v2raya
        self.nixosModules.openrgb
        self.nixosModules.gpu
        self.nixosModules.gaming
        self.nixosModules.bluetooth

        inputs.home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";

          home-manager.users.${config.preferences.user.name}.imports = [
            inputs.catppuccin.homeModules.catppuccin
            self.homeModules.hyprland
            self.homeModules.caelestia
            self.homeModules.foot
            self.homeModules.fish
            self.homeModules.starship
            self.homeModules.tools
            self.homeModules.work
            self.homeModules.chrome
            self.homeModules.media
            self.homeModules.socials
            self.homeModules.btop
            self.homeModules.appearance
            self.homeModules.fastfetch
            self.homeModules.nvim
            (
              { lib, ... }:
              {
                home.username = config.preferences.user.name;
                home.homeDirectory = "/home/${config.preferences.user.name}";
                home.stateVersion = "26.05";

                home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                  mkdir -p "$HOME/Pictures/Wallpapers"
                  cp -n ${../../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
                '';

                catppuccin = {
                  enable = true;
                  autoEnable = false; # manual theming via theme.nix is the single source of truth
                  flavor = "mocha";
                  accent = "lavender";
                  cursors.enable = false; # keep the Bibata cursor theme instead

                  foot.enable = true;
                };
              }
            )
          ];
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
          primary = true;
          width = 1920;
          height = 1080;
          refreshRate = 165;
        };

        autostart = [ ];
      };
    };
}
