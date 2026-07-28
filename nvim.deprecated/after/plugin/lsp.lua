local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()

    vim.keymap.set('n', 'gn', '<cmd>lua vim.lsp.buf.rename()<cr>', { buffer = bufnr })
end)

lsp.ensure_installed({
    'lua_ls',
    'tsserver',
    'eslint',
    'omnisharp',
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()
