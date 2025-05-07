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
    'rstacruz/vim-closer',
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
    'lewis6991/gitsigns.nvim'
}
