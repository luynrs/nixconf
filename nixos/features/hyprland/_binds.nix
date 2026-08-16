{ lib }:
let
  inline = lib.generators.mkLuaInline;
  mod = key: inline ''mainMod .. " + ${key}"'';
  b = key: action: opts: {
    _args = [
      key
      (inline action)
    ]
    ++ lib.optional (opts != null) opts;
  };

  media = {
    locked = true;
    repeating = true;
  };
in
[
  (b (mod "RETURN") "hl.dsp.exec_cmd(terminal)" { description = "Terminal"; })
  (b "CTRL + SHIFT + Escape" ''hl.dsp.exec_cmd(terminal .. " -e btop")'' {
    description = "Process monitor";
  })
  (b (mod "Q") "hl.dsp.window.close()" { description = "Close window"; })
  (b (mod "E") "hl.dsp.exec_cmd(fileManager)" { description = "File manager"; })
  (b (mod "W") "hl.dsp.exec_cmd(browser)" { description = "Browser"; })
  (b (mod "L") ''hl.dsp.global("caelestia:lock")'' { description = "Lock session"; })
  (b (mod "SHIFT + Q") ''hl.dsp.global("caelestia:session")'' { description = "Power menu"; })
  (b (mod "SPACE") ''hl.dsp.window.float({ action = "toggle" })'' {
    description = "Toggle floating";
  })
  (b (mod "SHIFT + R") ''hl.dsp.exec_cmd("caelestia shell -k; caelestia shell -d")'' {
    description = "Restart widgets";
  })
  (b (mod "D") ''hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" })'' {
    description = "Window: Maximize";
  })
  (b (mod "F") ''hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" })'' {
    description = "Window: Fullscreen";
  })
  (b (mod "S") ''hl.dsp.global("caelestia:launcher")'' { description = "App launcher"; })
  (b (mod "A") ''hl.dsp.global("caelestia:dashboard")'' { description = "Dashboard"; })
  (b (mod "P") "hl.dsp.window.pseudo()" null)
  (b (mod "J") ''hl.dsp.layout("togglesplit")'' null)
  (b (mod "SHIFT + C") "hl.dsp.exec_cmd(picker)" { description = "Colour picker"; })
  (b (mod "V") ''hl.dsp.exec_cmd("caelestia clipboard")'' { description = "Clipboard history"; })
  (b (mod "SHIFT + S") ''hl.dsp.global("caelestia:screenshotFreezeClip")'' {
    description = "Screenshot: area";
  })
  (b "PRINT" ''hl.dsp.exec_cmd("caelestia screenshot")'' { description = "Screenshot: full screen"; })
  (b (mod "SHIFT + E") ''hl.dsp.exec_cmd("caelestia record -s")'' {
    description = "Toggle screen recording";
  })

  (b (mod "left") ''hl.dsp.focus({ direction = "l" })'' null)
  (b (mod "right") ''hl.dsp.focus({ direction = "r" })'' null)
  (b (mod "up") ''hl.dsp.focus({ direction = "u" })'' null)
  (b (mod "down") ''hl.dsp.focus({ direction = "d" })'' null)

  (b (mod "mouse:272") "hl.dsp.window.drag()" { mouse = true; })
  (b (mod "mouse:273") "hl.dsp.window.resize()" { mouse = true; })

  (b "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")''
    media
  )
  (b "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'' media)
  (b "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' media)
  (b "XF86AudioMicMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' media)
  (b "XF86MonBrightnessUp" ''hl.dsp.global("caelestia:brightnessUp")'' media)
  (b "XF86MonBrightnessDown" ''hl.dsp.global("caelestia:brightnessDown")'' media)

  (b "XF86AudioNext" ''hl.dsp.global("caelestia:mediaNext")'' { locked = true; })
  (b "XF86AudioPause" ''hl.dsp.global("caelestia:mediaToggle")'' { locked = true; })
  (b "XF86AudioPlay" ''hl.dsp.global("caelestia:mediaToggle")'' { locked = true; })
  (b "XF86AudioPrev" ''hl.dsp.global("caelestia:mediaPrev")'' { locked = true; })
]
++ (lib.concatMap (
  ws:
  let
    key = toString (if ws == 10 then 0 else ws);
  in
  [
    (b (mod key) "hl.dsp.focus({ workspace = ${toString ws} })" null)
    (b (mod "SHIFT + ${key}") "hl.dsp.window.move({ workspace = ${toString ws} })" null)
    (b (mod "ALT + ${key}") "hl.dsp.window.move({ workspace = ${toString ws} })" null)
  ]
) (lib.range 1 10))
