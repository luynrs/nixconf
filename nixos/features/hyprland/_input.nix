{ lib, keymap }:
let
  inline = lib.generators.mkLuaInline;
  overview = inline ''
    function()
      hl.dispatch(hl.dsp.global("caelestia:showall"))
    end
  '';
in
{
  config = {
    input = {
      kb_layout = lib.concatStringsSep "," keymap.layouts;
      kb_options = keymap.options;

      follow_mouse = 1;
      sensitivity = 0;
      accel_profile = "flat";

      touchpad = {
        natural_scroll = false;
        disable_while_typing = true;
        clickfinger_behavior = true;
      };
    };

    gestures = {
      workspace_swipe_distance = 700;
      workspace_swipe_cancel_ratio = 0.2;
      workspace_swipe_min_speed_to_force = 5;
      workspace_swipe_direction_lock = true;
      workspace_swipe_direction_lock_threshold = 10;
      workspace_swipe_create_new = true;
    };
  };

  gesture = [
    {
      fingers = 3;
      direction = "swipe";
      action = "move";
    }
    {
      fingers = 3;
      direction = "pinch";
      action = "fullscreen";
    }
    {
      fingers = 4;
      direction = "horizontal";
      action = "workspace";
    }
    {
      fingers = 4;
      direction = "up";
      action = overview;
    }
    {
      fingers = 4;
      direction = "down";
      action = overview;
    }
  ];
}
