{ ... }:
{
  flake.nixosModules.v2raya = { pkgs, ... }: {
    services.v2raya = {
      enable = true;
      cliPackage = pkgs.xray;
    };
  };
}
