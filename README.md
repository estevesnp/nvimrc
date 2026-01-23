# nvimrc

my neovim config

## install lsp servers, formatters and linters

in order to install all lsp servers, formatters and linters defined in the
[lsp configuration file](lua/config/lsp/servers.lua) with mason, you can run:

`:lua require('config.lsp.mason').install_not_in_path()`

## notable dependencies

- xclip/wl-clipboard (clipboard, check `:h clipboard`)
- gcc (nvim-treesitter)
- tree-sitter (nvim-treesitter)
- ripgrep (fzf)
- fd (fzf)
- go (mason)
- rust (mason)
- npm (mason)
