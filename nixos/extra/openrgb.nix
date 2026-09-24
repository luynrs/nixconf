{
  flake.nixosModules.openrgb =
    { pkgs, ... }:
    {
      services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
      };

      boot.kernelParams = [ "acpi_enforce_resources=lax" ];

      systemd.services.openrgb-static-color = {
        description = "Apply static RGB";
        after = [ "openrgb.service" ];
        wants = [ "openrgb.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        path = [ pkgs.openrgb ];
        script = ''
          openrgb --device "B650" --zone 0 --size 60 --zone 1 --size 60 --mode static --color 7C3AED 2>/dev/null || true
          openrgb --device "ENE DRAM" --mode off 2>/dev/null || true
        '';
      };
    };
}
