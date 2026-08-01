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

      inputs.justssh.packages.${pkgs.stdenv.hostPlatform.system}.default

      ayugram-desktop

      (pkgs.writeShellScriptBin "claude" ''
        export HTTP_PROXY="http://127.0.0.1:20171"
        export HTTPS_PROXY="http://127.0.0.1:20171"
        export ALL_PROXY="socks5://127.0.0.1:20170"
        export NO_PROXY="localhost,127.0.0.1,::1"
        exec "${pkgs.claude-code}/bin/claude" "$@"
      '')
    ];

    programs.btop = {
      enable = true;
      package = pkgs.writeShellScriptBin "btop" ''
        export LD_LIBRARY_PATH="${pkgs.rocmPackages.rocm-smi}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
        exec "${pkgs.btop}/bin/btop" "$@"
      '';
    };

    programs.nh = {
      enable = true;
      flake = "/home/luynar/nix-config";
    };

    programs.vesktop.enable = true;
  };
}
