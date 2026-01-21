# nvimrc

my neovim config

## install lsp servers, formatters and linters

in order to install all lsp servers, formatters and linters defined in the
[lsp configuration file](lua/config/lsp/servers.lua), you can run:

`:lua require('config.lsp.servers').install_not_in_path()`

## notable dependencies

- gcc (tree-sitter)
- xclip (clipboard, check `:h clipboard`)
- ripgrep (fzf)
- fd (fzf)
- go (gopls and tools)
- rust (rust-analyzer)
- npm (lsp installations and quicktype)
- tree-sitter (nvim-treesitter)
- java 21+ (jdtls)
