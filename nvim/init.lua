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
vim.g.mapleader = ','

-- Enable filetype plugins
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Plugin management with vim-plug
vim.cmd([[
call plug#begin()
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'dense-analysis/ale'
Plug 'nvim-neo-tree/neo-tree.nvim', {'branch': 'v2.x', 'do': ':UpdateRemotePlugins'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'joeveiga/ng.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'sindrets/diffview.nvim'
call plug#end()
]])

-- Set colorscheme
vim.cmd('colorscheme catppuccin')

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Telescope bindings
map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opts)
map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opts)
map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opts)
map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opts)

-- Neotree binding
map('n', '<Leader>n', ':Neotree position=float toggle<CR>', opts)

-- Setup lualine
require('lualine').setup {}

-- Setup bufferline
vim.opt.termguicolors = true
require("bufferline").setup{}

map('n', '<A-,>', '<Cmd>BufferLineCyclePrev<CR>', opts)
map('n', '<A-.>', '<Cmd>BufferLineCycleNext<CR>', opts)
map('n', '<A-<>', '<Cmd>BufferLineMovePrev<CR>', opts)
map('n', '<A->>', '<Cmd>BufferLineMoveNext<CR>', opts)
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
map('n', '<A-S-c>', '<Cmd>BufferLinePickClose<CR>', opts)

-- Telescope config
require('telescope').setup {
    defaults = {
        file_ignore_patterns = { 'node_modules', '.git' },
        path_display = { 'truncate' }
    }
}

local cmp = require('cmp')
local luasnip = require('luasnip')

-- Code completions
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- Leader key mappings
  buf_set_keymap('n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>go', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>fo', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
  buf_set_keymap('n', '<leader>ho', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>si', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)

  -- Diagnostics
  buf_set_keymap('n', '<leader>dn', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>dp', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>ds', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

  -- Inlay hints
  vim.keymap.set('n', '<leader>th', function()
    local current_buf = vim.api.nvim_get_current_buf()
    local inlay_hint_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = current_buf })
    vim.lsp.inlay_hint.enable(not inlay_hint_enabled, { bufnr = current_buf })
  end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
end


-- Diffview shortcuts
vim.api.nvim_set_keymap('n', '<leader>do', ':DiffviewOpen<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', ':DiffviewClose<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dt', ':DiffviewToggleFiles<CR>', { noremap = true, silent = true })

-- Language servers
local tsProbeLocations = "%APPDATA%\\npm\\node_modules\\typescript\\lib"
local ngProbeLocations = "%APPDATA%\\npm\\node_modules\\@angular\\language-server"
local vueLanguageServerLocation = vim.fn.expand("$APPDATA\\npm\\node_modules\\@vue\\language-server")

local cmd = {"ngserver", "--stdio", "--tsProbeLocations", tsProbeLocations, "--ngProbeLocations", ngProbeLocations}

require'lspconfig'.angularls.setup{
  capabilities = capabilities,
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
  on_attach = on_attach,
  settings = {
        angular = {
            inlayHints = {
                parameterNames = true,
                propertyDeclarationTypes = true,
                functionLikeReturnTypes = true,
                enumMemberValues = true,
            },
        },
    },
}

require'lspconfig'.volar.setup{}

require'lspconfig'.ts_ls.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = vueLanguageServerLocation ,
                languages = { "vue" },
            },
        },
    },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
}

-- Angular bindings
local opts = { noremap = true, silent = true }
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

