{ ... }:
{
  flake.modules.homeManager.packages = { pkgs, ... }: {
    home.packages = with pkgs; [
      git
      gh
      wget
      eza
      nodejs
      procps
      ruff
      brightnessctl
      playerctl
      nautilus
      pavucontrol
      google-chrome
      loupe
      showtime
      mpv

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
