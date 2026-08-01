{ inputs, ... }:
{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      git
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
      google-chrome
      loupe
      showtime
      mpv

      inputs.justssh.packages.${pkgs.system}.default

      ayugram-desktop

      (pkgs.writeShellScriptBin "claude" ''
        export HTTP_PROXY="http://127.0.0.1:20171"
        export HTTPS_PROXY="http://127.0.0.1:20171"
        export ALL_PROXY="socks5://127.0.0.1:20170"
        export NO_PROXY="localhost,127.0.0.1,::1"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      '')
    ];

    programs.btop.enable = true;

    programs.nh = {
      enable = true;
      flake = "/home/luynar/nix-config";
    };

    programs.vesktop.enable = true;
  };
}
