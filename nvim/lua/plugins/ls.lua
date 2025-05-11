return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "lua:custom-mason-registry",
                    "github:mason-org/mason-registry",
                }
            })
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "ts_ls",
                    "angularls",
                    "lua_ls",
                    "vimls",
                    "eslint",
                    "cssls",
                    "html",
                    "jsonls"
                },
                automatic_enable = true
            })
        end
    },

    {
        "neovim/nvim-lspconfig",
        config = function()
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

            local mason_packages_location = vim.fs.joinpath(vim.fn.stdpath('data'), 'mason', 'packages')

            vim.lsp.config['lua_ls'] = {
                on_attach = on_attach
            }

            vim.lsp.config['ts_ls'] = {
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
                filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
            }

            local function get_typescript_location()
                local is_windows = vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1
                local is_mac = vim.fn.has('mac') == 1 or vim.fn.has('macunix') == 1

                if is_windows then
                    return "%APPDATA%\\npm\\node_modules\\typescript\\lib"
                elseif is_mac then
                    return "/opt/homebrew/lib/node_modules/typescript/lib"
                else
                    return "/usr/local/lib/node_modules/typescript/lib"
                end
            end


            vim.lsp.config['angularls'] = {
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

            vim.lsp.config['eslint'] = {
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

            vim.lsp.config['cssls'] = {
                on_attach = on_attach
            }

            vim.lsp.config['html'] = {
                on_attach = on_attach
            }

            vim.lsp.config['jsonls'] = {
                on_attach = on_attach
            }
        end
    }
}
