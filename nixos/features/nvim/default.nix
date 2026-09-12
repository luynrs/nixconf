{ inputs, ... }:
{
  flake.homeModules.nvim = { config, pkgs, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      nixpkgs.source = inputs.nixpkgs;

      colorschemes.catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = true;
          integrations.cmp = true;
        };
      };

      extraPackages = with pkgs; [
        lua-language-server
        typescript-language-server
        pyright
        rust-analyzer
        clang-tools
        vscode-langservers-extracted
        ripgrep
        fd
      ];

      extraPlugins = with pkgs.vimPlugins; [
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        cmp_luasnip
        luasnip
        lspkind-nvim
        nvim-autopairs
        lazydev-nvim
        plenary-nvim
        nvim-treesitter
        nvim-tree-lua
        telescope-nvim
        lualine-nvim
        alpha-nvim
        nvim-web-devicons
      ];

      extraConfigLua = builtins.readFile ./init.lua;

      extraFiles = {
        "lua/options.lua".source = ./lua/options.lua;
        "lua/mappings.lua".source = ./lua/mappings.lua;
        "lua/plugins/alpha.lua".source = ./lua/plugins/alpha.lua;
        "lua/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
        "lua/plugins/lualine.lua".source = ./lua/plugins/lualine.lua;
        "lua/plugins/other.lua".source = ./lua/plugins/other.lua;
      };
    };

    xdg.desktopEntries.nvim = {
      name = "Neovim";
      genericName = "Text Editor";
      icon = "nvim";
      exec = "${pkgs.foot}/bin/foot -e ${config.programs.nixvim.build.package}/bin/nvim %F";
      terminal = false;
      categories = [
        "Utility"
        "TextEditor"
        "Development"
      ];
      mimeType = [
        "text/plain"
        "text/markdown"
        "text/x-nix"
        "text/x-python"
        "text/x-shellscript"
        "text/x-csrc"
        "text/x-c++src"
        "text/x-rust"
        "text/x-go"
        "application/json"
        "application/toml"
        "application/x-yaml"
      ];
    };

    xdg.mimeApps.defaultApplications = {
      "text/plain" = "nvim.desktop";
      "text/markdown" = "nvim.desktop";
      "text/x-nix" = "nvim.desktop";
      "text/x-shellscript" = "nvim.desktop";
      "text/x-python" = "nvim.desktop";
      "text/x-rust" = "nvim.desktop";
      "text/x-csrc" = "nvim.desktop";
      "text/x-c++src" = "nvim.desktop";
      "text/x-go" = "nvim.desktop";
      "application/json" = "nvim.desktop";
      "application/toml" = "nvim.desktop";
      "application/x-yaml" = "nvim.desktop";
    };
  };
}
