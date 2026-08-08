{ ... }:
{
  flake.nixosModules.base =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      user = config.preferences.user;
    in
    {

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.timeout = 1;
      boot.kernelParams = [
        "quiet"
        "splash"
      ];

      # bgrt shows the motherboard's own UEFI boot logo (from the firmware's
      # ACPI BGRT table) with a spinner underneath — the "like Windows" look.
      # No themePackages needed: bgrt ships built into plymouth itself.
      boot.plymouth = {
        enable = true;
        theme = "bgrt";
      };

      networking.hostName = lib.mkDefault user.name;
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
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      nixpkgs.config.allowUnfree = true;

      zramSwap.enable = true;

      security.polkit.enable = true;

      services.gvfs.enable = true;

      users.users.${user.name} = {
        isNormalUser = true;
        description = user.description;
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

      system.stateVersion = "26.05";
    };
}
