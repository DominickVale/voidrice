local cmp = require'cmp'
local lspkind = require'lspkind'
local luasnip = require'luasnip'

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

local null_ls = require("_null-ls")
local u = require("utils")

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },
    formatting = {
        -- format = lspkind.cmp_format({with_text = false, maxwidth = 50})
        format = function(entry, vim_item)
          -- fancy icons and a name of kind
          vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
      
          -- set a name for each source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            luasnip = "[LuaSnip]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
          })[entry.source.name]
          return vim_item
        end,
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'cmdline' },
    }
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

local function config(_config)
    return vim.tbl_deep_extend("force", {
        capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    }, _config or {})
end

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

require "lsp_signature".setup()

require'lspconfig'.jedi_language_server.setup{config({
  capabilities = capabilities,
})}
require'lspconfig'.bashls.setup{config({
  capabilities = capabilities,
})}
local ts_utils_settings = {
    -- debug = true,
    import_all_scan_buffers = 100,
    eslint_bin = "eslint_d",
    eslint_enable_diagnostics = true,
    eslint_opts = {
        condition = function(utils)
            return utils.root_has_file(".eslintrc.js")
        end,
        diagnostics_format = "#{m} [#{c}]",
    },
    enable_formatting = true,
    -- formatter = "eslint_d",
    update_imports_on_move = true,
    formatter = "prettierd",

    -- parentheses completion
    complete_parens = true,
    signature_help_in_parens = true,
    -- filter out dumb module warning
    filter_out_diagnostics_by_code = { 80001 },
}
require'lspconfig'.tsserver.setup{
  on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      -- format on save
      vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")

      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup(ts_utils_settings)
      ts_utils.setup_client(client)
  end,
  flags = {
      debounce_text_changes = 150,
  },
}
-- require'lspconfig'.eslint.setup{config({
--   capabilities = capabilities,
-- })}
require'lspconfig'.tailwindcss.setup{config({
  capabilities = capabilities,
})}
require'lspconfig'.cmake.setup{config({
  capabilities = capabilities,
})}
require'lspconfig'.jsonls.setup ({
  capabilities = capabilities,
})

require'lspconfig'.html.setup ({
  capabilities = capabilities,
})
require'lspconfig'.cssls.setup({
  capabilities = capabilities,
})

require'lspconfig'.clangd.setup(config({
    cmd = { "clangd", "--background-index", "--clang-tidy" },
    root_dir = function() return vim.loop.cwd() end
}))

require'lspconfig'.yamlls.setup(config())

null_ls.setup(on_attach)

local opts = {
    -- whether to highlight the currently hovered symbol
    -- disable if your cpu usage is higher than you want it
    -- or you just hate the highlight
    -- default: true
    highlight_hovered_item = true,

    -- whether to show outline guides
    -- default: true
    show_guides = true,
}

require('symbols-outline').setup(opts)

local snippets_paths = function()
    local plugins = { "friendly-snippets" }
    local paths = {}
    local path
    local root_path = vim.env.HOME .. '/.config/nvim/plugged/'
    for _, plug in ipairs(plugins) do
        path = root_path .. plug
        if vim.fn.isdirectory(path) ~= 0 then
            table.insert(paths, path)
        end
    end
    return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
    paths = snippets_paths(),
    include = nil,  -- Load all languages
    exclude = {}
})
