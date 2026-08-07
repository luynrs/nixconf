{ ... }:
{
  flake.homeModules.librewolf = { ... }: {
    home.sessionVariables.MOZ_ENABLE_WAYLAND = "1";

    programs.librewolf = {
      enable = true;

      policies.ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "normal_installed";
        };
        "sponsorBlocker@ajay.app" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
          installation_mode = "normal_installed";
        };
      };
    };
  };
}
