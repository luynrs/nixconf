_: {
  flake.nixosModules.gaming =
    { pkgs, ... }:
    {
      programs = {
        gamemode.enable = true;
        steam = {
          enable = true;
          extraCompatPackages = [ pkgs.proton-ge-bin ];
        };
      };

      environment.systemPackages = with pkgs; [
        mangohud
        protontricks
      ];
    };
}
