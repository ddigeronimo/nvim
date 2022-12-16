"========Plugins========

" If vim-plug isn't installed, install it automatically
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin()
" * Functional plugins *
" Motions to surround text with enclosures and tags
Plug 'kylechui/nvim-surround'
" Hotkeys for commenting
Plug 'numToStr/Comment.nvim'
" Support for git filetypes
Plug 'tpope/vim-git'
" Git client
Plug 'tpope/vim-fugitive'
" GitHub integration for fugitive
Plug 'tpope/vim-rhubarb'
" Helpful functions on the bracket keys
Plug 'tpope/vim-unimpaired'
" Git status in gutter
Plug 'airblade/vim-gitgutter'
" Visually jump around files
Plug 'easymotion/vim-easymotion'
" Align text objects based on rules
Plug 'junegunn/vim-easy-align'
" Automatically close paired characters
Plug 'townk/vim-autoclose'
" Fuzzy finding pop-up menus
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
" Simplify configuring the built-in LSP 
Plug 'neovim/nvim-lspconfig'
" Abstractions to simplify working with treesitter for highlighting, etc
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
" Dynamic keybinding menus, ported from Emacs
Plug 'folke/which-key.nvim'
" Use ranger as a pop-up window via RPC
Plug 'kevinhwang91/rnvimr'
" Lightweight status line
Plug 'nvim-lualine/lualine.nvim'
" UI replacements for messages, cmdline, and popupmenu
Plug 'folke/noice.nvim'
" Explain regex under cursor
Plug 'bennypowers/nvim-regexplainer'
" A truly Zen editing experience
Plug 'folke/twilight.nvim'
Plug 'folke/zen-mode.nvim'
" 🦆DUCK🦆
Plug 'tamton-aquib/duck.nvim'

" * Completion *
" Completion engine
Plug 'hrsh7th/nvim-cmp'
" Snippet engine
Plug 'L3MON4D3/LuaSnip'
Plug 'rafamadriz/friendly-snippets'
" nvim-cmp integrations
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'saadparwaiz1/cmp_luasnip'

" * Colorschemes/visual tweaks *
" Add LSP support to colorschemes without LSP or COC highlight groups
Plug 'folke/lsp-colors.nvim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'folke/tokyonight.nvim', { 'branch' : 'main' }
Plug 'shaunsingh/moonlight.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'projekt0n/github-nvim-theme'
Plug 'EdenEast/nightfox.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'Yazeed1s/minimal.nvim'
Plug 'Mofiqul/vscode.nvim'

" * Dependencies *
" lua coroutines, needed for telescope among others
Plug 'nvim-lua/plenary.nvim'
" Faster native-compiled fzf implementation for telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Icons for telescope, lualine, and other plugins
Plug 'kyazdani42/nvim-web-devicons'
" UI elements
Plug 'MunifTanjim/nui.nvim'
" Notification popups
Plug 'rcarriga/nvim-notify'
call plug#end()

" Replace Netrw with Ranger
let g:rnvimr_enable_ex = 1 

" nvim-surround setup (defaults)
lua require("nvim-surround").setup()

" comment.nvim setup (defaults)
lua require("Comment").setup()

" which-key setup (defaults)
lua require("which-key").setup {}

" lsp setup
lua require("lsp_config")
autocmd BufWritePre *.go lua vim.lsp.buf.formatting()
autocmd BufWritePre *.go lua goimports(1000)

" Treesitter setup
lua require("treesitter_config")

" Telescope setup
lua require("telescope_config")

" Lualine setup
lua require("lualine").setup()

" Completion setup
set completeopt=menu,menuone,noselect,preview
lua require("cmp_config")

" Noice setup
lua require("noice_config")

" nvim-regexplainer setup
lua require("regexplainer").setup({})

" zen setup
lua require("twilight").setup({})
lua require("zen-mode").setup({})

" Colorscheme setup
if (has("termguicolors"))
    set termguicolors
endif
lua require("lsp-colors").setup( { Error = "#db4b4b", Warning = "#e0af68", Information = "#0db9d7", Hint = "#10B981" })
lua require("kanagawa").setup({ commentStyle = { italic = false }, keywordStyle = { italic = false }, variablebuiltinStyle = { italic = false }, globalStatus = true })
colorscheme kanagawa

