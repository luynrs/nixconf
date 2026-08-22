{ inputs, ... }:
{
  flake.homeModules.tools = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      gh
      eza
      nodejs
      bun
      procps
      nautilus

      inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconf";
    };
  };
}
