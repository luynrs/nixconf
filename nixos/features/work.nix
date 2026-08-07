{ ... }:
{
  flake.homeModules.work = { pkgs, ... }: {
    programs.git = {
      enable = true;
      settings.user = {
        name = "luynrs";
        email = "157303229+luynrs@users.noreply.github.com";
      };
    };

    programs.zed-editor = {
      enable = true;

      extensions = [
        "colored-zed-icons"

        # Languages
        "nix"
        "golang"
        ];

      userSettings = {
        base_keymap = "VSCode";

        icon_theme = "Colored Zed Icons Theme Dark";
        theme = "Caelestia";

      shell = {
         program = "foot";
        };
      };
    };
  };
}
