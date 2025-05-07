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

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  -- Leader key mappings
  vim.keymap.set('n', '<leader>gr', function()
    require('fzf-lua').lsp_references({
      timeout = 10000,
      async = true,
      multiprocess = true,
      jump_to_single_result = true,
      include_current_line = false
    })
  end, opts)
  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', '<leader>gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<leader>go', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', '<leader>fo', function()
    vim.lsp.buf.format({ async = true })
  end, opts)
  vim.keymap.set('n', '<leader>ho', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>si', vim.lsp.buf.signature_help, opts)
  
  -- Diagnostics
  vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)

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

local function get_language_server_locations()
    local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
    local is_mac = vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1
    local locations = {}

    if is_windows then
        locations.tsProbeLocations = "%APPDATA%\\npm\\node_modules\\typescript\\lib"
        locations.ngProbeLocations = "%APPDATA%\\npm\\node_modules\\@angular\\language-server"
        locations.vueLanguageServerLocation = vim.fn.expand("$APPDATA\\npm\\node_modules\\@vue\\language-server")
    elseif is_mac then
        local base_path = "/opt/homebrew/lib/node_modules"

        locations.tsProbeLocations = base_path .. "/typescript/lib"
        locations.ngProbeLocations = base_path .. "/@angular/language-server"
        locations.vueLanguageServerLocation = base_path .. "/@vue/language-server"
    else
        local base_path = "/usr/local/lib/node_modules"

        locations.tsProbeLocations = base_path .. "/typescript/lib"
        locations.ngProbeLocations = base_path .. "/@angular/language-server"
        locations.vueLanguageServerLocation = base_path .. "/@vue/language-server"
    end

    return locations
end

-- Language servers
local locations = get_language_server_locations()

local cmd = {"ngserver", "--stdio", "--tsProbeLocations", locations.tsProbeLocations, "--ngProbeLocations", locations.ngProbeLocations}

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
    on_attach = function(client, bufnr)
        -- Formatting is handled by eslint
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client, bufnr)
    end,
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
                location = locations.vueLanguageServerLocation ,
                languages = { "vue" },
            },
        },
    },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
}

require'lspconfig'.clangd.setup{
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "clangd" },
    filetypes = {"c", "cpp"},
    init_options = {
        compilationDatabasePath = "build",
        index = {
            onChange = true,
            threads = 0
        },
        clangdFileStatus = true
    }
}

require"lspconfig".eslint.setup{
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = true
        on_attach(client, bufnr)
    end,
    on_new_config = function(config, new_root_dir)
    config.settings.workspaceFolder = {
        uri = vim.uri_from_fname(new_root_dir),
        name = vim.fn.fnamemodify(new_root_dir, ':t')
    }
    end,
    filetypes = { 
        "javascript", 
        "javascriptreact", 
        "javascript.jsx", 
        "typescript", 
        "typescriptreact", 
        "typescript.tsx", 
        "vue", 
        "svelte", 
        "astro",
        "html"
    },
}

require'lspconfig'.cssls.setup{
    capabilities = capabilities,
    on_attach = on_attach
}


require'lspconfig'.html.setup{
    capabilities = capabilities,
    on_attach = on_attach
}

require'lspconfig'.jsonls.setup{
    capabilities = capabilities,
    on_attach = on_attach
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
