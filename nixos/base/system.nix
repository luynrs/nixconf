{ self, ... }:
{
  flake.nixosModules.base =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.disko
        self.nixosModules.impermanence
        self.nixosModules.fish
      ];

      boot = {
        kernelPackages = pkgs.linuxPackages_zen;

        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };

        kernelParams = [
          "quiet"
          "splash"
        ];

        plymouth = {
          enable = true;
          theme = "bgrt";
        };

        kernel.sysctl = {
          "vm.swappiness" = 180;

          "net.core.default_qdisc" = "cake";
          "net.ipv4.tcp_congestion_control" = "bbr";
        };
      };

      networking = {
        networkmanager.enable = true;
        nftables.enable = true;
        firewall.trustedInterfaces = [ "tailscale0" ];
        hosts = {
          "130.255.77.28" = [ "ntc.party" ];
        };
      };

      services = {
        tailscale.enable = true;
        fstrim.enable = true;
        gvfs.enable = true;
        upower.enable = true;
        speechd.enable = false;

        pipewire = {
          enable = true;
          alsa.enable = true;
          pulse.enable = true;
          wireplumber.enable = true;
        };

        greetd = {
          enable = true;
          settings.default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session -u ${config.preferences.username} --cmd start-hyprland";
            user = "greeter";
          };
        };
      };

      time.timeZone = "Europe/Moscow";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = "us";

      nix = {
        package = pkgs.lix;

        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          connect-timeout = 5;
          fallback = true;
          substituters = [
            "https://cache.nixos.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ];
        };

        optimise.automatic = true;
      };

      nixpkgs.config.allowUnfree = true;

      zramSwap = {
        enable = true;
        algorithm = "zstd";
      };
      security.rtkit.enable = true;
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

      users.users.${config.preferences.username} = {
        isNormalUser = true;
        hashedPassword = "$6$Vz0gDiMZEBwLvMEo$Woh4mJnlouv1uCPQotwxyOBGJPRPhCFTI2ijgwiRYezdzizD03xcdDghXtTUF2Rn5Jpek7gFP1vOW4Pi2LO.01";
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "audio"
          "render"
        ];
        shell = pkgs.fish;
      };

      fonts.packages = with pkgs; [
        inter
        nerd-fonts.jetbrains-mono
        noto-fonts-color-emoji
      ];

      fonts.fontconfig.defaultFonts = {
        sansSerif = [ "Inter" ];
        serif = [ "Inter" ];
        monospace = [ "JetBrainsMono Nerd Font" ];
        emoji = [ "Noto Color Emoji" ];
      };

      system.stateVersion = "26.05";
    };
}
