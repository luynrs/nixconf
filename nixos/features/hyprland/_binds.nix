{ lib }:
let
  inline = lib.generators.mkLuaInline;
in
[
  {
    _args = [
      (inline ''mainMod .. " + RETURN"'')
      (inline "hl.dsp.exec_cmd(terminal)")
      { description = "Terminal"; }
    ];
  }
  {
    _args = [
      "CTRL + SHIFT + Escape"
      (inline ''hl.dsp.exec_cmd(terminal .. " btop")'')
      { description = "Process monitor"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + Q"'')
      (inline "hl.dsp.window.close()")
      { description = "Close window"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + E"'')
      (inline "hl.dsp.exec_cmd(fileManager)")
      { description = "File manager"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + W"'')
      (inline "hl.dsp.exec_cmd(browser)")
      { description = "Browser"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + SHIFT + W"'')
      (inline ''hl.dsp.global("caelestia:launcher")'')
      { description = "Wallpaper switcher (launcher, type >wallpaper)"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + SHIFT + Q"'')
      (inline ''hl.dsp.global("caelestia:session")'')
      { description = "Power menu"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + V"'')
      (inline ''hl.dsp.window.float({ action = "toggle" })'')
      { description = "Toggle floating"; }
    ];
  }
  {
    _args = [
      "SUPER + D"
      (inline ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'')
      { description = "Window: Maximize"; }
    ];
  }
  {
    _args = [
      "SUPER + F"
      (inline ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'')
      { description = "Window: Fullscreen"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + S"'')
      (inline ''hl.dsp.global("caelestia:launcher")'')
      { description = "App launcher"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + P"'')
      (inline "hl.dsp.window.pseudo()")
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + J"'')
      (inline ''hl.dsp.layout("togglesplit")'')
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + SHIFT + C"'')
      (inline "hl.dsp.exec_cmd(picker)")
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + SHIFT + S"'')
      (inline ''hl.dsp.exec_cmd("hyprshot -m region --clipboard-only --freeze")'')
      { description = "Screenshot: area"; }
    ];
  }
  {
    _args = [
      "PRINT"
      (inline ''hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only")'')
      { description = "Screenshot: full screen"; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + left"'')
      (inline ''hl.dsp.focus({ direction = "l" })'')
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + right"'')
      (inline ''hl.dsp.focus({ direction = "r" })'')
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + up"'')
      (inline ''hl.dsp.focus({ direction = "u" })'')
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + down"'')
      (inline ''hl.dsp.focus({ direction = "d" })'')
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + mouse:272"'')
      (inline "hl.dsp.window.drag()")
      { mouse = true; }
    ];
  }
  {
    _args = [
      (inline ''mainMod .. " + mouse:273"'')
      (inline "hl.dsp.window.resize()")
      { mouse = true; }
    ];
  }
  {
    _args = [
      "XF86AudioRaiseVolume"
      (inline ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86AudioLowerVolume"
      (inline ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86AudioMute"
      (inline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86AudioMicMute"
      (inline ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86MonBrightnessUp"
      (inline ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86MonBrightnessDown"
      (inline ''hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-")'')
      {
        locked = true;
        repeating = true;
      }
    ];
  }
  {
    _args = [
      "XF86AudioNext"
      (inline ''hl.dsp.exec_cmd("playerctl next")'')
      { locked = true; }
    ];
  }
  {
    _args = [
      "XF86AudioPause"
      (inline ''hl.dsp.exec_cmd("playerctl play-pause")'')
      { locked = true; }
    ];
  }
  {
    _args = [
      "XF86AudioPlay"
      (inline ''hl.dsp.exec_cmd("playerctl play-pause")'')
      { locked = true; }
    ];
  }
  {
    _args = [
      "XF86AudioPrev"
      (inline ''hl.dsp.exec_cmd("playerctl previous")'')
      { locked = true; }
    ];
  }
]
++ (lib.concatMap (
  ws:
  let
    key = if ws == 10 then 0 else ws;
  in
  [
    {
      _args = [
        (inline "mainMod .. \" + \" .. ${toString key}")
        (inline "hl.dsp.focus({ workspace = ${toString ws} })")
      ];
    }
    {
      _args = [
        (inline "mainMod .. \" + SHIFT + \" .. ${toString key}")
        (inline "hl.dsp.window.move({ workspace = ${toString ws} })")
      ];
    }
  ]
) (lib.range 1 10))
