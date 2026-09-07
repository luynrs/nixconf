_: {
  flake.nixosModules.fish = {
    programs.fish.enable = true;
  };

  flake.homeModules.fish = { ... }: {
    programs.fish = {
      enable = true;

      shellAliases = {
        clear = "printf '\\033[2J\\033[3J\\033[1;1H'";
        ls = "eza --icons=auto";
        zeditor = "zed";
      };

      functions = {
        fd = ''
          if test (count $argv) -eq 0
              echo "Usage: fd <pattern>"
              return 1
          end
          plocate -0 $argv | xargs -0 -r eza -d --icons=auto
        '';
      };
      interactiveShellInit = ''
        if test -f "$HOME/.local/state/caelestia/sequences.txt"
            cat "$HOME/.local/state/caelestia/sequences.txt"
        end

        fastfetch

        set fish_greeting

        function starship_transient_prompt_func
            starship module character
        end

        set -g fish_transient_prompt 1

        if test -f "$HOME/.local/state/caelestia/theme/fish-colors.fish"
            source "$HOME/.local/state/caelestia/theme/fish-colors.fish"
        end
      '';
    };
  };
}
