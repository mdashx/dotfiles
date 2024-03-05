vim.api.nvim_create_autocmd("Filetype", { pattern = { "javascript", "typescript", "vue" }, command = "set tabstop=2 softtabstop=2 shiftwidth=2" })
