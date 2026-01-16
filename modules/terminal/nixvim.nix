{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.modules.terminal.nixvim;
in
{
  options.modules.terminal.nixvim = {
    enable = lib.mkOption {
      default = false;
      description = "Enable Neovim with Nix Stubs";
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      # Neovim Config with Nix Stubs
      nixvim = {
        # All nixvim options: https://nix-community.github.io/nixvim/search/
        enable = true;
        # autoCmd = {};
        # autoGroups = {};
        # build = {};
        clipboard = {
          register = "unnamedplus";
          providers = {
            wl-copy.enable = true;
          };
        };
        colorschemes = {
          catppuccin = {
            enable = true;
          };
        };
        # userCommands = {};
        # diagnostics = {};
        # enableMan = true;
        editorconfig = {
          enable = true; # EditorConfig support, looks for .editorconfig files
        };
        # filetype = {};
        opts = {
          number = true;
          relativenumber = true;
          tabstop = 2;
          shiftwidth = 2; # 0 means use tabstop
          expandtab = false;

          #nvim-ufo
          foldcolumn = "auto:1";
          foldlevel = 99;
          foldenable = true;
          #fillchars = "[[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]";
          foldlevelstart = 99; # temp fix for nvim-ufo
          fillchars = {
            eob = " ";
            fold = " ";
            foldopen = "";
            foldsep = "|";
            foldclose = "";
          };
          # fix annoying
          scrolloff = 3;
        };
        # extraFiles = {};
        # extraConfigLua = {};
        # extraConfigLuaPost = {};
        # extraConfigLuaPre = {};
        # extraConfigVim = {};
        # extraLuaPackages
        extraPackages = [
          # extra packages, things like `conform` might require
          pkgs.alejandra
          pkgs.biome
          pkgs.black
          pkgs.nixfmt-rfc-style
        ];
        # extraPlugins = {};
        # extraPython3Packages = {};

        # highlight = {};
        # highlightOverride = {};
        # match = {};
        # vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
        # vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        keymaps = [
        ];
        # keymapsOnEvents = {};
        # luaLoader = {};
        lsp = {
          servers = {
            biome.enable = true; # JS, TS, json, css, html, etc.
            nil_ls.enable = true; # nix
            yamlls.enable = true; # yaml
          };
          #luaConfig = {
          #  pre = "vim.lsp.set_log_level('debug')";
          #};
        };
        # performance = {};
        plugins = {
          # Good folding for nix!
          nvim-ufo = {
            enable = true;
            settings = {
              open_fold_hl_timeout = 0;
              provider_selector = "function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
            end";
            };
          };
          # Treesitter, a syntax tree generator
          treesitter = {
            enable = true;
          };
          # pretty UI (box) for Neovim
          #TODO Replace with snacks
          dressing = {
            enable = true;
          };
          #  UI Component Library for Neovim.
          nui = {
            enable = true;
          };
          web-devicons = {
            enable = true;
          };
          # "Swiss Army knife" among Neovim plugins, bunch of libs
          mini = {
            enable = true;
          };
          # Folder tree view :Neotree
          neo-tree = {
            # https://github.com/nvim-neo-tree/neo-tree.nvim
            enable = true;
          };
          # Indent guides for Neovim
          indent-blankline = {
            # https://github.com/lukas-reineke/indent-blankline.nvim
            enable = true;
            settings = {
              scope = {
                enabled = true;
              };
            };
          };
          # Lightweight yet powerful formatter plugin for Neovim
          conform-nvim = {
            # https://github.com/stevearc/conform.nvim
            enable = true;
            settings = {
              format_on_save = {
                lsp_fallback = "fallback";
                timeout_ms = 500;
              };
              formatters_by_ft = {
                "_" = [
                  "squeeze_blanks"
                  "trim_whitespace"
                  "trim_newlines"
                ];
                css = [ "prettier" ];
                html = [ "prettier" ];
                json = [ "prettier" ];
                just = [ "just" ];
                lua = [ "stylua" ];
                nix = [
                  #"alejandra"
                  "nixfmt"
                ];
                ruby = [ "rubocop" ];
                terraform = [ "tofu_fmt" ];
                tf = [ "tofu_fmt" ];
                yaml = [ "yamlfmt" ];
                ts = [ "biome" ];
                tsx = [ "biome" ];
                go = [
                  "gofmt"
                  "goimports"
                  "golines"
                ];
              };
              notify_no_formatters = true;
              notify_on_error = true;
            };
          };

          # Language Server Protocol support for Neovim
          lspconfig.enable = true;
          # Adds browser-style tabs to the top
          bufferline = {
            enable = true;
          };
          # Fuzzy file finder
          telescope = {
            enable = true;
          };
          # line numbers
          numbertoggle = {
            enable = true;
          };
          # statusline
          lualine = {
            enable = true;
          };
          # Markdown Preview
          markdown-preview = {
            enable = true;
          };
          # Clipboard History
          neoclip = {
            enable = true;
          };
          # CMP - A completion plugin for neovim coded in Lua.
          # https://github.com/hrsh7th/nvim-cmp/wiki/List-of-sources
          #cmp = {
          #  enable = true;
          #};
          blink-cmp = {
            enable = true;
            settings = {
              appearance = {
                nerd_font_variant = "mono";
                use_nvim_cmp_as_default = true;
              };
              completion = {
                accept = {
                  auto_brackets = {
                    enabled = true;
                    semantic_token_resolution = {
                      enabled = false;
                    };
                  };
                };
                documentation = {
                  auto_show = true;
                };
                menu.draw.components.kind_icon = {
                  ellipsis = false;
                  text.__raw = ''
                    function(ctx)
                      local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                      return kind_icon
                    end
                  '';
                  highlight.__raw = ''
                    function(ctx)
                      local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                      return hl
                    end
                  '';
                };
              };
              keymap = {
                preset = "enter";
                "<Tab>" = [
                  "select_next"
                  "fallback"
                ];
                "<S-Tab>" = [
                  "select_prev"
                  "fallback"
                ];
              };
              signature = {
                enabled = true;
              };
              sources = {
                default = [
                  "lsp"
                  "path"
                  "snippets"
                  "buffer"
                ];
                providers = {
                  buffer = {
                    max_items = 5;
                    min_keyword_length = 3;
                  };
                };
              };
            };
          };
          # GitHub Copilot
          copilot-lua = {
            enable = true;
            settings = {
              suggestion = {
                keymap.accept = "<A-l>";
                auto_trigger = true;
              };
            };
          };
          # guess indent
          guess-indent = {
            enable = true;
          };
          # whichkey
          which-key = {
            enable = true;
          };
          # Inline markdown renderer
          render-markdown = {
            enable = true;
            settings = {
              file_types = [
                "Avante"
              ];
            };
          };
          # Conflict marker stuff
          # TODO make it a 'conflict handler suite' type thing
          git-conflict = {
            enable = true;
          };
          # Cursor-like ai promopt
          avante = {
            enable = true;
            settings = {
              provider = "ollama";
              ollama = {
                endpoint = "localhost:11434";
                model = "qwen2.5-coder:3b";
                #options = {
                #  num_ctx = 16384;
                #};
              };
            };
          };
        };
        extraPlugins = [
          # Line number toggles
          (pkgs.vimUtils.buildVimPlugin {
            name = "nvim-numbertoggle";
            src = pkgs.fetchFromGitHub {
              owner = "sitiom";
              repo = "nvim-numbertoggle";
              rev = "c5827153f8a955886f1b38eaea6998c067d2992f";
              hash = "sha256-IkJ9KRrikJZvijjfqgnJ2/QYAuF8KX2/zFX1oUbE3aI=";
            };
          })
          pkgs.vimPlugins.img-clip-nvim
        ];
      };
    };
  };
}
