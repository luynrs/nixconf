{ inputs, ... }:
{
  flake.nixosModules.disko =
    { lib, config, ... }:
    let
      rootFilesystem = {
        type = "btrfs";
        extraArgs = [ "-f" ];
        subvolumes =
          lib.mapAttrs
            (_: mountpoint: {
              inherit mountpoint;
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            })
            {
              "@nix" = "/nix";
              "@persist" = "/persist";
              "@log" = "/var/log";
            };
      };
      bootFilesystem = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
        mountOptions = [ "umask=0077" ];
      };
    in
    {
      imports = [ inputs.disko.nixosModules.disko ];

      options.preferences.disko.dualboot = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Use dualboot partitions (p5/p6) instead of wiping the whole disk";
      };

      config = {
        disko.devices = {
          disk =
            if config.preferences.disko.dualboot then
              {
                boot = {
                  type = "disk";
                  device = "/dev/nvme0n1p5";
                  content = bootFilesystem // {
                    extraArgs = [
                      "-F"
                      "32"
                    ];
                  };
                };
                root = {
                  type = "disk";
                  device = "/dev/nvme0n1p6";
                  content = rootFilesystem;
                };
              }
            else
              {
                main = {
                  type = "disk";
                  device = "/dev/nvme0n1";
                  content = {
                    type = "gpt";
                    partitions = {
                      ESP = {
                        size = "1G";
                        type = "EF00";
                        content = bootFilesystem;
                      };
                      root = {
                        size = "100%";
                        content = rootFilesystem;
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
