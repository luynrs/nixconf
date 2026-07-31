{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];

      perSystem =
        { pkgs, ... }:
        {
          formatter = pkgs.nixfmt;
        };

      imports = [
        inputs.flake-parts.flakeModules.modules
        ./modules/core/theme.nix
        ./modules/core/desktop.nix
        ./modules/core/hosts/luynar.nix
        ./modules/features/hyprland.nix
        ./modules/features/fish.nix
        ./modules/features/starship.nix
        ./modules/features/kitty.nix
        ./modules/features/waybar.nix
        ./modules/features/rofi.nix
        ./modules/features/dunst.nix
        ./modules/features/packages.nix
        ./modules/features/fastfetch.nix
        ./modules/features/zed.nix
        ./modules/features/v2raya.nix
      ];
    };
}
