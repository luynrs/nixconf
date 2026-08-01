{ ... }:
{
  flake.modules.homeManager.zed = { pkgs, ... }: {
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
