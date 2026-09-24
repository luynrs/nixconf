{ inputs, ... }:
{
  flake.homeModules.tools =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        fd
        eza
        nautilus

        # DEVELOPMENT
        go
        gopls
        nodejs
        bun
        posting
        gh
        jujutsu

        inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/.config/nixconf";
      };
    };
}
