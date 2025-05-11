return {
    schema = "registry+v1",
    name = "eslint-lsp",
    description = "ESlint lsp with modified version",
    homepage = "https://github.com/Microsoft/vscode-eslint",
    licenses = {
        "MIT",
    },
    languages = {
        "JavaScript",
        "TypeScript",
    },
    categories = {
        "LSP",
    },
    source = {
        id = "pkg:npm/vscode-langservers-extracted@4.8.0",
    },
    schemas = {
        lsp = "vscode:https://raw.githubusercontent.com/microsoft/vscode-eslint/main/package.json",
    },
    bin = {
        ["vscode-eslint-language-server"] = "npm:vscode-eslint-language-server",
    },
    neovim = {
        lspconfig = "eslint",
    },
}
