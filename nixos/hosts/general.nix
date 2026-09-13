{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.general = _: {
    imports = [
      inputs.home-manager.nixosModules.default
      inputs.justray.nixosModules.default
      self.nixosModules.browser
      self.nixosModules.scheduler
    ];

    programs.gpu-screen-recorder.enable = true;
    programs.justray.enable = true;

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
        inputs.justray.homeManagerModules.default
        self.homeModules.hyprland
        self.homeModules.caelestia
        self.homeModules.foot
        self.homeModules.fish
        self.homeModules.starship
        self.homeModules.tools
        self.homeModules.work
        self.homeModules.browser
        self.homeModules.media
        self.homeModules.socials
        self.homeModules.btop
        self.homeModules.appearance
        self.homeModules.fastfetch
        self.homeModules.nvim
      ];

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
      };

      services.justray.enable = true;

      home.stateVersion = "26.05";

      home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/Pictures/Wallpapers"
        cp -n --no-preserve=mode ${../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
      '';
    };
}
