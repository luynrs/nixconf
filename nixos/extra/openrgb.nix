{ lib, ... }:
let
  rgb = lib.removePrefix "#" "7C3AED";
in
{
  flake.nixosModules.openrgb =
    { pkgs, ... }:
    {
      services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
      };

      boot.kernelParams = [ "acpi_enforce_resources=lax" ];

      environment.systemPackages = [ pkgs.i2c-tools ];

      systemd.services.openrgb-static-color = {
        description = "Static purple mainboard, RAM off";
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

          attempts=0
          until "$OPENRGB" --list-devices 2>&1 | grep -q "Connected to server"; do
            attempts=$((attempts + 1))
            [ "$attempts" -ge 30 ] && break
            sleep 1
          done

          "$OPENRGB" --device "B650" --mode static --color ${rgb}

          while read -r line; do
            if [[ "$line" =~ ^([0-9]+):\ ENE\ DRAM ]]; then
              "$OPENRGB" --device "''${BASH_REMATCH[1]}" --mode static --color 000000
            fi
          done < <("$OPENRGB" --list-devices 2>/dev/null)
        '';
      };
    };
}
