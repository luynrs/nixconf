{ config, lib, ... }:
let
  theme = config.theme;
  accent = color: "<span color=\"${color}\">";
in
{
  flake.homeModules.waybar = { ... }: {
    programs.waybar = {
      enable = true;

      settings.mainBar = {
        position = "top";
        height = 40;

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "group/time" ];
        modules-right = [
          "privacy"
          "hyprland/language"
          "group/zvuk"
          "group/hardware"
          "tray"
          "network"
        ];

        "hyprland/workspaces" = {
          format = "{id}";
          on-click = "hyprctl dispatch workspace {id}";
          persistent-workspaces."*" = lib.range 1 10;
        };

        "hyprland/window" = {
          format = "{initialTitle}";
          max-length = 35;
          rewrite = {
            "" = "Hyprland";
            "foot" = "Terminal";
            ".*Discord.*" = "Discord";
          };
          separate-outputs = false;
        };

        "hyprland/language" = {
          format = "${accent theme.accent}</span>  {}";
          format-en = "EN";
          format-ru = "RU";
        };

        "group/hardware" = {
          orientation = "horizontal";
          modules = [
            "cpu"
            "memory"
          ];
        };
        cpu = {
          format = "${accent theme.accent}</span>  {usage}%";
          tooltip = false;
        };
        memory.format = "${accent theme.accent}</span>  {percentage}%";

        "group/zvuk" = {
          orientation = "horizontal";
          modules = [
            "pulseaudio#output"
            "pulseaudio#input"
          ];
        };
        "pulseaudio#output" = {
          format = "${accent theme.accent}{icon}</span> {volume}%";
          format-muted = "${accent theme.red}󰕾</span> {volume}%";
          format-icons = {
            headphone = "";
            default = "󰕾";
          };
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
        };
        "pulseaudio#input" = {
          format = "{format_source}";
          format-source = "${accent theme.accent}</span> {volume}%";
          format-source-muted = "${accent theme.red}</span> {volume}%";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          on-scroll-up = "wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SOURCE@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
        };

        "group/time" = {
          modules = [
            "clock"
            "clock#simple"
          ];
          orientation = "horizontal";
        };
        "clock#simple" = {
          format = "{:%H:%M:%S}";
          tooltip = false;
          interval = 1;
        };
        clock = {
          format = "{:L%a %d, %b %Y}";
          format-alt = "{:%d-%m-%Y}";
          tooltip = false;
        };

        privacy = {
          icon-size = 15;
          icon-spacing = 8;
        };
        network = {
          format-wifi = "${accent theme.accent} </span>";
          format-ethernet = "${accent theme.accent} </span>";
          format-disconnected = "${accent theme.accent}⚠</span>";
          tooltip = false;
        };
        tray.spacing = 10;
      };

      style =
        lib.replaceStrings
          [
            "__BACKGROUND__"
            "__FOREGROUND__"
            "__FOREGROUND_ALT__"
            "__ACCENT__"
            "__RED__"
            "__ORANGE__"
            "__SELECTION__"
            "__MUTED__"
          ]
          [
            theme.bg
            theme.fg
            theme.fgAlt
            theme.accent
            theme.red
            theme.orange
            theme.selection
            theme.comment
          ]
          (builtins.readFile ./style.css);
    };
  };
}
