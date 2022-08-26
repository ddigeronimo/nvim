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
Plug 'tpope/vim-surround'
" Hotkeys for commenting
Plug 'tpope/vim-commentary'
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
" Dynamic keybinding menus, ported from Emacs
Plug 'folke/which-key.nvim'
" Use ranger as a pop-up window via RPC
Plug 'kevinhwang91/rnvimr'
" Lightweight status line
Plug 'nvim-lualine/lualine.nvim'
" Completion engine
Plug 'hrsh7th/nvim-cmp'
" LSP integration for nvim-cmp
Plug 'hrsh7th/cmp-nvim-lsp'
" Snippet engine, also needed for cmp-nvim-lsp
Plug 'hrsh7th/vim-vsnip' 

" * Colorschemes *
Plug 'NLKNguyen/papercolor-theme'
Plug 'folke/tokyonight.nvim', { 'branch' : 'main' }

" * Dependencies *
" lua coroutines, needed for telescope among others
Plug 'nvim-lua/plenary.nvim'
" Faster native-compiled fzf implementation for telescope
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Icons for telescope, lualine, and other plugins
Plug 'kyazdani42/nvim-web-devicons'
" vsnip LSP integration, needed for cmp-nvim-lsp and vim-vimsnip to work together
Plug 'hrsh7th/vim-vsnip-integ'
call plug#end()

" Replace Netrw with Ranger
let g:rnvimr_enable_ex = 1 

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
lua require("cmp_config")

"========General settings========

" Use relative line numbers, but display the true number of the current line
set number
set relativenumber

" Colorscheme setup
if (has("termguicolors"))
    set termguicolors
    let g:tokyonight_style = "night"
    let g:tokyonight_italic_comments = 0
    let g:tokyonight_italic_keywords = 0
    colorscheme tokyonight
endif

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

" Use both the * and + registers - not sure I have system clipboard working
set clipboard+=unnamedplus

" Wait for half a second for keymap sequences (or to launch which-key)
set timeoutlen=500

" Share one statusline among all windows
set laststatus=3

" Terminal buffer specific settings
function! TerminalSettings()
    setlocal nonumber
    setlocal norelativenumber
    setlocal list
endfunction
augroup terminal
    autocmd!
    autocmd TermOpen * call TerminalSettings()
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
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
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
xnoremap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

" Windows terminal takes away <C-v> for visual block, so swap it to use the
" leader key
nnoremap <Leader>v <C-v>

" Map ranger to <Leader>r instead of <Leader>f
noremap <Leader>r :RnvimrToggle<CR>

"Git bindings - <Leader>g
nnoremap <Leader>gs <cmd>Git<cr>
nnoremap <Leader>ghp <cmd>GitGutterPreviewHunk<cr>
nnoremap <leader>ghs <cmd>GitGutterStageHunk<cr>

" Telescope bindings
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>f; <cmd>Telescope commands<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>
nnoremap <leader>fo <cmd>Telescope oldfiles<cr>
" Break with leader-f for theme binding from VSCode
nnoremap <C-k><C-t> <cmd>Telescope colorscheme<cr>
