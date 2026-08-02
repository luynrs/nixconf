{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    justssh.url = "github:luynrs/justssh";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];
        imports = [
          inputs.flake-parts.flakeModules.modules
          inputs.treefmt-nix.flakeModule
          ./modules/core/theme.nix
          ./modules/core/desktop.nix
          ./modules/core/hosts/luynar.nix
          ./modules/features/hyprland/default.nix
          ./modules/features/fish.nix
          ./modules/features/starship.nix
          ./modules/features/foot/default.nix
          ./modules/features/waybar/default.nix
          ./modules/features/rofi/default.nix
          ./modules/features/dunst/default.nix
          ./modules/features/packages.nix
          ./modules/features/appearance.nix
          ./modules/features/xdg.nix
          ./modules/features/fastfetch/default.nix
          ./modules/features/zed.nix
          ./modules/features/nvim/default.nix
          ./modules/features/v2raya.nix
          ./modules/features/openrgb.nix
          ./modules/features/gpu.nix
        ];
        perSystem = {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.nixfmt.enable = true;
            settings.global.excludes = [ "hardware-configuration.nix" ];
          };
        };
      }
    );
}
