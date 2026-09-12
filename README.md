# nvimrc

my neovim config

## on first install

when first installing all plugins, fff might return an error regarding a missing binary.

to fix this, run the following command once:

`:lua require("fff.download").download_or_build_binary()`

## lsp configs

in order to install all lsp servers, formatters and linters defined in the
[lsp configuration file](lua/config/lsp.lua) with mason, you can run:

`:MasonPathInstall`

if lsp servers need to be configured and enabled without being source controlled,
create a [lsp/local.lua](lua/config/lsp/local.lua) that returns the configs:

```lua
return {
  clangd = {
    cmd = { "clangd", "--offset-encoding=utf-16", "--function-arg-placeholders=0" },
  },
  gh_actions_ls = {},
}
```

## notable dependencies

- xclip/wl-clipboard (clipboard, check `:h clipboard`)
- gcc (nvim-treesitter)
- tree-sitter cli (nvim-treesitter)
- ripgrep (fzf)
- fd (fzf)
- go (mason)
- rust (mason)
- npm (mason)
