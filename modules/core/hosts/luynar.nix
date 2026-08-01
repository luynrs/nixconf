{ self, inputs, ... }:
{
  flake.nixosConfigurations.luynar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ../../../hardware-configuration.nix

      self.modules.nixos.desktop
      self.modules.nixos.hyprland
      self.modules.nixos.fish
      self.modules.nixos.v2raya

      inputs.home-manager.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-bak";

        home-manager.users.luynar.imports = [
          inputs.catppuccin.homeModules.catppuccin
          self.modules.homeManager.hyprland
          self.modules.homeManager.waybar
          self.modules.homeManager.kitty
          self.modules.homeManager.fish
          self.modules.homeManager.starship
          self.modules.homeManager.rofi
          self.modules.homeManager.packages
          self.modules.homeManager.appearance
          self.modules.homeManager.xdg
          self.modules.homeManager.dunst
          self.modules.homeManager.fastfetch
          self.modules.homeManager.zed
          (
            { lib, ... }:
            {
              home.username = "luynar";
              home.homeDirectory = "/home/luynar";
              home.stateVersion = "26.05";

              home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
                mkdir -p "$HOME/Pictures/Wallpapers"
                cp -n ${../../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
              '';

              catppuccin = {
                enable = true;
                autoEnable = true;
                flavor = "mocha";
                accent = "lavender";
                cursors.enable = false; # keep the Bibata cursor theme instead
                dunst.enable = false; # dunstrc is already themed via theme.nix
              };
            }
          )
        ];
      }
    ];
  };
}
