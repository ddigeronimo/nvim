local nvim_lsp = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local opts = { noremap=true, silent=true, desc='' }
opts['desc'] = 'vim.diagnostic.open_float'
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
opts['desc'] = 'vim.diagnostic.goto_prev'
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
opts['desc'] = 'vim.diagnostic.goto_next'
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
opts['desc'] = 'vim.diagnostic.setloclist'
vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)

local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o> (as backup to nvim_cmp)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local bufopts = { noremap=true, silent=true, buffer=bufnr, desc='' }
  bufopts['desc'] = 'vim.lsp.buf.declaration'
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  bufopts['desc'] ='vim.lsp.buf.definition'
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  bufopts['desc'] ='vim.lsp.buf.code_action'
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.hover'
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.implementation'
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.signature_help'
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.add_workspace_folder'
  vim.keymap.set('n', '<space>Wa', vim.lsp.buf.add_workspace_folder, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.remove_workspace_folder'
  vim.keymap.set('n', '<space>Wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  bufopts['desc'] = 'vim.inspect(vim.lsp.buf.list_workspace_folders())'
  vim.keymap.set('n', '<space>Wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.type_definition'
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.rename'
  vim.keymap.set('n', '<space>R', vim.lsp.buf.rename, bufopts)
  bufopts['desc'] = 'vim.lsp.buf.references'
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.documentFormattingProvider then
    bufopts['desc'] = 'vim.lsp.buf.format, async=true'
    vim.keymap.set('n', '<space>F', function() vim.lsp.buf.format { async = true } end, bufopts)
  elseif client.server_capabilities.documentRangeFormattingProvider then
    bufopts['desc'] = 'vim.lsp.buf.range_formatting, async=true'
    vim.keymap.set('n', '<space>F', function() vim.lsp.buf.range_formatting { async = true } end, bufopts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.server_capabilities.documentHighlightProvider then
    vim.api.nvim_exec([[
      " In the event that lsp-colors stops working, uncomment these lines to manually update the highlight groups
      " hi LspReferenceRea cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      " hi LspReferenceText cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      " hi LspReferenceWrite cterm=bold ctermbg=DarkMagenta guibg=LightYellow
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved,CursorMovedI <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

nvim_lsp.tsserver.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

nvim_lsp.pylsp.setup {
    capabilities = capabilities,
    on_attach = on_attach
}

nvim_lsp.gopls.setup{
	cmd = {'gopls'},
	-- for postfix snippets and analyzers
	capabilities = capabilities,
	    settings = {
	      gopls = {
		      experimentalPostfixCompletions = true,
		      analyses = {
		        unusedparams = true,
		        shadow = true,
		     },
		     staticcheck = true,
		    },
	    },
	on_attach = on_attach,
}

function goimports(timeoutms)
local context = { source = { organizeImports = true } }
vim.validate { context = { context, "t", true } }

local params = vim.lsp.util.make_range_params()
params.context = context

-- See the implementation of the textDocument/codeAction callback
-- (lua/vim/lsp/handler.lua) for how to do this properly.
local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
if not result or next(result) == nil then return end
local actions = result[1].result
if not actions then return end
local action = actions[1]

-- textDocument/codeAction can return either Command[] or CodeAction[]. If it
-- is a CodeAction, it can have either an edit, a command or both. Edits
-- should be executed first.
if action.edit or type(action.command) == "table" then
  if action.edit then
    -- I had to modify this to fix an encoding related error, see: 
    -- https://www.reddit.com/r/neovim/comments/s64ern/must_be_called_with_valid_offset_encoding
    -- https://github.com/ray-x/navigator.lua/blob/92296c9fc8dfa7bcc232a2d45de01942758f0742/lua/navigator/util.lua#L405-L420
    vim.lsp.util.apply_workspace_edit(action.edit, vim.lsp.get_client_by_id(1).offset_encoding)
  end
  if type(action.command) == "table" then
    vim.lsp.buf.execute_command(action.command)
  end
else
  vim.lsp.buf.execute_command(action)
end
end



--vim.lsp.set_log_level("debug")
