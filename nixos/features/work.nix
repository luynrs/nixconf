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

      extraPackages = [
        pkgs.go
        pkgs.gopls
        pkgs.nixd
        pkgs.nil
      ];

      userSettings = {
        lsp = {
          nix.binary.path_lookup = true;
          ruff.binary.path_lookup = true;
        };
      };
    };
  };
}
