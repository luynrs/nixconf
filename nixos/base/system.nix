{ ... }:
{
  flake.nixosModules.base =
    { config, pkgs, ... }:
    let
      user = config.preferences.user;
    in
    {

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 1;
      boot.kernelParams = [ "systemd.show_status=false" ];

      networking.hostName = user.name;
      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Moscow";
      i18n.defaultLocale = "en_US.UTF-8";
      console.keyMap = builtins.head config.preferences.keymap.layouts;

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [
          "https://cache.nixos.org"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      nixpkgs.config.allowUnfree = true;

      zramSwap.enable = true;

      security.polkit.enable = true;

      services.gvfs.enable = true;
      services.speechd.enable = false;

      users.users.${user.name} = {
        isNormalUser = true;
        description = user.description;
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
        noto-fonts
        noto-fonts-color-emoji
      ];

      fonts.fontconfig = {
        defaultFonts = {
          sansSerif = [ "Noto Sans" ];
          serif = [ "Noto Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" ];
          emoji = [ "Noto Color Emoji" ];
        };
        hinting = {
          enable = true;
          style = "full";
        };
        antialias = true;
        subpixel = {
          rgba = "rgb";
          lcdfilter = "light";
        };
      };

      environment.systemPackages = with pkgs; [
        polkit_gnome
      ];

      system.stateVersion = "26.05";
    };
}
