{
  flake.homeModules.apps =
    { lib, ... }:
    {
      options.preferences.defaultApps = {
        terminal = lib.mkOption {
          type = lib.types.str;
          default = "foot";
        };
        explorer = lib.mkOption {
          type = lib.types.str;
          default = "nautilus";
        };
        browser = lib.mkOption {
          type = lib.types.str;
          default = "chromium";
        };
        playback = lib.mkOption {
          type = lib.types.str;
          default = "mpv";
        };
      };
    };
}
