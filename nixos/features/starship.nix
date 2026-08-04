{ lib, ... }:
{
  flake.homeModules.starship =
    { config, ... }:
    {
      programs.starship.enable = true;

      # The whole prompt config is rendered by caelestia on every scheme change.
      home.sessionVariables.STARSHIP_CONFIG = lib.mkForce "${config.home.homeDirectory}/.local/state/caelestia/theme/starship.toml";
    };
}
