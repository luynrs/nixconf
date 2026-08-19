{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.general =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.default ];

      programs.gpu-screen-recorder.enable = true;

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.luynar.imports = [ self.homeModules.general ];
      };

      systemd.services.justrayd = {
        description = "justray background daemon";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          User = "luynar";
          ExecStart = "${inputs.justray.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/justrayd --config-dir /home/luynar/.config/justray";
          AmbientCapabilities = [ "CAP_NET_ADMIN" ];
          Restart = "on-failure";
          RestartSec = 2;
        };
      };
    };

  flake.homeModules.general =
    { lib, pkgs, ... }:
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
      ];

      home.packages = [ inputs.justray.packages.${pkgs.stdenv.hostPlatform.system}.default ];

      home.stateVersion = "26.05";

      home.activation.seedWallpapers = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "$HOME/Pictures/Wallpapers"
        cp -n --no-preserve=mode ${../../Wallpapers}/* "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
      '';
    };
}
