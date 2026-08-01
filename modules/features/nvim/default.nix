{ inputs, ... }:
{
  flake.modules.homeManager.nvim = { pkgs, ... }: {
    imports = [ inputs.nixvim.homeModules.nixvim ];

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

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

      opts = {
        termguicolors = true;
        number = true;
        laststatus = 3;
        signcolumn = "yes";
        showmode = false;
      };

      keymaps = [
        {
          mode = "v";
          key = "<Tab>";
          action = ">>gv";
          options.silent = true;
        }
        {
          mode = "v";
          key = "<S-Tab>";
          action = "<<gv";
          options.silent = true;
        }

        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "р";
          action = "h";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "о";
          action = "j";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "л";
          action = "k";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "д";
          action = "l";
        }

        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "ц";
          action = "w";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "и";
          action = "b";
        }

        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "ж";
          action = "0";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "э";
          action = "$";
        }

        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "а";
          action = "f";
        }
        {
          mode = [
            "n"
            "v"
            "o"
          ];
          key = "е";
          action = "t";
        }

        {
          mode = [
            "n"
            "v"
          ];
          key = "с";
          action = "c";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "в";
          action = "d";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "н";
          action = "y";
        }
        {
          mode = [
            "n"
            "v"
          ];
          key = "з";
          action = "p";
        }

        {
          mode = "n";
          key = "г";
          action = "u";
        }
        {
          mode = "n";
          key = "<C-г>";
          action = "<C-r>";
        }

        {
          mode = "n";
          key = "т";
          action = "n";
        }
        {
          mode = "n";
          key = "Т";
          action = "N";
        }
      ];

      extraConfigLua = builtins.readFile ./init.lua;
    };
  };
}
