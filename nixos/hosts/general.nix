{
  inputs,
  self,
  ...
}:
{
  flake.homeModules.general =
    { lib, ... }:
    {
      imports = [
        self.homeModules.hyprland
        self.homeModules.caelestia
        self.homeModules.foot
        self.homeModules.fish
        self.homeModules.starship
        self.homeModules.tools
        self.homeModules.work
        self.homeModules.chromium
        self.homeModules.media
        self.homeModules.socials
        self.homeModules.btop
        self.homeModules.appearance
        self.homeModules.fastfetch
        self.homeModules.nvim
        inputs.justxray.homeManagerModules.justxray
      ];

      services.justxray.enable = true;

      home.stateVersion = "26.05";

      home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/Pictures/Wallpapers"
        cp -n ${../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
      '';
    };
}
