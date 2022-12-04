set nocompatible                                        " Disable compatibility with old vim
set showmatch
set ignorecase
set mouse=a
set hlsearch
set incsearch
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set number
set wildmode=longest,list                               " Bash-like tab completions
set cc=100
filetype plugin indent on
syntax on
set clipboard=unnamedplus
filetype plugin on
set cursorline
set ttyfast
set spell
set noswapfile

call plug#begin("~/.vim/plugged")
    Plug 'dracula/vim'                                  " Dark theme
    Plug 'scrooloose/nerdtree'                          " File explorer tree
    Plug 'ryanoasis/vim-devicons'                       " Dev icon support for nerdtree
    Plug 'SirVer/ultisnips'                             " Snippets engine
    Plug 'honza/vim-snippets'                           " Collection of snippets
    Plug 'preservim/nerdcommenter'                      " Easy way to comment out lines
    Plug 'mhinz/vim-startify'                           " Start page plugin
    Plug 'neoclide/coc.nvim', { 'branch': 'release' }   " Code completion engine

    " LaTeX stuff
    Plug 'lervag/vimtex'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

    " C/C++ Stuff
    Plug 'deoplete-plugins/deoplete-clang'
    Plug 'dense-analysis/ale'

    " Rust stuff:
    Plug 'neovim/nvim-lspconfig'
    Plug 'simrat39/rust-tools.nvim'

    Plug 'itchyny/lightline.vim'                        " Status bar

    " Better file finding:
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'

    " Godot
    Plug 'habamax/vim-godot'

    Plug 'jiangmiao/auto-pairs'                         " Add matching {}

    " Zig
    Plug 'ziglang/zig.vim'
call plug#end()

let g:zig_fmt_autosave = 0
let g:vimtex_view_method = 'mupdf'

" Configure C/C++ linting
let g:ale_linters = {
    \ 'python': ['pylint'],
    \ 'vim': ['vint'],
    \ 'cpp': ['clang'],
    \ 'c': ['clang']
\}

set splitright
set splitbelow

" Latex completion
call deoplete#custom#var('omni', 'input_patterns', {
      \ 'tex': g:vimtex#re#deoplete
      \})

" Open file finder thing
nnoremap ; :File<CR>

" Turn terminal to normal mode with escape
tnoremap <Esc> <C-\><C-n>

" Open terminal on Ctrl+n
function! OpenTerminal()
    split term://zsh
    resize 10
endfunction
nnoremap <C-n> :call OpenTerminal()<CR>

" Color schemes
if (has("termguicolors"))
    set termguicolors
endif
syntax enable

" Color scheme
colorscheme dracula

" Configure nerd tree
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 0
let g:NERDTreeIgnore = []
let g:NERDTreeStatusLine = ''
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Move between planes
nnoremap <C-left> <C-w>h
nnoremap <C-down> <C-w>j
nnoremap <C-up> <C-w>k
nnoremap <C-right> <C-w>l

" Create panes
nnoremap <C-A-d> :sp<CR>
nnoremap <C-A-r> :vs<CR>

" Quit out of vim completely
nnoremap <C-x> :qa<CR>
nnoremap <C-s> :w<CR>

au VimEnter * NERDTree

" Vim jump to the last position when reopening a file
if has("autocmd")
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal! g'\"" | endif
endif

" Load all the plugins now
packloadall

" Load all the help tags now, after loading plugins
silent! helptags ALL

" Start rust-tools
lua require('rust-tools').setup({})

" Code folding
set foldmethod=indent

