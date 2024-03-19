# Configure neovim (technically not home-config)

{ config, lib, pkgs, modulesPath, ... }:

let
    godot-nvim = pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "godot.nvim";
        version = "master";
        src = builtins.fetchGit {
            url = "https://github.com/habamax/vim-godot";
            ref = "master";
        };
    };
in {
    home-manager.users.dylan.home.file.".config/nvim/coc-settings.json".source =
        .config/nvim/coc-settings.json;
    # Technically "system-wide", but similar to home stuff in essence
    programs.neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        withPython3 = true;
        configure = {
            customRC = "
                set nocompatible
                set showmatch
                set ignorecase
                set mouse=a
                set hlsearch
                set incsearch
                set tabstop=4
                set shiftwidth=4
                set expandtab
                set autoindent
                set number
                set wildmode=longest,list
                set cc=100
                filetype plugin indent on
                syntax on
                set clipboard=unnamedplus
                filetype plugin on
                set cursorline
                set ttyfast
                set spell
                set noswapfile

                let g:zig_fmt_autosave = 0
                let g:vimtex_view_method = 'mupdf'

                \" Linting via ale
                let g:ale_linters = {
                    \\ 'python': [ 'pylint' ],
                    \\ 'vim': [ 'vint' ],
                    \\ 'cpp': [ 'clang' ],
                    \\ 'c': [ 'clang' ],
                    \\ 'haskell': [ 'hlint' ],
                    \\ 'cs': [ 'OmniSharp' ]
                \\}
                call ale#linter#Define('gdscript', {
                    \\ 'name': 'godot',
                    \\ 'lsp': 'socket',
                    \\ 'address': '127.0.0.1:6008',
                    \\ 'project_root': 'project.godot',
                \\})

                set splitright
                set splitbelow

                \" Latex completion
                call deoplete#custom#var('omni', 'input_patterns', {
                    \\ 'tex': g:vimtex#re#deoplete
                \\})

                \" Open file finder thing
                nnoremap ; :File<CR>

                \" Turn terminal to normal mode with escape
                tnoremap <Esc> <C-\\><C-n>

                \" Open terminal on Ctrl+n
                function! OpenTerminal()
                    split term://zsh
                    resize 10
                endfunction
                nnoremap <C-n> :call OpenTerminal()<CR>

                \" Color schemes
                if (has(\"termguicolors\"))
                    set termguicolors
                endif
                syntax enable

                \" Color scheme
                colorscheme dracula

                \" Configure nerd tree
                let g:NERDTreeShowHidden = 1
                let g:NERDTreeMinimalUI = 0
                let g:NERDTreeIgnore = []
                let g:NERDTreeStatusLine = ''
                nnoremap <silent> <C-b> :NERDTreeToggle<CR>

                \" Move between planes
                nnoremap <C-left> <C-w>h
                nnoremap <C-down> <C-w>j
                nnoremap <C-up> <C-w>k
                nnoremap <C-right> <C-w>l

                \" Create panes
                nnoremap <C-A-d> :sp<CR>
                nnoremap <C-A-r> :vs<CR>

                \" Quit out of vim completely
                nnoremap <C-x> :qa<CR>
                nnoremap <C-s> :w<CR>

                au VimEnter * NERDTree

                \" Vim jump to the last position when reopening a file
                if has(\"autocmd\")
                    au BufReadPost * if line(\"'\\\"\") > 0 && line(\"'\\\"\") <= line(\"$\")
                        \\| exe \"normal! g'\\\"\" | endif
                endif

                \" Load all the plugins now
                packloadall

                \" Load all the help tags now, after loading plugins
                silent! helptags ALL

                \" Start rust-tools
                lua require('rust-tools').setup({})

                \" Code folding
                set foldmethod=indent

                \" Media file viewing
                lua require('telescope').load_extension('media_files')

                \" C#
                \"lua require('lspconfig').omnisharp.setup { cmd = { '/run/current-system/sw/bin/OmniSharp', '--languageserver', '--hostPID', tostring(vim.fn.getpid()) } }
                lua require('lspconfig').csharp_ls.setup {}

                \" Godot
                let g:godot_executable = '/run/current-system/sw/bin/godot4'
                func! GodotSettings() abort
                    setlocal tabstop=4
                    nnoremap <buffer> <F4> :GodotRunLast<CR>
                    nnoremap <buffer> <F5> :GodotRun<CR>
                    nnoremap <buffer> <F6> :GodotRunCurrent<CR>
                    nnoremap <buffer> <F7> :GodotRunFZF<CR>
                endfunc
                augroup godot | au!
                    au FileType gdscript call GodotSettings()
                augroup end
            ";
            packages.myVimPackage = with pkgs.vimPlugins; {
                start = [
                    auto-pairs
                    ale
                    coc-git
                    coc-nvim
                    coc-rust-analyzer
                    deoplete-clang
                    deoplete-nvim
                    dracula-vim
                    godot-nvim
                    haskell-vim
                    lightline-vim
                    markdown-preview-nvim
                    nerdcommenter
                    nerdtree
                    nvim-lspconfig
                    plenary-nvim
                    popup-nvim
                    rust-tools-nvim
                    telescope-nvim
                    telescope-media-files-nvim
                    ultisnips
                    vim-devicons
                    vim-snippets
                    vim-startify
                    vimtex
                    zig-vim
                ];
            };
        };
    };
}