"========General settings========

" Enable line numbers, with normal numbering in insert and cmd modes and
" hybrid numbering in other modes
lua require("line_numbers")

" Allows you to leave a file in the background regardless of save status
" Also saves undo history even after saving and changing files
set hidden

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Indentation settings for using 4 spaces instead of tabs.
set shiftwidth=4
set softtabstop=4
set expandtab
" When tabs are used, make sure they display as 4 spaces instead of 8
set tabstop=4

" Write the buffer to the swapfile after 2000ms (which updates VC status)
set updatetime=2000

" When the cursor reaches the top or bottom, leave two lines of padding
set scrolloff=2

" Add ** to the path to enable :find to search recursively/tab complete.
" This works best when you launch Vim from within your project directory.
set path+=**

" EEK, a=mouse!!!! (all mouse integrations)
set mouse=a

" Syncronize with the system clipboard, requires win32yank.exe on WSL
set clipboard=unnamedplus

" Wait for half a second for keymap sequences (or to launch which-key)
set timeoutlen=500

" Share one statusline among all windows
set laststatus=3

" Turn off line wrapping
set nowrap

" If list is activated, show trailing whitespace, tabs, EOLs, non-breaking spaces
set listchars=eol:↵,trail:~,tab:>-,nbsp:␣,extends:◣,precedes:◢

" Terminal buffer specific settings
function! TerminalSettings()
    setlocal nonumber
    setlocal norelativenumber
    setlocal wrap
endfunction
augroup terminal
    autocmd!
    autocmd TermOpen * call TerminalSettings()
augroup END

" Text-based buffer settings
augroup textBuffers
    autocmd!
    autocmd BufReadPost *
        \ if &filetype == "text" || &filetype == "markdown"
        \ |     setlocal wrap
        " \ |     setlocal nolist
        \ |     setlocal nonumber
        \ |     setlocal norelativenumber
        \ | endif
augroup END

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid, when inside an event handler
" (happens when dropping a file on gvim) and for a commit message or
" Fugitive status buffer.
augroup vimStartup
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") >= 0 && line("'\"") <= line("$") &&
        \ &filetype != "gitcommit" && &filetype != "fugitive"
        \ |   execute ("normal `\"")
        \ | endif
augroup END

" No need for vim-highlightedyank, Neovim supports it natively
augroup hightlightedyank
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=400})
augroup END

"========Keybindings========

" Set leader to space
let mapleader = " "

" Use kj to return to normal mode
inoremap kj <Esc>
vnoremap kj <Esc>
" <C-c> is required for cmd mode as mappings w/ <Esc> trigger the current cmd
cnoremap kj <C-c>

" Remap Ctrl-w window commands to Leader-w for quicker access
nnoremap <Leader>w <C-w>

" Close the current buffer without closing the window/split
noremap <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Windows terminal takes away <C-v> for visual block, rebind to leader
nnoremap <leader>v <C-v>

" Map ranger to <leader>r instead of <leader>f
noremap <leader>r :RnvimrToggle<CR>

"Git bindings - <leader>g(it)
nnoremap <leader>gs <cmd>Git<cr>
nnoremap <leader>gb <cmd>Git blame<cr> 
nnoremap <leader>ghp <cmd>GitGutterPreviewHunk<cr>
nnoremap <leader>ghs <cmd>GitGutterStageHunk<cr>

" Telescope bindings - <leader>f(ind)
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>f; <cmd>Telescope commands<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
nnoremap <leader>fc <cmd>Telescope colorscheme<cr>

" Critically important duck mappings
lua vim.keymap.set('n', '<leader>dd', function() require("duck").hatch("🦆", 5) end, {desc = "hatch a duck"})
lua vim.keymap.set('n', '<leader>dg', function() require("duck").hatch("🦍", 10) end, {desc = "hatch a gorilla"})
lua vim.keymap.set('n', '<leader>dk', function() require("duck").cook() end, {desc = "cook a duck"})
