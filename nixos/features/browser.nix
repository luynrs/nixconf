{ inputs, lib, ... }:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    "extensions.autoDisableScopes" = 0;
    "extensions.pocket.enabled" = false;
  };
in
{
  flake.homeModules.zen =
    { pkgs, ... }:
    {
      home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

      home.packages = [
        (pkgs.wrapFirefox
          inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser-unwrapped
          {
            extraPrefs = lib.concatLines (
              lib.mapAttrsToList (
                name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
              ) prefs
            );

            extraPolicies = {
              DisableTelemetry = true;
              ExtensionSettings = builtins.listToAttrs [
                (extension "ublock-origin" "uBlock0@raymondhill.net")
                (extension "sponsorblock" "sponsorBlocker@ajay.app")
              ];
            };
          }
        )
      ];
    };
}
