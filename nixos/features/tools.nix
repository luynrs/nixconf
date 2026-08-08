{ inputs, ... }:
{
  flake.homeModules.tools = { pkgs, config, ... }: {
    home.packages = with pkgs; [
      gh
      wget
      eza
      nodejs
      bun
      procps
      ruff
      brightnessctl
      playerctl
      nautilus

      inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconf";
    };
  };
}
