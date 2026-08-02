{ config, lib, ... }:
let
  rgb = lib.removePrefix "#" config.theme.magenta;
in
{
  flake.modules.nixos.openrgb =
    { pkgs, ... }:
    {
      services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
      };

      boot.kernelParams = [
        "acpi_enforce_resources=lax"
        "systemd.show_status=false"
      ];

      environment.systemPackages = [ pkgs.i2c-tools ];

      systemd.services.openrgb-static-color = {
        description = "Set static purple RGB on mainboard, leave RAM off";
        after = [ "openrgb.service" ];
        wants = [ "openrgb.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          StandardOutput = "null";
          StandardError = "null";
        };
        script = ''
          OPENRGB=${pkgs.openrgb}/bin/openrgb

          until "$OPENRGB" --list-devices 2>&1 | grep -q "Connected to server"; do
            sleep 1
          done

          "$OPENRGB" --device "B650" --zone 0 --size 16 --mode static --color ${rgb}
          "$OPENRGB" --device "B650" --zone 1 --size 16 --mode static --color ${rgb}
          "$OPENRGB" --mode static --color ${rgb}

          while read -r line; do
            if [[ "$line" =~ ^([0-9]+):\ ENE\ DRAM ]]; then
              "$OPENRGB" --device "''${BASH_REMATCH[1]}" --mode off
            fi
          done < <("$OPENRGB" --list-devices 2>/dev/null)
        '';
      };
    };
}
