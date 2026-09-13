_: {
  flake.nixosModules.scheduler =
    { pkgs, ... }:
    {
      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
        package = pkgs.scx.rustscheds;
      };
    };
}
