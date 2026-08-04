{ ... }:
{
  flake.nixosModules.fish = {
    programs.fish.enable = true;
  };

  flake.homeModules.fish = { ... }: {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        if status is-interactive
            if test -f "$HOME/.local/state/caelestia/sequences.txt"
                cat "$HOME/.local/state/caelestia/sequences.txt"
            end

            fastfetch
        end

        set fish_greeting

        function starship_transient_prompt_func
            starship module character
        end

        set -g fish_transient_prompt 1

        alias clear "printf '\033[2J\033[3J\033[1;1H'"
        alias ls 'eza --icons=auto'

        if test -f "$HOME/.local/state/caelestia/theme/fish-colors.fish"
            source "$HOME/.local/state/caelestia/theme/fish-colors.fish"
        end
      '';
    };
  };
}
