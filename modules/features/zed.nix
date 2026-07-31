{ ... }:
{
  flake.modules.homeManager.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;

      extraPackages = [
        pkgs.nixd
        pkgs.nil
        pkgs.ruff
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
