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
        "/var/lib/NetworkManager"
        "/var/lib/OpenRGB"
        "/var/lib/justray"
        {
          directory = "/var/cache/tuigreet";
          user = "greeter";
          group = "greeter";
          mode = "0755";
        }
        "/etc/NetworkManager/system-connections"
        "/etc/lact"
      ];

      files = [
        "/etc/machine-id"
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

          ".config/nixconf"

          # Ключи и авторизация
          ".ssh"
          ".gnupg"
          ".pki"
          ".local/share/pki"
          ".local/share/keyrings"

          # Shell и окружение
          ".local/share/fish"
          ".local/share/zoxide"
          ".local/share/direnv"
          ".local/share/nix"
          ".local/state/nix"
          ".local/state/home-manager"

          # Браузер и мессенджеры
          ".config/chromium"
          ".config/equibop"
          ".local/share/AyuGramDesktop"
          ".local/share/TelegramDesktop"

          # VPN и Justray
          ".config/justray"
          ".local/share/justray"

          # Разработка и AI (Zed, GitHub, Gemini/Antigravity)
          ".local/share/zed"
          ".config/zed"
          ".config/gh"
          ".config/justssh"
          ".gemini"
          ".codex"

          # Языки и тулчейны (Go, TS/JS, C/C++)
          "go"
          ".cache/go-build"
          ".cache/gopls"
          ".cache/golangci-lint"
          ".cache/goimports"
          ".npm"
          ".cache/yarn"
          ".cache/pnpm"
          ".cache/clangd"
          ".cache/ccache"

          # Игры
          ".local/share/Steam"
          ".steam"

          # Системное состояние, рабочий стол и звук
          ".config/dconf"
          ".config/pulse"
          ".config/hypr/scheme"
          ".local/share/applications"
          ".local/share/gvfs-metadata"
          ".local/state/caelestia"
          ".local/state/wireplumber"
          ".cache/cliphist"
        ];

        files = [
          ".config/gtk-3.0/bookmarks"
        ];
      };
    };

    security.sudo.extraConfig = "Defaults lecture = never";
    systemd.tmpfiles.rules = [ "d /persist/home/luynar 0700 luynar users -" ];
  };
}
