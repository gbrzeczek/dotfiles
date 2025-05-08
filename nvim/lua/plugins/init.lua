return {
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            fzf_colors = true,
            winopts = {
                height = 0.9,
                width = 0.9,
                preview = {
                    horizontal = 'up:60%'
                }
            },
            files = {
                fd_opts = "--type f --hidden --follow --exclude .git --exclude node_modules --exclude .angular"
            }
        }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
          local configs = require("nvim-treesitter.configs")
    
          configs.setup({
              ensure_installed = { 
                  "lua",
                  "vim",
                  "vimdoc",
                  "query",
                  "javascript",
                  "html",
                  "typescript",
                  "angular",
                  "css",
                  "yaml",
                  "json"
              },
              sync_install = false,
              highlight = { enable = true },
              indent = { enable = true },  
            })
        end
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },
        lazy = false,
        ---@module "neo-tree"
        ---@type neotree.Config?
        opts = { },
    },
    'neovim/nvim-lspconfig',
    'joeveiga/ng.nvim',
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    'sindrets/diffview.nvim',
    'unblevable/quick-scope',
    'norcalli/nvim-colorizer.lua',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = true
        -- use opts = {} for passing setup options
        -- this is equivalent to setup({}) function
    },
    'romainl/vim-cool',
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "sindrets/diffview.nvim",
            "ibhagwan/fzf-lua",
        },
    },
    {
        'rmagatti/auto-session',
        lazy = false,
    
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = { }
    },
    'nvimtools/none-ls.nvim',
    {
        'MunifTanjim/prettier.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvimtools/none-ls.nvim',
        }
    },
    {
        "luckasRanarison/tailwind-tools.nvim",
        name = "tailwind-tools",
        build = ":UpdateRemotePlugins",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "neovim/nvim-lspconfig",
        },
        opts = {}
    },
    'lewis6991/gitsigns.nvim',
    {
        'saghen/blink.cmp',
        dependencies = { 'rafamadriz/friendly-snippets' },
        version = '1.*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
          -- All presets have the following mappings:
          -- C-space: Open menu or open docs if already open
          -- C-n/C-p or Up/Down: Select next/previous item
          -- C-e: Hide menu
          keymap = { preset = 'enter' },
    
          appearance = {
            nerd_font_variant = 'mono'
          },
    
          -- (Default) Only show the documentation popup when manually triggered
          completion = { documentation = { auto_show = true, auto_show_delay_ms = 500 } },
    
          -- Default list of enabled providers defined so that you can extend it
          -- elsewhere in your config, without redefining it, due to `opts_extend`
          sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
          },
    
          fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require('tiny-inline-diagnostic').setup()
            vim.diagnostic.config({ virtual_text = false }) -- Only if needed in your configuration, if you already have native LSP diagnostics
        end
    }
}
