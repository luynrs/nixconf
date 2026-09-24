{
  flake.homeModules.btop =
    {
      pkgs,
      osConfig,
      ...
    }:
    {
      programs.btop = {
        enable = true;
        package = pkgs.btop.override { rocmSupport = osConfig.services.lact.enable; };

        settings = {
          color_theme = "caelestia";
          theme_background = false;
          shown_boxes = "cpu gpu0 mem net proc";
          show_gpu_info = "Off";
          cpu_single_graph = true;
          gpu_mirror_graph = false;
          proc_tree = true;
          proc_filter_kernel = true;
        };
      };
    };
}
