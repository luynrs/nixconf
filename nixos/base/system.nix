{ inputs, ... }:
{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      ...
    }:
    {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 1;
      boot.kernelParams = [
        "quiet"
        "splash"
      ];

      boot.plymouth = {
        enable = true;
        theme = "bgrt";
      };

      networking.hostName = lib.mkDefault "luynar";
      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Moscow";
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

      zramSwap.enable = true;

      services.gvfs.enable = true;
      services.upower.enable = true;
      services.speechd.enable = false;

      users.users.luynar = {
        isNormalUser = true;
        description = "luynar";
        initialPassword = "justloginme";
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
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd start-hyprland";
          user = "greeter";
        };
      };

      fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        jetbrains-mono
        inter
        noto-fonts
        noto-fonts-color-emoji
      ];

      fonts.fontconfig = {
        defaultFonts = {
          sansSerif = [
            "Inter"
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
