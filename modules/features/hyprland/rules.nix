{
  env = map (vars: { _args = vars; }) [
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

  layer_rule = [
    {
      match.namespace = "waybar";
      blur = true;
    }
    {
      match.namespace = "rofi";
      blur = true;
    }
  ];

  # Pin apps to their workspace by class, so windows don't scatter
  # regardless of how the process forks/launches (e.g. vesktop, steam games).
  window_rule = [
    {
      match.class = "^google-chrome$";
      workspace = "1 silent";
      no_initial_focus = true;
    }
    {
      match.class = "^vesktop$";
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
      match.class = "^dev\\.zed\\.Zed$";
      workspace = "3 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^steam$";
      workspace = "10 silent";
      no_initial_focus = true;
      focus_on_activate = false;
    }
    {
      match.class = "^steam_app_.*$";
      workspace = "4 silent";
    }
    # Float all dialogs/popups: modal windows, portal file pickers,
    # and GNOME image/video viewers should pop up over the tiling layout.
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
      match.class = "^(org\\.gnome\\.Loupe|org\\.gnome\\.Showtime)$";
      float = true;
      center = true;
    }
  ];
}
