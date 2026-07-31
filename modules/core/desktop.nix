{ ... }:
{
  flake.modules.nixos.desktop = { pkgs, ... }: {

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "luynar";
    networking.networkmanager.enable = true;

    time.timeZone = "Europe/Moscow";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nixpkgs.config.allowUnfree = true;

    programs.steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    security.polkit.enable = true;

    services.gvfs.enable = true;
    services.speechd.enable = false;

    users.users.luynar = {
      isNormalUser = true;
      description = "luynar";
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
