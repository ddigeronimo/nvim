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
" Helpful functions on the bracket keys
Plug 'tpope/vim-unimpaired'
" Special Easymotion fork for vscode-neovim
Plug 'asvetliakov/vim-easymotion'
" Align text objects based on rules
Plug 'junegunn/vim-easy-align'
" Automatically close paired characters
Plug 'townk/vim-autoclose'
call plug#end()

"========General settings========

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
xnoremap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nnoremap ga <Plug>(EasyAlign)

" Windows terminal takes away <C-v> for visual block, so swap it to use the
" leader key
nnoremap <Leader>v <C-v>

" Special comment keybindings for vscode-neovim
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine
