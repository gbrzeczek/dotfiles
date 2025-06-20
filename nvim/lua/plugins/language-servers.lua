local on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }

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
    vim.keymap.set('n', '<leader>ho', require("pretty_hover").hover, opts)
    vim.keymap.set('n', '<leader>si', vim.lsp.buf.signature_help, opts)

    -- Diagnostics
    vim.keymap.set('n', '<leader>dn', function() vim.diagnostic.jump({ direction = "next" }) end, opts)
    vim.keymap.set('n', '<leader>dp', function() vim.diagnostic.jump({ direction = "prev" }) end, opts)
    vim.keymap.set('n', '<leader>ds', vim.diagnostic.open_float, opts)

    -- Inlay hints
    vim.keymap.set('n', '<leader>th', function()
        local current_buf = vim.api.nvim_get_current_buf()
        local inlay_hint_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = current_buf })
        vim.lsp.inlay_hint.enable(not inlay_hint_enabled, { bufnr = current_buf })
    end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
end

return {
    {
        "williamboman/mason.nvim",
        config = true
    },

    {
        'WhoIsSethDaniel/mason-tool-installer',
        opts = {
            ensure_installed = {
                "prettierd"
            }
        }
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "angularls",
                    "lua_ls",
                    "vimls",
                    "eslint@4.8.0",
                    "cssls",
                    "html",
                    "jsonls"
                },
                automatic_enable = true
            })
        end
    },

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {
            on_attach = function(client, bufnr)
                -- Formatting is handled by eslint
                client.server_capabilities.documentFormattingProvider = false
                on_attach(client, bufnr)
            end
        },
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.lsp.config.lua_ls = {
                on_attach = on_attach
            }

            vim.lsp.config.angularls = {
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

            -- temp fix for LspEslintFixAll not working
            local base_on_attach = vim.lsp.config.eslint.on_attach

            vim.lsp.config.eslint = {
                on_attach = function(client, bufnr)
                    if base_on_attach ~= nil then base_on_attach(client, bufnr) end
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

            vim.lsp.config.cssls = {
                on_attach = on_attach
            }

            vim.lsp.config.html = {
                on_attach = on_attach
            }

            vim.lsp.config.jsonls = {
                on_attach = on_attach
            }
        end
    },

    -- none-ls/null-ls for prettier
    {
        'nvimtools/none-ls.nvim',
        opts = {
            on_attach = function(client, bufnr)
                if client.supports_method("textDocument/formatting") then
                    vim.keymap.set("n", "<Leader>fo", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })
                end

                if client.supports_method("textDocument/rangeFormatting") then
                    vim.keymap.set("x", "<Leader>fo", function()
                        vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                    end, { buffer = bufnr, desc = "[lsp] format" })
                end
            end,
        }
    },

    {
        'MunifTanjim/prettier.nvim',
        dependencies = {
            'neovim/nvim-lspconfig',
            'nvimtools/none-ls.nvim',
        },
        opts = {
            bin = 'prettierd',
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
        }
    },
}
