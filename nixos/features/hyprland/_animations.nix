let
  curve =
    map
      (
        { name, points }:
        {
          _args = [
            name
            {
              type = "bezier";
              inherit points;
            }
          ];
        }
      )
      [
        {
          name = "easeOutQuint";
          points = [
            [
              0.23
              1
            ]
            [
              0.32
              1
            ]
          ];
        }
        {
          name = "linear";
          points = [
            [
              0
              0
            ]
            [
              1
              1
            ]
          ];
        }
        {
          name = "almostLinear";
          points = [
            [
              0.5
              0.5
            ]
            [
              0.75
              1.0
            ]
          ];
        }
        {
          name = "quick";
          points = [
            [
              0.15
              0
            ]
            [
              0.1
              1
            ]
          ];
        }
      ];

  animation = [
    {
      leaf = "global";
      enabled = true;
      speed = 10;
      bezier = "default";
    }
    {
      leaf = "border";
      enabled = true;
      speed = 5;
      bezier = "easeOutQuint";
    }
    {
      leaf = "windows";
      enabled = true;
      speed = 5;
      bezier = "easeOutQuint";
    }
    {
      leaf = "windowsIn";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
      style = "popin 90%";
    }
    {
      leaf = "windowsOut";
      enabled = true;
      speed = 2;
      bezier = "linear";
      style = "popin 90%";
    }
    {
      leaf = "fadeIn";
      enabled = true;
      speed = 2;
      bezier = "almostLinear";
    }
    {
      leaf = "fadeOut";
      enabled = true;
      speed = 2;
      bezier = "almostLinear";
    }
    {
      leaf = "fade";
      enabled = true;
      speed = 3;
      bezier = "quick";
    }
    {
      leaf = "layers";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
    }
    {
      leaf = "layersIn";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
      style = "fade";
    }
    {
      leaf = "layersOut";
      enabled = true;
      speed = 2;
      bezier = "linear";
      style = "fade";
    }
    {
      leaf = "fadeLayersIn";
      enabled = true;
      speed = 2;
      bezier = "almostLinear";
    }
    {
      leaf = "fadeLayersOut";
      enabled = true;
      speed = 2;
      bezier = "almostLinear";
    }
    {
      leaf = "workspaces";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
      style = "slidevert";
    }
    {
      leaf = "workspacesIn";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
      style = "slidevert";
    }
    {
      leaf = "workspacesOut";
      enabled = true;
      speed = 4;
      bezier = "easeOutQuint";
      style = "slidevert";
    }
  ];
in
{
  inherit curve animation;
}
