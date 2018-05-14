" Enable modern Vim features not compatible with Vi spec.
set nocompatible

set clipboard=unnamedplus
set ruler number
set background=dark
set scrolloff=3 " prevent cursor from being less than 3 from the top or bottom of the screen
set hidden
"don't highlight EOL with $ in the vim-indentguides plugin
set listchars=precedes:»,extends:«
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

inoremap jk <Esc>
inoremap kj <Esc>
"this causes problems: inoremap <Esc> <Nop>

" <shift>+: is too hard to type. ; is nearly useless
nnoremap ; :
set mouse+=a
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

nnoremap <C-N> :bnext<CR>
nnoremap <C-P> :bprev<CR>
nnoremap ,d :Bdelete<CR>
nnoremap ,t :NERDTree<CR>
nnoremap ,f :NERDTreeFind<CR>

set tabstop=2
set shiftwidth=2

set completeopt-=preview
" don't hide " in json
let g:vim_json_syntax_conceal = 0
" the above doesn't work?
set conceallevel=0
" and neither does that :(
"

""""""""""" Plugin Configuration """"""""""""""

let g:ctrlp_map = '<Leader>p'
let g:ctrlp_cmd = 'CtrlP'

let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
      \ --ignore .git
      \ --ignore .svn
      \ --ignore .hg
      \ --ignore .DS_Store
      \ --ignore "**/*.pyc"
      \ --ignore .git5_specs
      \ --ignore review
      \ -g ""'

let g:go_disable_autoinstall = 1
let g:go_gocode_bin = 'gocode'


if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'ErichDonGubler/vim-sublime-monokai'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'scrooloose/nerdtree'

"typescript plugins
Plug 'leafgarland/typescript-vim'
"Plug 'Quramy/tsuquyomi'

Plug 'mhinz/vim-signify'
Plug 'Valloric/MatchTagAlways'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ConradIrwin/vim-bracketed-paste'

Plug 'posva/vim-vue'
"Plug 'jlanzarotta/bufexplorer'
"Plug 'ap/vim-buftabline'
Plug 'fatih/vim-go'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'thaerkh/vim-indentguides'

Plug 'dag/vim-fish'
Plug 'rust-lang/rust.vim'

Plug 'racer-rust/vim-racer'
let g:racer_cmd = "~/.cargo/bin/racer"

Plug 'moll/vim-bbye'

Plug 'atimholt/spiffy_foldtext'
let g:SpiffyFoldtext_format = "%c{ } ... %<%f{ }| %4n lines |=%l{/=}"
hi Folded ctermbg=0


call plug#end()

" My Syntastic configuration
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" My Powerline configuration
"Plugin 'Lokaltog/powerline'
"set rtp+=$HOME/.local/lib/python2.7/site-packages/powerline/bindings/vim/
" Always show statusline
set laststatus=2
" Use 256 colours (Use this setting only if your terminal supports 256 colours)
set t_Co=256
" Use truecolor only if your terminal can do RGB color
"set termguicolors

colorscheme sublimemonokai

" All of your plugins must be added before the following line.

" Enable file type based indent configuration and syntax highlighting.
" Note that when code is pasted via the terminal, vim by default does not detect
" that the code is pasted (as opposed to when using vim's paste mappings), which
" leads to incorrect indentation when indent mode is on.
" To work around this, use ":set paste" / ":set nopaste" to toggle paste mode.
" You can also use a plugin to:
" - enter insert mode with paste (https://github.com/tpope/vim-unimpaired)
" - auto-detect pasting (https://github.com/ConradIrwin/vim-bracketed-paste)
filetype plugin indent on
syntax on

