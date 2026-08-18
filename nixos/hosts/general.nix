{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.general = {
    imports = [ inputs.home-manager.nixosModules.default ];

    programs.gpu-screen-recorder.enable = true;

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.luynar.imports = [ self.homeModules.general ];
    };
  };

  flake.homeModules.general =
    { lib, ... }:
    {
      imports = [
        self.homeModules.hyprland
        self.homeModules.caelestia
        self.homeModules.ghostty
        self.homeModules.fish
        self.homeModules.starship
        self.homeModules.tools
        self.homeModules.work
        self.homeModules.firefox
        self.homeModules.media
        self.homeModules.socials
        self.homeModules.btop
        self.homeModules.appearance
        self.homeModules.fastfetch
        self.homeModules.nvim
        inputs.justray.homeManagerModules.justray
      ];

      services.justray.enable = true;

      home.stateVersion = "26.05";

      home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/Pictures/Wallpapers"
        cp -n --no-preserve=mode ${../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
      '';
    };
}
