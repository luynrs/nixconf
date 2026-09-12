{ pkgs }:
{
  env = map (vars: { _args = vars; }) [
    [
      "CAELESTIA_XKB_RULES_PATH"
      "${pkgs.xkeyboard_config}/share/X11/xkb/rules/base.lst"
    ]
    [
      "XCURSOR_SIZE"
      "24"
    ]
    [
      "XCURSOR_THEME"
      "Bibata-Modern-Classic"
    ]
    [
      "HYPRCURSOR_SIZE"
      "24"
    ]
    [
      "HYPRCURSOR_THEME"
      "Bibata-Modern-Classic"
    ]
    [
      "ELECTRON_OZONE_PLATFORM_HINT"
      "auto"
    ]
  ];

  window_rule = [
    {
      match.class = "^(chromium-browser|Chromium-browser|chromium)$";
      workspace = "1 silent";
      no_initial_focus = true;
    }
    {
      match.class = "^equibop$";
      workspace = "2 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^com\\.ayugram\\.desktop$";
      workspace = "2 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^com\\.ayugram\\.desktop$";
      match.title = "^Media viewer$";
      float = true;
      center = true;
      no_initial_focus = false;
    }
    {
      match.class = "^dev\\.zed\\.Zed$";
      workspace = "3 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^steam$";
      workspace = "5 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^steam_app_.*$";
      workspace = "4 silent";
    }
    {
      match.modal = true;
      float = true;
      center = true;
    }
    {
      match.initial_class = "^(xdg-desktop-portal.*)$";
      float = true;
      center = true;
    }
    {
      match.class = "^(imv|mpv)$";
      float = true;
      center = true;
    }
    {
      match.title = "^Select what to share$";
      float = true;
      center = true;
    }
  ];
}
