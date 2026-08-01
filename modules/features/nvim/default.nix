{ inputs, ... }:
{
  flake.modules.homeManager.nvim = { pkgs, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      nixpkgs.source = inputs.nixpkgs;

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
        nvim-lspconfig
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
        telescope-nvim
        lualine-nvim
        onedark-nvim
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
  };
}
