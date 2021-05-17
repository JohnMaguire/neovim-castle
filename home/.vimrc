" Swap, Backup, and Restore {{{
if !isdirectory($HOME . "/.vim")
    call mkdir($HOME . "/.vim")
endif
if !isdirectory($HOME . "/.vim/swp")
    call mkdir($HOME . "/.vim/swp", "", 0700)
endif
if !isdirectory($HOME . "/.vim/undo")
    call mkdir($HOME . "/.vim/undo", "", 0700)
endif

" Backups are for scrubs
set nobackup

" Move swap files out of project directory
set directory=~/.vim/swp/

" Save swap file frequently for faster vim-signify updates
set updatetime=100

" Save undo tree
set undodir=~/.vim/undo
set undofile

" Restore place in file on open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }}}

" Key Bindings & Movement {{{
" Set Leader key to comma
let mapleader=","
let localleader="\\"

" Edit / reload config
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>rv :source $MYVIMRC<CR>

" Clear search highlighting
nnoremap <Leader><Space> :nohlsearch<CR>

"" Exit insert mode with jk
inoremap jk <Esc>

" Use qq for recording and <Leader>q for playing macros
nnoremap <Leader>q @q

" Use <Leader>pp to turn paste mode on or off
nnoremap <Leader>pp :set paste! paste?<CR>

" Disable arrow keys
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>

" Move vertically by visual line (fix line wrapping)
noremap <expr> j v:count ? 'j' : 'gj'
noremap <expr> k v:count ? 'k' : 'gk'

" Super-H and Super-L (beginning / end of line)
noremap H ^
noremap L $

" Use space to show/hide folds
nnoremap <Space> za

" Don't yank to buffer when pasting over text
xnoremap p "_dP

" Open fzf / the silver searcher
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>a :Ag<CR>
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>t :Tags<CR>
" Git commands
nnoremap <Leader>gls :GFiles?<CR>
nnoremap <Leader>glg :Commits<CR>
nnoremap <Leader>gbl :BCommits<CR>

" Open / close NERDTree
noremap <Leader>j :NERDTreeToggle<CR>

" Open / close Tagbar
noremap <Leader>k :TagbarToggle<CR>

" Open / close undo tree
nnoremap <Leader>u :MundoToggle<CR>
" }}}

" Tab Settings {{{
" Visual spaces per tab
set tabstop=4

" Spaces inserted per tab
set softtabstop=4

" A level of indentation
set shiftwidth=4

" Expand tabs by default
set expandtab

" Smarter auto-indentation
set autoindent
" }}}

" Plugins {{{
" Install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
   silent !curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs
     \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
   autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Housekeeping {{{
" Start with some sensible defaults
Plug 'tpope/vim-sensible'

" Fix some issues with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
" }}}

" Utilities {{{
" Better undo history tree
Plug 'simnalamburt/vim-mundo'

" FS tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" fzf fuzzy file searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Tag tree
Plug 'majutsushi/tagbar'

" UNIX shell commands (Move, Mkdir, etc.)
Plug 'tpope/vim-eunuch'

" Git commands (Gblame, Gcommit, Gmove, etc.)
Plug 'tpope/vim-fugitive'

" Vim wiki
Plug 'vimwiki/vimwiki'

" Github Gist
Plug 'mattn/webapi-vim'
Plug 'mattn/vim-gist'
" }}}

" Theming {{{
" Solarized color scheme
Plug 'altercation/vim-colors-solarized'

" Nord color scheme
Plug 'arcticicestudio/nord-vim'

" Airline status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git markers next to line numbers
Plug 'mhinz/vim-signify'
" }}}

" Language support {{{
" The best linter / syntax checker for vim
Plug 'scrooloose/syntastic'

" Autocompletion
Plug 'ycm-core/YouCompleteMe', { 'do': './install.py --go-completer' }

" Golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" Python
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }

" Rust
Plug 'rust-lang/rust.vim'

" Javascript syntax and indentation
Plug 'pangloss/vim-javascript'

" JSX syntax hilighting / indentation
Plug 'maxmellon/vim-jsx-pretty'

" TOML syntax highlighting
Plug 'cespare/vim-toml'

" tmux syntax hilighting
Plug 'tmux-plugins/vim-tmux'
" }}}

call plug#end()
" }}}

" Plugin Configuration {{{
" Enable airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme = 'nord'

" Syntastic settings
let g:syntastic_check_on_wq = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_aggregate_errors = 1

" Enable Rust autoformatting
let g:rustfmt_autosave = 1

" JS-specific Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']

" Setup vimwiki
let wiki = {'path': '~/vimwiki'}
let g:vimwiki_list = [wiki]

" }}}

" Visual Settings {{{
" Set the title of the window to reflect file being edited
set title
set titlestring=VIM:\ %F

" Turn on column and line numbers
set ruler
set number

" Highlight current line
set cursorline

" Highlight search results
set hlsearch

" Turn off end of line wrapping
set nowrap

" Add statusbar to last buffer
set laststatus=2

" Turn off bell
set vb t_vb=

" Set color scheme
colorscheme nord
set termguicolors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" }}}

" Folding {{{
set foldenable

" Ten levels of fold shown by default
set foldlevelstart=10
set foldnestmax=10

" Use indentation for folding by default
set foldmethod=indent

" Only look for mode lines at end of file
set modelines=1
" }}}

" Project-specific settings {{{
" Run py.test when saving Cardinal unit tests
augroup RunPyTestCardinal
    autocmd! BufWritePost $HOME/src/Cardinal/**/test_*.py :!py.test
augroup END
" }}}

" Strip trailing whitespace on save
"
" Note: This is a pretty primitive way of doing this. For me, it works,
" because if I didn't intend to strip whitespace, I will just reset those
" parts of the file using Git. Many people would prefer to do this manually,
" and plugins like ntpeters/vim-better-whitespace will do this.
autocmd BufWritePre * :%s/\s\+$//e

" vim: foldmethod=marker:foldlevel=0
