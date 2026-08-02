{
  flake.nixosModules.base =
    { lib, ... }:
    {
      options.preferences.user = lib.mkOption {
        type = lib.types.submodule {
          options.name = lib.mkOption {
            type = lib.types.str;
          };
          options.description = lib.mkOption {
            type = lib.types.str;
            default = "";
          };
        };
      };
    };
}
