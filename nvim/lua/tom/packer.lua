-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use({ 'rose-pine/neovim', as = 'rose-pine' })
    use({ 'sonph/onehalf', rtp = 'vim'})

    -- I have to include Wombat in here, because this was the primary color
    -- scheme I used on Emacs for 15+ years. I think newer themes like 
    -- Onehalf and Solarized are maybe a little more sophisticated, but idk
    -- it still looks good, especialy if I were to edit so that the gutters
    -- matched the background colors.
    use({ 'mdashx/vim-wombat-scheme', as = 'wombat' })

--    use({'altercation/vim-colors-solarized', as = 'solarized'})
    use({'frankier/neovim-colors-solarized-truecolor-only', as = 'solarized'})
        use({'jeffkreeftmeijer/vim-dim', as = 'dim'})
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'mbbill/undotree'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-commentary'
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                              -- Optional
                'williamboman/mason.nvim',
                run = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' }, -- Required
        }

    }

    use 'airblade/vim-gitgutter'
end)
