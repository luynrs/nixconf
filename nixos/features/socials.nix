{ ... }:
{
  flake.homeModules.socials = { pkgs, ... }: {
    home.packages = [ pkgs.ayugram-desktop ];

    programs.vesktop.enable = true;
  };
}
