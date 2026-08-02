{ ... }:
{
  flake.modules.nixos.v2raya = { pkgs, ... }: {
    services.v2raya = {
      enable = true;
      cliPackage = pkgs.xray;
    };
  };
}
