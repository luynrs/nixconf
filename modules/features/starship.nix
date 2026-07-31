{ config, ... }:
let
  theme = config.theme;
in
{
  flake.modules.homeManager.starship = { ... }: {
    programs.starship = {
      enable = true;

      settings = {
        format = ''
          $directory$git_branch$git_status$nix_shell$cmd_duration
          $character'';

        directory = {
          style = "bold ${theme.blue}";
          format = "[$path]($style) ";
          truncation_length = 3;
          truncate_to_repo = true;
        };

        git_branch = {
          symbol = " ";
          style = "bold ${theme.magenta}";
          format = "on [$symbol$branch]($style) ";
        };

        git_status = {
          style = "bold ${theme.yellow}";
          format = "([$all_status$ahead_behind]($style) )";
        };

        nix_shell = {
          symbol = "❄ ";
          style = "bold ${theme.cyan}";
          format = "via [$symbol$state( \\($name\\))]($style) ";
        };

        cmd_duration = {
          min_time = 2000;
          style = theme.comment;
          format = "took [$duration]($style) ";
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
