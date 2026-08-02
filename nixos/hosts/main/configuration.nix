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

        inputs.home-manager.nixosModules.default
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "hm-bak";

          home-manager.users.${config.preferences.user.name}.imports = [
            inputs.catppuccin.homeModules.catppuccin
            self.homeModules.hyprland
            self.homeModules.waybar
            self.homeModules.foot
            self.homeModules.fish
            self.homeModules.starship
            self.homeModules.rofi
            self.homeModules.tools
            self.homeModules.work
            self.homeModules.chrome
            self.homeModules.media
            self.homeModules.socials
            self.homeModules.btop
            self.homeModules.appearance
            self.homeModules.dunst
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
                  dunst.enable = false; # dunstrc is already themed via theme.nix

                  # components without manual theming in theme.nix
                  foot.enable = true;
                  btop.enable = true;
                  vesktop.enable = true;
                  zed.enable = true;
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
