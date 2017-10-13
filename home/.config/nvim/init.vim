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

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" Fix some issues with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'

" The best linter / syntax checker for vim
Plug 'scrooloose/syntastic'

" FS tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Undo history tree (trust me on this one)
Plug 'sjl/gundo.vim'

" C-p fuzzy file searching (and fast with ctrl-py-matcher!)
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'

" Solarized color scheme
Plug 'altercation/vim-colors-solarized'

" Airline status bar, and solarized theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Git commands (Gblame, Gcommit, Gmove, etc.)
Plug 'tpope/vim-fugitive'

" Git markers next to line numbers
Plug 'airblade/vim-gitgutter'

" Autocompletion (requires Python 2.x support)
Plug 'Valloric/YouCompleteMe'

" Silver searcher command (Ag)
Plug 'rking/ag.vim'

Plug 'majutsushi/tagbar'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'ervandew/supertab'

" Golang settings
Plug 'fatih/vim-go'

" Python indentation conforming to PEP-8
Plug 'hynek/vim-python-pep8-indent'

" tmux syntax hilighting
Plug 'tmux-plugins/vim-tmux'

" Updated PHP omnifunc
Plug 'shawncplus/phpcomplete.vim'

" Make editing of salt files nicer
Plug 'saltstack/salt-vim'

" Javascript syntax and indentation
Plug 'pangloss/vim-javascript'

" JSX syntax hilighting / indentation
Plug 'mxw/vim-jsx'

" Use local eslint over globally installed package
Plug 'pmsorhaindo/syntastic-local-eslint.vim'

" Blade (Laravel templating) syntax highlighting / indentation
Plug 'jwalton512/vim-blade'

" LESS syntax hilighting / indentation
Plug 'groenewege/vim-less'

call plug#end()
" }}}

" Swap, Backup, and Restore {{{
" Move swap files out of project directory
set directory=~/.config/nvim/swp//

" Backups are for scrubs
set nobackup

" Restore place in file on open
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
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
"
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

" Key Bindings {{{
" Set Leader key to comma
let mapleader=","

" Use space to show/hide folds
nnoremap <Space> za

" Clear search highlighting
nnoremap <Leader><Space> :nohlsearch<CR>

" Reload config
nnoremap <Leader>r :source $MYVIMRC<CR>

" Open the silver search
nnoremap <Leader>a :Ag

" Bind NERDTree to C-j C-j
map <Leader>j :NERDTreeToggle<CR>

" Bind Tagbar to C-k C-k
map <Leader>k :TagbarToggle<CR>

" Exit insert mode with jk
inoremap jk <Esc>

" Move vertically by visual line (fix line wrapping)
nnoremap j gj
nnoremap k gk

" Don't yank to buffer when pasting over text
xnoremap p "_dP
" }}}

" Plugin Configuration {{{
" Don't open a pane on YouCompleteMe autocompletion
autocmd CompleteDone * pclose

" Let Supertab handle YCM (so UltiSnips works)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Set UltiSnips trigger config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

" Make :UltiSnipsEdit split the window
let g:UltiSnipsEditSplit="vertical"

" Enable goimports
let g:go_fmt_command = "goimports"

" Enable Go syntax hilighting
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" Gotags in Tagbar
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

" Use the silver searcher to generate our file list, and pymatcher for search
if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l -i --nocolor --nogroup --hidden
	    \ --ignore .git
	    \ --ignore .svn
	    \ --ignore .hg
	    \ --ignore .DS_Store
	    \ --ignore "*.min.js"
	    \ --ignore "*.min.map"
	    \ --ignore "**/*.pyc"
	    \ -g ""'
	let g:ctrlp_use_caching = 0
endif
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

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

" JS-specific Syntastic settings
let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_php_phpcs_args='--report=csv --standard=PSR2'
" }}}

" Strip trailing whitespace on save
"
" Note: This is a pretty primitive way of doing this. For me, it works,
" because if I didn't intend to strip whitespace, I will just reset those
" parts of the file using Git. Many people would prefer to do this manually,
" and plugins like ntpeters/vim-better-whitespace will do this.
autocmd BufWritePre * :%s/\s\+$//e
"
" vim: foldmethod=marker:foldlevel=0
