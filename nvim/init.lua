BuildProj = function()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')

  if ft == 'python' then
    vim.cmd('!python %', vim.fn.expand('%'))
  elseif ft == 'c' then 
    vim.cmd('!make')
  elseif ft == 'cpp' then
    vim.cmd('!make')
  elseif ft == 'pl' then
    vim.cmd('!swipl -l %', vim.fn.expand('%'))
  elseif ft == 'haskell' then
    vim.cmd('!cd .. && cabal build')
  else
    print('filetype', ft, 'is not supported')
  end
end


RunProj = function()
  local ft = vim.api.nvim_buf_get_option(0, 'filetype')
  if ft == 'python' then
    vim.cmd('!python %', vim.fn.expand('%'))
  elseif ft == 'c' then 
    vim.cmd('!make run')
  elseif ft == 'cpp' then
    vim.cmd('!make run')
  elseif ft == 'pl' then
    vim.cmd('!swipl -l %', vim.fn.expand('%'))
  elseif ft == 'haskell' then
    vim.cmd('!cd .. && cabal run')
  else
    print('filetype', ft, 'is not supported')
  end
end


EncloseWordInChar = function(c, matching)
	if matching == nil then matching = c end
	return string.format("cw%s%s<Esc>P", c, matching)
end


EncloseSelectionInChar = function(c, matching)
	if matching == nil then matching = c end
	return string.format("c%s%s<Esc>P", c, matching)
end


CreateEncloseInCharBinds = function(c, matching, bc)
	if bc == nil then bc = c end
	vim.keymap.set({'n', 't'}, string.format('<M-%s>', bc), EncloseWordInChar(c, matching))
	vim.keymap.set({'v'},      string.format('<M-%s>', bc), EncloseSelectionInChar(c, matching))
	vim.keymap.set({'i'},      string.format('<M-%s>', bc), string.format('<C-o>%s', EncloseWordInChar(c, matching)))
end


BindRunCommand = function(map, command)
	vim.keymap.set({'n', 't', 'v'}, map, command)
	vim.keymap.set('i', map, string.format("<C-o>%s", command))
end


SwitchBuffer = function(prev)
	if prev == nil then prev = false end
	splitview = vim.fn.winnr('$') > 1
	if not prev then
		if splitview then
			vim.cmd('wincmd w')
		else
			vim.cmd(':bn')
		end
	else
		if splitview then
			vim.cmd('wincmd W')
		else
			vim.cmd(':bp')
		end
	end
end


function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

--
-- function expandBraces()
-- 	local line = vim.fn.getline('.')
-- 	local local_indent = vim.fn.indent('.')
-- 	local indent_size = tonumber(vim.o.tabstop)
-- 	-- col = vim.fn.col('.')
-- 	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--
-- 	if line:sub(col, col) == '(' and line:sub(col+1, col+1) == ')' then
-- 		vim.api.nvim_buf_set_text(0, row-1, col, row-1, col, {'', '', ''})
-- 		vim.fn.cursor(row+2, local_indent)
-- 		vim.cmd(string.format(':le %d', local_indent))
-- 		vim.fn.cursor(row+1, local_indent+indent_size)
-- 		vim.cmd(string.format(':le %d', local_indent+indent_size))
-- 		vim.fn.cursor(row+1, local_indent+indent_size)
-- 	else
-- 		vim.api.nvim_buf_set_text(0, row - 1, col, row-1, col, {'', ''})
-- 		vim.fn.cursor(row+1, col)
-- 		vim.cmd(string.format(':le %d', local_indent+indent_size))
-- 		vim.fn.cursor(row+1, col)
-- 	end
-- end


-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ';'

-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

