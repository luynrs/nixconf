{ ... }:
{
  flake.homeModules.socials = { pkgs, ... }: {
    home.packages = [
      pkgs.ayugram-desktop
      (pkgs.discord.override { withVencord = true; })
    ];
  };
}
