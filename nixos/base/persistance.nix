{ inputs, ... }:
{
  flake.nixosModules.base =
    { config, lib, ... }:
    {
      imports = [ inputs.impermanence.nixosModules.impermanence ];

      # Only meaningful on a host installed with the tmpfs-root layout from
      # nixos/hosts/main/_disko.nix — /home and /nix are their own permanent
      # partitions there, so only small system-level state needs bind-mounting.
      options.persistance.enable = lib.mkEnableOption "ephemeral tmpfs root with /persist for system state";

      config = lib.mkIf config.persistance.enable {
        environment.persistence."/persist" = {
          hideMounts = true;
          files = [ "/etc/machine-id" ];
          directories = [ "/etc/NetworkManager/system-connections" ];
        };
      };
    };
}
