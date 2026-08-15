# nvimrc

my neovim config

## on first install

when first installing all plugins, fff might return an error regarding a missing binary.

to fix this, run the following command once:

`:lua require("fff.download").download_or_build_binary()`

## install lsp servers, formatters and linters

in order to install all lsp servers, formatters and linters defined in the
[lsp configuration file](lua/config/lsp.lua) with mason, you can run:

`:MasonPathInstall`

## local override

local config overrides that are not source controlled can be created in:

`after/plugin/zz-local.lua`

## notable dependencies

- xclip/wl-clipboard (clipboard, check `:h clipboard`)
- gcc (nvim-treesitter)
- tree-sitter cli (nvim-treesitter)
- ripgrep (fzf)
- fd (fzf)
- go (mason)
- rust (mason)
- npm (mason)
