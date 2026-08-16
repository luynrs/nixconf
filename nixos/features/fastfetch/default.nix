_: {
  flake.homeModules.fastfetch = { pkgs, ... }: {
    home.packages = [ pkgs.fastfetch ];

    xdg.configFile."fastfetch/config.jsonc".source = ./config.jsonc;
    xdg.configFile."fastfetch/nixos.png".source = ./nixos.png;
  };
}
