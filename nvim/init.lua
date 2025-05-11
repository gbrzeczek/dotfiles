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

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("config.lazy")

vim.opt.termguicolors = true

-- Enable filetype plugins
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

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

-- Set colorscheme
vim.cmd('colorscheme catppuccin')

-- Make the background transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })

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

-- fzf-lua bindings
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', opts)

-- live grep also works in visual mode - it looks for selection
vim.keymap.set({'n', 'v'}, '<leader>fg', function()
    local selected_text = ''
    if vim.fn.mode() == 'v' then
        local saved_reg = vim.fn.getreg('v')
        vim.cmd('normal! "vy"')
        selected_text = vim.fn.getreg('v')
        vim.fn.setreg('v', saved_reg)
    end
    require('fzf-lua').live_grep({ search = selected_text })
end, opts)

map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>FzfLua help_tags<cr>', opts)
map('n', '<leader>v', '<cmd>FzfLua registers<cr>', opts)

-- Neotree binding
map('n', '<Leader>n', ':Neotree position=float toggle<CR>', opts)

-- Setup lualine
require('lualine').setup {}

-- Setup lua colorizer
require('colorizer').setup()

require('auto-session').setup()

-- Setup bufferline
require("bufferline").setup{}

map('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', opts)
map('n', '<A-1>', '<Cmd>BufferLineGoToBuffer 1<CR>', opts)
map('n', '<A-2>', '<Cmd>BufferLineGoToBuffer 2<CR>', opts)
map('n', '<A-3>', '<Cmd>BufferLineGoToBuffer 3<CR>', opts)
map('n', '<A-4>', '<Cmd>BufferLineGoToBuffer 4<CR>', opts)
map('n', '<A-5>', '<Cmd>BufferLineGoToBuffer 5<CR>', opts)
map('n', '<A-6>', '<Cmd>BufferLineGoToBuffer 6<CR>', opts)
map('n', '<A-7>', '<Cmd>BufferLineGoToBuffer 7<CR>', opts)
map('n', '<A-8>', '<Cmd>BufferLineGoToBuffer 8<CR>', opts)
map('n', '<A-9>', '<Cmd>BufferLineGoToBuffer 9<CR>', opts)
map('n', '<A-0>', '<Cmd>BufferLinePick<CR>', opts)
map('n', '<A-c>', '<Cmd>bdelete<CR>', opts)


-- Diffview shortcuts
vim.api.nvim_set_keymap('n', '<leader>do', ':DiffviewOpen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':DiffviewClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dt', ':DiffviewToggleFiles<CR>', { noremap = true, silent = true })


-- Angular bindings
local ng = require("ng");
vim.keymap.set("n", "<leader>gt", function()
  ng.goto_template_for_component({ reuse_window = true })
end, opts)
vim.keymap.set("n", "<leader>gc", function()
  ng.goto_component_with_template_file({ reuse_window = true })
end, opts)

-- Gitsigns
require('gitsigns').setup {
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
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>hs', gs.stage_hunk)
    map('n', '<leader>hr', gs.reset_hunk)
    map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>hS', gs.stage_buffer)
    map('n', '<leader>hu', gs.undo_stage_hunk)
    map('n', '<leader>hR', gs.reset_buffer)
    map('n', '<leader>hp', gs.preview_hunk)
    map('n', '<leader>hb', function() gs.blame_line{full=true} end)
    map('n', '<leader>tb', gs.toggle_current_line_blame)
    map('n', '<leader>hd', gs.diffthis)
    map('n', '<leader>hD', function() gs.diffthis('~') end)
    map('n', '<leader>td', gs.toggle_deleted)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}

-- custom commands - POS
vim.api.nvim_create_user_command('PosUpdateImports', function()
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-shared/@pos-common/g]])
    vim.cmd([[silent! %s/\.\.\(\/\.\.\)*\/pos-core/@pos-core/g]])
end, {})

-- nullls, prettier
local null_ls = require("null-ls")

null_ls.setup({
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.keymap.set("n", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end

    if client.supports_method("textDocument/rangeFormatting") then
      vim.keymap.set("x", "<Leader>f", function()
        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
      end, { buffer = bufnr, desc = "[lsp] format" })
    end
  end,
})

local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `'prettierd'` (v0.23.3+)
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
})

-- tailwind tools - remember to call :UpdateRemotePlugins for this to work
require("tailwind-tools").setup({
})
