
vim.api.nvim_create_autocmd("BufWritePre", { pattern = { "*.vue, *.tsx,*.ts,*.js,*.html,*.css" }, command = "Prettier", })
