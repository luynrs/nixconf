{
  flake.nixosModules.llama =
    { lib, pkgs, ... }:
    {
      services.llama-cpp = {
        enable = true;
        package = pkgs.llama-cpp-vulkan;
        settings.models-dir = "/var/lib/llama-cpp";
      };

      systemd.services.llama-cpp.serviceConfig = {
        DynamicUser = lib.mkForce false;
        User = "llama-cpp";
        Group = "llama-cpp";
        SupplementaryGroups = [
          "render"
          "video"
        ];
        Environment = [
          "XDG_CACHE_HOME=/var/cache/llama-cpp"
        ];
      };

      users.users.llama-cpp = {
        isSystemUser = true;
        group = "llama-cpp";
        home = "/var/lib/llama-cpp";
      };
      users.groups.llama-cpp = { };
    };
}
