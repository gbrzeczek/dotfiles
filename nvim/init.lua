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

-- required to detect htmlangular filetype based on the .component.html suffix
-- it won't be supported in nvim itself due to compatibility reasons:
-- https://github.com/vim/vim/pull/13594#issuecomment-1834465890
vim.cmd('runtime! ftplugin/html.vim!')

require("config.lazy")

-- Enable filetype plugins
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

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

-- custom commands - POS
vim.api.nvim_create_user_command('PosUpdateImports', function()
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-shared/@pos-common/g]])
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-core/@pos-core/g]])
end, {})

-- has to be called at the end
require('colorizer').setup();
