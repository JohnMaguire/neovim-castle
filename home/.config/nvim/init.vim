" Bootstrapping {{{
" Use system-wide Python in Neovim
let g:python_host_prog = '/usr/local/bin/python2'

" Detect OSX / Linux and set repositories location
if has("unix")
	let s:uname = substitute(system("uname -s"), '\n', '', '')
	if s:uname == "Darwin"
		let s:repo_dir = "/Users/jmaguire/Repositories"
	elseif s:uname == "Linux"
		let s:repo_dir = "/home/jmaguire/repos"
	endif
endif

" Install vim-plug for neovim
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Install vim-plug for vim
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}

" Key Bindings {{{
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
" }}}

" Movement {{{
" Move vertically by visual line (fix line wrapping)
noremap <expr> j v:count ? 'j' : 'gj'
noremap <expr> k v:count ? 'k' : 'gk'

" Super-H and Super-L (beginning / end of line)
noremap H ^
noremap L $

" ^ and $ are no longer needed
noremap ^ <nop>
noremap $ <nop>

" Disable arrow keys
noremap <Left> <nop>
noremap <Right> <nop>
noremap <Up> <nop>
noremap <Down> <nop>

" Don't yank to buffer when pasting over text
xnoremap p "_dP
" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" Start with some sensible defaults
Plug 'tpope/vim-sensible'

" Fix some issues with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'

" The best linter / syntax checker for vim
Plug 'scrooloose/syntastic'

" Vim wiki
Plug 'vimwiki/vimwiki'

" FS tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Undo history tree (better undo tree)
Plug 'simnalamburt/vim-mundo'

" fzf fuzzy file searching
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'

" Airline status bar, and solarized theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git commands (Gblame, Gcommit, Gmove, etc.)
Plug 'tpope/vim-fugitive'

" Git markers next to line numbers
Plug 'airblade/vim-gitgutter'

" Autocompletion (requires Python support)
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    !./install.py
  endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Show tags in file, ordered by scope
Plug 'majutsushi/tagbar'

" Golang settings
Plug 'fatih/vim-go'

" Rust
Plug 'rust-lang/rust.vim'

" TOML syntax highlighting
Plug 'cespare/vim-toml'

" Python indentation conforming to PEP-8
Plug 'Vimjas/vim-python-pep8-indent'

" tmux syntax hilighting
Plug 'tmux-plugins/vim-tmux'

" Updated PHP omnifunc
Plug 'shawncplus/phpcomplete.vim'

" Javascript syntax and indentation
Plug 'pangloss/vim-javascript'

" JSX syntax hilighting / indentation
Plug 'mxw/vim-jsx'

" Use local eslint over globally installed package
Plug 'mtscout6/syntastic-local-eslint.vim'

" Terraform syntax highlighting / formatting
Plug 'hashivim/vim-terraform'

call plug#end()
" }}}

" Plugin Configuration {{{
" Don't open a pane on YouCompleteMe autocompletion
autocmd CompleteDone * pclose

" Use goimports instead of gofmt
let g:go_fmt_command = "goimports"

" Enable Rust formatting
let g:rustfmt_autosave = 1

" Enable airline (and stop it from erroring on PHP docblocks)
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#mixed_indent_algo = 1

" Enable Powerline fonts and Solarized theme (Airline)
let g:airline_powerline_fonts = 1
let g:airline_theme = 'solarized'

" Syntastic settings
let g:syntastic_check_on_wq = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_aggregate_errors = 1

" PHP-specific Syntastic settings
let g:syntastic_php_checkers = ['php', 'phpcs', 'phpmd', 'phplint']
let g:syntastic_php_phpcs_args='--report=csv --standard=PSR2'

" JS-specific Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']

" Open fzf / the silver searcher
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>a :Ag<CR>

" Open / close NERDTree
noremap <Leader>j :NERDTreeToggle<CR>

" Open / close Tagbar
noremap <Leader>k :TagbarToggle<CR>

nnoremap <Leader>u :MundoToggle<CR>

" Terraform fmt on save
let g:terraform_fmt_on_save = 1

" Setup wiki
let wiki = {}
let wiki.path = '~/vimwiki/'
let g:vimwiki_list = [wiki]
" }}}

" Tab Settings {{{
" Visual spaces per tab
set tabstop=4

" Spaces inserted per tab
set softtabstop=4

" Don't expand tabs by default
set noexpandtab

" Smarter auto-indentation
set smartindent
set shiftwidth=4
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

" Turn off end of line wrapping
set nowrap

" Add statusbar to last buffer
set laststatus=2

" Turn off bell
set vb t_vb=

" Set color scheme to Solarized Dark
set background=dark
colorscheme solarized
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

" Use space to show/hide folds
nnoremap <Space> za
" }}}

" Swap, Backup, and Restore {{{
" Move swap files out of project directory
set directory=~/.config/nvim/swp/

" Backups are for scrubs
set nobackup

" Restore place in file on open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Save undo tree
set undodir=~/.config/nvim/undo
set undofile

if !isdirectory($HOME . "/.config/nvim")
	call mkdir($HOME . "/.config/nvim")
endif
if !isdirectory($HOME . "/.config/nvim/undo")
	call mkdir($HOME . "/.config/nvim/undo", "", 0700)
endif
" }}}

" Project-specific settings {{{
" Duo ignores E501 (line too long)
augroup DuoFlake8
	autocmd!
	autocmd BufEnter $HOME/src/Duo/* :let g:syntastic_python_flake8_args='--ignore=E501'
	autocmd BufLeave $HOME/src/Duo/* :silent! unlet g:syntastic_python_flake8_args
augroup END

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
