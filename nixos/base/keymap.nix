{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.preferences.keymap = lib.mkOption {
        type = lib.types.submodule {
          options = {
            layouts = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                "us"
                "ru"
              ];
            };
            options = lib.mkOption {
              type = lib.types.str;
              default = "grp:alt_shift_toggle";
            };
          };
        };
        default = { };
      };
    };
}
