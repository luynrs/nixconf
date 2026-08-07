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

      (pkgs.writeShellScriptBin "claude" ''
        export HTTP_PROXY="http://127.0.0.1:20171"
        export HTTPS_PROXY="http://127.0.0.1:20171"
        export ALL_PROXY="socks5://127.0.0.1:20170"
        export NO_PROXY="localhost,127.0.0.1,::1"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      '')
    ];

    programs.nh = {
      enable = true;
      flake = "${config.home.homeDirectory}/nixconf";
    };
  };
}
