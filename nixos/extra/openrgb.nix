{ ... }:
let
  rgb = "7C3AED";
in
{
  flake.nixosModules.openrgb =
    { pkgs, ... }:
    let
      applyMainboard = ''
        ${pkgs.openrgb}/bin/openrgb --device "B650" --mode static --color ${rgb} 2>/dev/null || true
      '';

      applyDramOff = ''
        OPENRGB=${pkgs.openrgb}/bin/openrgb
        while read -r line; do
          if [[ "$line" =~ ^([0-9]+):\ ENE\ DRAM ]]; then
            "$OPENRGB" --device "''${BASH_REMATCH[1]}" --mode off 2>/dev/null || true
          fi
        done < <("$OPENRGB" --list-devices 2>/dev/null)
      '';
    in
    {
      services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
      };

      boot.kernelParams = [ "acpi_enforce_resources=lax" ];

      systemd.services.openrgb-static-color = {
        description = "Static purple mainboard, RAM off";
        after = [ "openrgb.service" ];
        wants = [ "openrgb.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 1;
          StartLimitIntervalSec = 60;
          StartLimitBurst = 30;
          StandardOutput = "null";
          StandardError = "null";
        };
        script = ''
          ${pkgs.openrgb}/bin/openrgb --list-devices 2>&1 | grep -q "Connected to server" || true
          ${applyMainboard}
          ${applyDramOff}
        '';
      };

      systemd.services.openrgb-resume = {
        description = "Re-apply mainboard RGB after resume";
        after = [
          "openrgb.service"
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        wants = [ "openrgb.service" ];
        wantedBy = [
          "suspend.target"
          "hibernate.target"
          "hybrid-sleep.target"
        ];
        serviceConfig = {
          Type = "oneshot";
          StandardOutput = "null";
          StandardError = "null";
        };
        script = applyMainboard;
      };
    };
}
