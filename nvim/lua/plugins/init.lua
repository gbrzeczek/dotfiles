local opts = { noremap = true, silent = true }

return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd('colorscheme catppuccin')
        end
    },
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
        },
        config = function(_, fzf_opts)
            require("fzf-lua").setup(fzf_opts)
            vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', opts)

            -- live grep also works in visual mode - it looks for selection
            vim.keymap.set({ 'n', 'v' }, '<leader>fg', function()
                local selected_text = ''
                if vim.fn.mode() == 'v' then
                    local saved_reg = vim.fn.getreg('v')
                    vim.cmd('normal! "vy"')
                    selected_text = vim.fn.getreg('v')
                    vim.fn.setreg('v', saved_reg)
                end
                require('fzf-lua').live_grep({ search = selected_text })
            end, opts)

            vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', opts)
            vim.keymap.set('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', opts)
            vim.keymap.set('n', '<leader>v', '<cmd>FzfLua registers<cr>', opts)
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
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
        opts = {},
    },
    {
        'joeveiga/ng.nvim',
        config = function()
            local ng = require("ng");
            vim.keymap.set("n", "<leader>gt", function()
                ng.goto_template_for_component({ reuse_window = true })
            end, opts)
            vim.keymap.set("n", "<leader>gc", function()
                ng.goto_component_with_template_file({ reuse_window = true })
            end, opts)
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = true
    },
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons'
    },
    {
        'sindrets/diffview.nvim',
        config = function()
            vim.api.nvim_set_keymap('n', '<leader>do', ':DiffviewOpen<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>dc', ':DiffviewClose<CR>', opts)
            vim.api.nvim_set_keymap('n', '<leader>dt', ':DiffviewToggleFiles<CR>', opts)
        end
    },
    'unblevable/quick-scope',
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
        config = true,

        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {}
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
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                delay = 300,
                ignore_whitespace = false,
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true })

                -- Actions
                map('n', '<leader>hs', gs.stage_hunk)
                map('n', '<leader>hr', gs.reset_hunk)
                map('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                map('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end)
                map('n', '<leader>hS', gs.stage_buffer)
                map('n', '<leader>hu', gs.undo_stage_hunk)
                map('n', '<leader>hR', gs.reset_buffer)
                map('n', '<leader>hp', gs.preview_hunk)
                map('n', '<leader>tb', gs.toggle_current_line_blame)

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end
        }
    },
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

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    -- Use pretty hover for documentation
                    draw = function(opts)
                        if opts.item and opts.item.documentation then
                            local out = require("pretty_hover.parser").parse(opts.item.documentation.value)
                            opts.item.documentation.value = out:string()
                        end

                        opts.default_implementation(opts)
                    end,
                }
            },

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
    },
    {
        "Fildo7525/pretty_hover",
        event = "LspAttach",
        opts = {}
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        'norcalli/nvim-colorizer.lua',
    },
}
