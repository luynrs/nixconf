{ config, lib, ... }:
let
  theme = config.theme;
  c = color: lib.removePrefix "#" color;
in
{
  flake.modules.nixos.fish = {
    programs.fish.enable = true;
  };

  flake.modules.homeManager.fish = { ... }: {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        if status is-interactive
            fastfetch
        end

        set fish_greeting

        function starship_transient_prompt_func
            starship module character
        end

        enable_transience

        alias clear "printf '\033[2J\033[3J\033[1;1H'"
        alias ls 'eza --icons=auto'

        set -l foreground ${c theme.fg} normal
        set -l selection ${c theme.selection} brcyan
        set -l comment ${c theme.comment} brblack
        set -l red ${c theme.red} red
        set -l orange ${c theme.orange} brred
        set -l yellow ${c theme.yellow} yellow
        set -l green ${c theme.green} green
        set -l purple ${c theme.magenta} magenta
        set -l cyan ${c theme.cyan} cyan
        set -l pink ${c theme.magenta} brmagenta

        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
      '';
    };
  };
}
