{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.preferences.keymap = lib.mkOption {
        type = lib.types.submodule {
          options = {
            layouts = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ "us" ];
            };
            options = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
          };
        };
        default = { };
      };
    };
}
