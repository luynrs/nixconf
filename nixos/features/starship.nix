{ config, ... }:
let
  theme = config.theme;
in
{
  flake.homeModules.starship = { ... }: {
    programs.starship = {
      enable = true;

      settings = {
        add_newline = false;

        format = ''
          $directory$git_branch$git_status$nix_shell$cmd_duration
          $character
        '';

        directory = {
          style = "bold ${theme.blue}";
          format = "[$path]($style) ";
          truncation_length = 3;
          truncate_to_repo = true;
          home_symbol = "~";
          read_only = " ";
          read_only_style = "bold ${theme.red}";
        };

        git_branch = {
          symbol = " ";
          style = "bold ${theme.magenta}";
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          style = "bold ${theme.yellow}";
          format = "([$all_status$ahead_behind]($style) )";

          conflicted = "=";
          ahead = "⇡";
          behind = "⇣";
          diverged = "⇕";
          untracked = "?";
          stashed = "*";
          modified = "!";
          staged = "+";
          renamed = "»";
          deleted = "✕";
        };

        nix_shell = {
          symbol = " ";
          style = "bold ${theme.cyan}";
          format = "[$symbol$name]($style) ";

          impure_msg = "";
          pure_msg = "";
        };

        cmd_duration = {
          min_time = 2000;
          style = theme.comment;
          format = "[$duration]($style) ";
        };

        character = {
          success_symbol = "[❯](bold ${theme.green})";
          error_symbol = "[❯](bold ${theme.red})";
          vimcmd_symbol = "[❮](bold ${theme.accent})";
        };
      };
    };
  };
}
