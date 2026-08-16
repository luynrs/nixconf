_: {
  flake.homeModules.btop =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {
      programs.btop = {
        enable = true;
        package = lib.mkIf osConfig.services.lact.enable (
          pkgs.writeShellScriptBin "btop" ''
            export LD_LIBRARY_PATH="${pkgs.rocmPackages.rocm-smi}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
            exec "${pkgs.btop}/bin/btop" "$@"
          ''
        );

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
