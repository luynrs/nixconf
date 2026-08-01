{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    justssh.url = "github:luynrs/justssh";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      {
        systems = [ "x86_64-linux" ];
        processedFlake = removeAttrs config.flake [ "modules" ];

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.writeShellScriptBin "nix-fmt" ''
              if [ "$#" -eq 0 ]; then
                files=$(${pkgs.git}/bin/git ls-files '*.nix' | ${pkgs.findutils}/bin/xargs -r -I{} sh -c '[ -f "$1" ] && echo "$1"' sh {})
                files=$(printf '%s\n' "$files" | ${pkgs.ripgrep}/bin/rg -v '^hardware-configuration.nix$' || true)
                ${pkgs.nixfmt}/bin/nixfmt $files
              else
                ${pkgs.nixfmt}/bin/nixfmt "$@"
              fi
            '';
          };

        imports = [
          inputs.flake-parts.flakeModules.modules
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
      }
    );
}
