-- Set options
vim.opt.compatible = false
vim.opt.showmatch = true
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.wildmode = 'longest,list'
vim.opt.cc = '120'
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.ttyfast = true
vim.opt.relativenumber = true

-- Set leader key
vim.g.mapleader = " "

-- has to be set for colorizer
vim.opt.termguicolors = true

-- has to be set up by the start
vim.api.nvim_create_autocmd("ColorScheme", {
    callback = function()
        local function_colors = vim.api.nvim_get_hl(0, { name = "Function" })
        local define_colors = vim.api.nvim_get_hl(0, { name = "Define" })

        if define_colors.link then
            define_colors = vim.api.nvim_get_hl(0, { name = define_colors.link })
        end

        vim.api.nvim_set_hl(0, 'QuickScopePrimary', {
            fg = function_colors.fg,
            underline = true
        })
        vim.api.nvim_set_hl(0, 'QuickScopeSecondary', {
            fg = define_colors.fg,
            underline = true
        })
    end
})

require("config.lazy")

-- Enable filetype plugins
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Enable highlight on yank
vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "highlight_yank",
    callback = function()
        vim.highlight.on_yank({
            higroup = "Visual",
            timeout = 200
        })
    end
})

-- Neogit
local neogit = require('neogit')
neogit.setup {}
vim.keymap.set('n', '<leader>gg', neogit.open, opts)

-- Neotree binding
map('n', '<Leader>n', ':Neotree position=float toggle<CR>', opts)


-- custom commands - POS
vim.api.nvim_create_user_command('PosUpdateImports', function()
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-shared/@pos-common/g]])
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-core/@pos-core/g]])
end, {})

-- tailwind tools - remember to call :UpdateRemotePlugins for this to work
require("tailwind-tools").setup({
})

-- has to be called at the end
require('colorizer').setup();
