{ inputs, self, ... }:
{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.disko
        self.nixosModules.impermanence
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 0;
      boot.kernelParams = [
        "quiet"
        "splash"
      ];

      boot.plymouth = {
        enable = true;
        theme = "bgrt";
      };

      boot.kernelModules = [
        "tcp_bbr"
        "sch_cake"
      ];

      boot.kernel.sysctl = {
        "vm.swappiness" = 180;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;

        "net.core.default_qdisc" = "cake";
        "net.ipv4.tcp_congestion_control" = "bbr";
      };

      networking.hostName = lib.mkDefault "luynar";
      networking.networkmanager.enable = true;
      networking.nftables.enable = true;

      time.timeZone = "Europe/Moscow";
      time.hardwareClockInLocalTime = lib.mkDefault true;
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "us";

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };
      nix.optimise.automatic = true;

      nixpkgs.config.allowUnfree = true;

      nixpkgs.overlays = [ inputs.nur.overlays.default ];

      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };
      security.rtkit.enable = true;
      services.fstrim.enable = true;

      programs.nix-ld = {
        enable = true;
        libraries = with pkgs; [
          stdenv.cc.cc.lib
          zlib
          openssl
          curl
          glib
        ];
      };

      services.gvfs.enable = true;
      services.upower.enable = true;
      services.speechd.enable = false;

      users.users.luynar = {
        isNormalUser = true;
        hashedPassword = "$6$Vz0gDiMZEBwLvMEo$Woh4mJnlouv1uCPQotwxyOBGJPRPhCFTI2ijgwiRYezdzizD03xcdDghXtTUF2Rn5Jpek7gFP1vOW4Pi2LO.01";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
        ];
        shell = pkgs.fish;
      };

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session -u luynar --cmd start-hyprland";
          user = "greeter";
        };
      };

      fonts.packages = with pkgs; [
        geist-font
        nerd-fonts.jetbrains-mono
        jetbrains-mono
        noto-fonts
        noto-fonts-color-emoji
      ];

      fonts.fontconfig = {
        defaultFonts = {
          sansSerif = [
            "Geist"
            "Noto Sans"
          ];
          serif = [ "Noto Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = true;
          style = "slight";
        };
        antialias = true;
        subpixel = {
          rgba = "rgb";
          lcdfilter = "default";
        };
      };

      system.stateVersion = "26.05";
    };
}
