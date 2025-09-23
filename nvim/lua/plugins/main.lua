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
                    "json",
                    "http"
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
        config = function()
            vim.keymap.set('n', '<Leader>nn', ':Neotree position=float toggle<CR>', opts)
            vim.keymap.set('n', '<Leader>nr', ':Neotree position=float reveal<CR>', opts)
        end
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
        dependencies = 'nvim-tree/nvim-web-devicons',
        opts = {
            options = {
                diagnostics = 'nvim_lsp',
                diagnostics_indicator = function(count, level, _, _)
                    local icon = level:match("error") and " " or " "
                    return " " .. icon .. count
                end
            }
        },
        config = function(_, bufferline_opts)
            require("bufferline").setup(bufferline_opts)

            vim.keymap.set('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
            vim.keymap.set('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', opts)
            vim.keymap.set('n', '<A-S-,>', '<Cmd>BufferLineMovePrev<CR>', opts)
            vim.keymap.set('n', '<A-S-.>', '<Cmd>BufferLineMoveNext<CR>', opts)

            vim.keymap.set('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
            vim.keymap.set('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
            vim.keymap.set('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
            vim.keymap.set('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
            vim.keymap.set('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
            vim.keymap.set('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
            vim.keymap.set('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
            vim.keymap.set('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
            vim.keymap.set('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)

            vim.keymap.set('n', '<A-0>', '<Cmd>BufferLinePick<CR>', opts)
            vim.keymap.set('n', '<A-c>', '<Cmd>bdelete<CR>', opts)
        end
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
        config = function(_, neogit_opts)
            local neogit = require('neogit')
            neogit.setup(neogit_opts)
            vim.keymap.set('n', '<leader>gg', neogit.open, opts)
        end,
        opts = {
            graph_style = 'kitty'
        }
    },
    {
        'rmagatti/auto-session',
        lazy = false,
        config = true,

        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {}
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
    {
        'stevearc/oil.nvim',
        ---@module 'oil'
        ---@type oil.SetupOpts
        opts = {},
        dependencies = { { "echasnovski/mini.icons", opts = {} } },
        lazy = false,
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        'RRethy/vim-illuminate'
    },
    {
        'stevearc/aerial.nvim',
        opts = {},
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
    },
    {
        "mistweaverco/kulala.nvim",
        keys = {
            { "<leader>Rs", desc = "Send request" },
            { "<leader>Ra", desc = "Send all requests" },
            { "<leader>Rb", desc = "Open scratchpad" },
        },
        ft = { "http", "rest" },
        opts = {
            global_keymaps = true,
            global_keymaps_prefix = "<leader>R",
            kulala_keymaps_prefix = "",
        },
    },
    {
        "jake-stewart/multicursor.nvim",
        branch = "1.0",
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            local set = vim.keymap.set

            -- Add or skip cursor above/below the main cursor.
            set({ "n", "x" }, "<up>", function() mc.lineAddCursor(-1) end)
            set({ "n", "x" }, "<down>", function() mc.lineAddCursor(1) end)
            set({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
            set({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)

            -- Add or skip adding a new cursor by matching word/selection
            set({ "n", "x" }, "<leader>a", function() mc.matchAddCursor(1) end)
            set({ "n", "x" }, "<leader>s", function() mc.matchSkipCursor(1) end)
            set({ "n", "x" }, "<leader>A", function() mc.matchAddCursor(-1) end)
            set({ "n", "x" }, "<leader>S", function() mc.matchSkipCursor(-1) end)

            -- Add and remove cursors with control + left click.
            set("n", "<c-leftmouse>", mc.handleMouse)
            set("n", "<c-leftdrag>", mc.handleMouseDrag)
            set("n", "<c-leftrelease>", mc.handleMouseRelease)

            -- Disable and enable cursors.
            set({ "n", "x" }, "<c-q>", mc.toggleCursor)

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- Delete the main cursor.
                layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { reverse = true })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { reverse = true })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end
    },
    {
        "karb94/neoscroll.nvim",
        opts = {
            duration_multiplier = 0.5
        },
    },
    {
        'github/copilot.vim'
    }
}
