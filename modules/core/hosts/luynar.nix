{ config, inputs, ... }:
{
  flake.nixosConfigurations.luynar = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      ../../../hardware-configuration.nix

      config.flake.modules.nixos.desktop
      config.flake.modules.nixos.hyprland
      config.flake.modules.nixos.fish
      config.flake.modules.nixos.v2raya
      config.flake.modules.nixos.openrgb

      inputs.home-manager.nixosModules.default
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "hm-bak";

        home-manager.users.luynar.imports = [
          inputs.catppuccin.homeModules.catppuccin
          config.flake.modules.homeManager.hyprland
          config.flake.modules.homeManager.waybar
          config.flake.modules.homeManager.foot
          config.flake.modules.homeManager.fish
          config.flake.modules.homeManager.starship
          config.flake.modules.homeManager.rofi
          config.flake.modules.homeManager.packages
          config.flake.modules.homeManager.appearance
          config.flake.modules.homeManager.xdg
          config.flake.modules.homeManager.dunst
          config.flake.modules.homeManager.fastfetch
          config.flake.modules.homeManager.zed
          config.flake.modules.homeManager.nvim
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
