{ ... }:
{
  flake.modules.homeManager.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;

      # path_lookup: NixOS can't run Zed's auto-downloaded LSP binaries (no FHS linker).
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