vim.o.tabstop = 4

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`

-- vim.api.nvim_create_autocmd('UIEnter', {
--   callback = function()
--     vim.o.clipboard = 'unnamedplus'
--   end,
-- })

vim.api.nvim_set_option("clipboard", "unnamed")
vim.opt.clipboard = "unnamedplus"
vim.o.clipboard = "unnamedplus"

vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
-- vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = false

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

vim.keymap.set({'n'}, '<A-Left>', ':bp<Cr>')
vim.keymap.set({'n'}, '<A-Right>', ':bn<Cr>')
vim.keymap.set({'n'}, '<C-S-Tab>', ':bp<Cr>')
vim.keymap.set({'n'}, '<C-Tab>', ':bn<Cr>')

vim.keymap.set({'i'}, '<A-Left>', ':<C-o>bp<Cr>')
vim.keymap.set({'i'}, '<A-Right>', ':<C-o>bn<Cr>')
vim.keymap.set({'i'}, '<C-S-Tab>', '<C-o>:bp<Cr>')
vim.keymap.set({'i'}, '<C-Tab>', '<C-o>:bn<Cr>')

vim.keymap.set({'i'}, '<A-w>', '<C-x><C-i>')
vim.keymap.set({'i'}, '<S-Space>', '<C-x><C-i>')
vim.keymap.set({'i'}, '<C-p>', '<C-x><C-i>')
vim.keymap.set({'i'}, '<Menu>', '<C-x><C-i>')


vim.keymap.set({'n'}, '<C-s>', ':w<Cr>')
vim.keymap.set({'i'}, '<C-o><C-s>', ':w<Cr>')

vim.keymap.set('n', '<C-/>', ":norm gcc<Cr>")
vim.keymap.set('n', '<leader>c', "gcc")

vim.keymap.set({'v'}, '<C-/>', 'gc')
vim.keymap.set({'i'}, '<C-/>', '<C-o>:norm gcc<Cr>')

vim.keymap.set({'n', 'v', 't'}, 'd', '"_d')
vim.keymap.set({'n', 'v', 't'}, '<Del>', '"_dl')

BindRunCommand('<C-BS>', 'db')
BindRunCommand('<C-Del>', 'de')
BindRunCommand('<C-d>', 'diw')
BindRunCommand('<A-d>', 'dd')


BindRunCommand('<C-z>', 'u')
BindRunCommand('<C-y>', '<C-r>')
BindRunCommand('<C-r>', '<C-r>')


vim.keymap.set('i', '<S-Up>',    '<C-o>v<Up>')
vim.keymap.set('i', '<S-Down>',  '<C-o>v<Down>')
vim.keymap.set('i', '<S-Left>',  '<C-o>v<Left>')
vim.keymap.set('i', '<S-Right>', '<C-o>v<Right>')
vim.keymap.set('i', '<C-S-Up>',    '<C-o><C-S-v><Up>')
vim.keymap.set('i', '<C-S-Down>',  '<C-o><C-S-v><Down>')
vim.keymap.set('i', '<C-S-Left>',  '<C-o><C-S-v><Left>')
vim.keymap.set('i', '<C-S-Right>', '<C-o><C-S-v><Right>')

BindRunCommand('<A-Up>',    ':m-2<Cr>')
BindRunCommand('<A-Down>',  ':m+1<CR>')
BindRunCommand('<A-Up>',    ':m-2<Cr>')
BindRunCommand('<A-Down>',  ':m+1<CR>')


vim.keymap.set({'n', 'v'}, '<C-Space>', ':')
vim.keymap.set('i', '<C-Space>', '<C-o>:')

vim.keymap.set('v', '<Tab>', '>>')
vim.keymap.set('v', '<S-Tab>', '<<')

vim.keymap.set('i', '<S-Tab>', '<C-o><<')
vim.keymap.set('n', '<Tab>', '>>')
vim.keymap.set('n', '<S-Tab>', '<<')

vim.keymap.set({'i', 'n', 'v'}, '<S-Cr>', BuildProj)
vim.keymap.set({'i', 'n', 'v'}, '<C-Cr>', RunProj)


vim.keymap.set({'i', 'n', 'v'}, '<S-Up>', '<Up>')
vim.keymap.set({'i', 'n', 'v'}, '<S-Down>', '<Down>')


vim.keymap.set({'i', 'n', 'v', 't'}, '<C-C>', 'mayiw`a')


-- vim.keymap.set({'n', 'v', 't'}, 'p', ']p')
-- vim.keymap.set({'n', 'v', 't'}, 'P', ']P')



vim.keymap.set({'i', 'n', 'v', 't'}, '<C-Tab>', (function() SwitchBuffer() end))
vim.keymap.set({'i', 'n', 'v', 't'}, '<C-S-Tab>', (function() SwitchBuffer(true) end))

BindRunCommand('<A-l>', (function() SwitchBuffer() end))
BindRunCommand('<A-S-l>', (function() SwitchBuffer(true) end))


