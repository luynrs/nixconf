{ inputs, ... }:
{
  flake.homeModules.tools = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      eza
      procps
      nautilus

      # DEVELOPMENT
      nodejs
      bun
      posting
      gh

      inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconf";
    };
  };
}
