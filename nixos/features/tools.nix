{ inputs, ... }:
{
  flake.homeModules.tools =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        fd
        eza
        procps
        nautilus

        # DEVELOPMENT
        go
        gopls
        nodejs
        bun
        posting
        gh

        inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      programs.nh = {
        enable = true;
        flake = "${config.home.homeDirectory}/.config/nixconf";
      };
    };
}