BindRunCommand('<C-\\>', ':vsplit<CR>')
BindRunCommand('<C-S-\\>', '<C-w>o')

BindRunCommand('<A-m>', '`\'')
BindRunCommand('<A-n>', '`.')


CreateEncloseInCharBinds('"', "'")
CreateEncloseInCharBinds('[', ']')
CreateEncloseInCharBinds('{', '}', 'S-[')
CreateEncloseInCharBinds('(', ')', 'S-9')
CreateEncloseInCharBinds('(', ')', '9')
CreateEncloseInCharBinds('<', '>', 'S-,')
CreateEncloseInCharBinds('"', "S-'")
CreateEncloseInCharBinds('|', 'S-\\')


-- vim.keymap.set('i', '<CR>', expandBraces)
-- vim.keymap.set('i', '<A-CR>', expandBraces)





-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
 desc = 'Highlight when yanking (copying) text',
 callback = function()
   vim.highlight.on_yank()
 end,
})

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
-- vim.cmd('packadd! nohlsearch')

vim.o.autochdir = true
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("darkblue")
vim.o.statusline = '%M%f%r%y[%n]-[%l.%v]/%L'


vim.cmd('set tabstop=3 shiftwidth=0 softtabstop=0 noexpandtab')
vim.cmd('autocmd FileType haskell setlocal tabstop=2 shiftwidth=0 softtabstop=2 expandtab')
vim.cmd('autocmd FileType prolog setlocal tabstop=2 shiftwidth=0 softtabstop=0 noexpandtab')
-- vim.cmd('autocmd FileType lua setlocal tabstop=2 shiftwidth=0 softtabstop=0 noexpandtab')


require("config.lazy")


vim.cmd.colorscheme("natale-domini")

-- haskell-tools
local ht = require('haskell-tools')
local bufnr = vim.api.nvim_get_current_buf()
local opts = { noremap = true, silent = true, buffer = bufnr, }
-- haskell-language-server relies heavily on codeLenses,
-- so auto-refresh (see advanced configuration) is enabled by default
-- vim.keymap.set('n', '<leader>hr', vim.lsp.codelens.run, opts)
-- Hoogle search for the type signature of the definition under the cursor
vim.keymap.set('n', '<leader>hs', ht.hoogle.hoogle_signature, opts)
-- Evaluate all code snippets
vim.keymap.set('n', '<leader>hea', ht.lsp.buf_eval_all, opts)
-- Toggle a GHCi repl for the current package
vim.keymap.set('n', '<leader>hrr', ht.repl.toggle, opts)
-- Toggle a GHCi repl for the current buffer
vim.keymap.set('n', '<leader>hrf', function()
  ht.repl.toggle(vim.api.nvim_buf_get_name(0))
end, opts)
vim.keymap.set('n', '<leader>hrq', ht.repl.quit, opts)


-- telescope

require("telescope").setup {
defaults = { --[[ your defaults]] },
	extensions = {
		file_browser = {
		}
	}
}

local fb = require "telescope".extensions.file_browser
local fb_actions = require "telescope".extensions.file_browser.actions

require("telescope").load_extension "file_browser"

local builtin = require('telescope.builtin')
vim.keymap.set({'n', 'i', 'v'}, '<C-g>', fb.file_browser, { desc = 'Telescope find files' })
vim.keymap.set({'n', 'i', 'v'}, '<C-;>', builtin.buffers, { desc = 'Telescope buffers' })

vim.keymap.set({'n', 'i', 'v'}, '<leader>ff', fb.file_browser, { desc = 'Telescope find files' })
vim.keymap.set({'n', 'i', 'v'}, '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set({'n', 'i', 'v'}, '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set({'n', 'i', 'v'}, '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


vim.keymap.set({'n', 'i', 'v'}, '<leader>e', vim.diagnostic.open_float, { desc = 'diagnostics' })
vim.keymap.set({'n', 'i', 'v'}, '<M-e>', vim.diagnostic.open_float, { desc = 'diagnostics' })
vim.keymap.set({'n', 'i', 'v'}, '<M-S-e>', builtin.diagnostics, { desc = 'diagnostics' })
vim.keymap.set({'n', 'i', 'v'}, '<leader>E', builtin.diagnostics, { desc = 'diagnostics' })

