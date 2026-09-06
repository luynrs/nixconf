{ inputs, ... }:
{
  flake.nixosModules.disko =
    { lib, config, ... }:
    let
      cfg = config.preferences.disko;
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      options.preferences.disko = {
        dualboot = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Use dualboot partitions (p5/p6) instead of wiping the whole disk";
        };
      };

      config = {
        disko.devices =
          if cfg.dualboot then {
            disk = {
              boot = {
                type = "disk";
                device = "/dev/nvme0n1p5";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                  mountOptions = [ "umask=0077" ];
                };
              };
              root = {
                type = "disk";
                device = "/dev/nvme0n1p6";
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" ];
                  subvolumes = {
                    "@nix" = {
                      mountpoint = "/nix";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@persist" = {
                      mountpoint = "/persist";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                    "@log" = {
                      mountpoint = "/var/log";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
                  };
                };
              };
            };
            nodev."/" = {
              fsType = "tmpfs";
              mountOptions = [
                "defaults"
                "size=4G"
                "mode=755"
              ];
            };
          } else {
            disk.main = {
              type = "disk";
              device = "/dev/nvme0n1";
              content = {
                type = "gpt";
                partitions = {
                  ESP = {
                    size = "1G";
                    type = "EF00";
                    content = {
                      type = "filesystem";
                      format = "vfat";
                      mountpoint = "/boot";
                      mountOptions = [ "umask=0077" ];
                    };
                  };
                  root = {
                    size = "100%";
                    content = {
                      type = "btrfs";
                      extraArgs = [ "-f" ];
                      subvolumes = {
                        "@nix" = {
                          mountpoint = "/nix";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "@persist" = {
                          mountpoint = "/persist";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                        "@log" = {
                          mountpoint = "/var/log";
                          mountOptions = [
                            "compress=zstd"
                            "noatime"
                          ];
                        };
                      };
                    };
                  };
                };
              };
            };
            nodev."/" = {
              fsType = "tmpfs";
              mountOptions = [
                "defaults"
                "size=4G"
                "mode=755"
              ];
            };
          };

        fileSystems."/persist".neededForBoot = true;
        fileSystems."/var/log".neededForBoot = true;
      };
    };
}
