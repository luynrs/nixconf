{ lib, ... }:
{
  flake.homeModules.starship =
    { config, ... }:
    {
      programs.starship.enable = true;

      home.sessionVariables.STARSHIP_CONFIG = lib.mkForce "${config.home.homeDirectory}/.local/state/caelestia/theme/starship.toml";
    };
}
