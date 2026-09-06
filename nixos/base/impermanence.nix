{ inputs, ... }:
{
  flake.nixosModules.impermanence = {
    imports = [ inputs.impermanence.nixosModules.impermanence ];

    environment.persistence."/persist" = {
      hideMounts = true;

      directories = [
        "/var/lib/nixos"
        "/var/lib/systemd"
        "/var/lib/bluetooth"
        "/etc/NetworkManager/system-connections"
        "/var/lib/justray"
      ];

      files = [
        "/etc/machine-id"
        "/etc/adjtime"
      ];

      users.luynar = {
        directories = [
          # Пользовательские файлы и проекты
          "Downloads"
          "Documents"
          "Pictures"
          "Projects"
          "Videos"
          "Music"

          # Ключи и авторизация
          ".ssh"
          ".gnupg"
          ".local/share/keyrings"

          # Shell и окружение
          ".local/share/fish"
          ".local/share/zoxide"
          ".local/share/direnv"
          ".local/share/nix"

          # Браузер и мессенджеры
          ".mozilla"
          ".config/equibop"
          ".local/share/AyuGramDesktop"
          ".local/share/TelegramDesktop"

          # VPN и Justray
          ".config/justray"
          ".local/share/justray"

          # Разработка и AI (Opencode, Zed, GitHub)
          ".local/share/opencode"
          ".config/opencode"
          ".local/share/zed"
          ".config/zed"
          ".config/gh"
          ".config/antigravity"
          ".config/justssh"

          # Игры
          ".local/share/Steam"
          ".steam"

          # Caelestia и звук
          ".local/state/caelestia"
          ".local/state/wireplumber"
        ];
      };
    };

    security.sudo.extraConfig = "Defaults lecture = never";
    systemd.tmpfiles.rules = [ "d /persist/home/luynar 0700 luynar users -" ];
  };
}
