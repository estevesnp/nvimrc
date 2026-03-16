# nvimrc

my neovim config

## install lsp servers, formatters and linters

in order to install all lsp servers, formatters and linters defined in the
[lsp configuration file](lua/config/lsp.lua) with mason, you can run:

`:MasonPathInstall`

## notable dependencies

- xclip/wl-clipboard (clipboard, check `:h clipboard`)
- gcc (nvim-treesitter)
- tree-sitter (nvim-treesitter)
- ripgrep (fzf)
- fd (fzf)
- go (mason)
- rust (mason)
- npm (mason)
