source ~/.vimcommon
set ttymouse=sgr

" copy (write) highlighted text to .vimbuffer
vmap <C-S-c> y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!cat ~/.vimbuffer \| clip.exe <CR><CR>
" paste from buffer
map <C-S-v> :r ~/.vimbuffer<CR>

set clipboard=unnamed " save to system clipboard
syntax on
set autoread " detect when a file is changed

if !empty($CONEMUBUILD)
    set term=pcansi
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
    set bs=indent,eol,start
    colorscheme wombat256mod
else
    colorscheme colorsbox-stbright
endif

" reset to vim-defaults
if &compatible          " only if not set before:
  set nocompatible      " use vim-defaults instead of vi-defaults (easier, more user friendly)
endif

" display settings
set background=dark     " enable for dark terminals
set nowrap              " dont wrap lines
set scrolloff=2         " 2 lines above/below cursor when scrolling
set number              " show line numbers
set relativenumber      " show relative number
set showmatch           " show matching bracket (briefly jump)
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar
set wildmenu            " completion with menu
set wildignore=*.o,*.obj,*.bak,*.exe,*.py[co],*.swp,*~,*.pyc,.svn
set laststatus=2        " use 2 lines for the status bar
set matchtime=2         " show matching bracket for 0.2 seconds
set matchpairs+=<:>     " specially for html

" editor settings
set esckeys             " map missed escape sequences (enables keypad keys)
set ignorecase          " case insensitive searching
set smartcase           " but become case sensitive if you type uppercase characters
set smartindent         " smart auto indenting
set smarttab            " smart tab handling for indenting
set magic               " change the way backslashes are used in search patterns
set bs=indent,eol,start " Allow backspacing over everything in insert mode

set tabstop=2           " number of spaces a tab counts for
set shiftwidth=2        " spaces for autoindents
set expandtab           " turn a tabs into spaces

set fileformat=unix     " file mode is unix
"set fileformats=unix,dos    " only detect unix file format, displays that ^M with dos files

" system settings
set lazyredraw          " no redraws in macros
set confirm             " get a dialog when :q, :w, or :wq fails
set nobackup            " no backup~ files.
set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo file -- 20 jump links, regs up to 500 lines'
set hidden              " remember undo after quitting
set history=500         " keep 50 lines of command history
set mouse=a             " use mouse in visual mode (not normal,insert,command,help mode


" color settings (if terminal/gui supports it)
if &t_Co > 2 || has("gui_running")
  syntax on          " enable colors
  set hlsearch       " highlight search (very useful!)
  set incsearch      " search incremently (search while typing)
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
    set guifont=DejaVuSansMono_NF:h9:cEASTEUROPE:qDRAFT 
    colorscheme darkblue
  endif
endif

" paste mode toggle (needed when using autoindent/smartindent)
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

" Use of the filetype plugins, auto completion and indentation support
filetype plugin indent on

" file type specific settings
if has("autocmd")
  " For debugging
  "set verbose=9

  " if bash is sh.
  let bash_is_sh=1

  " change to directory of current file automatically
  autocmd BufEnter * lcd %:p:h

  " Put these in an autocmd group, so that we can delete them easily.
  augroup mysettings
    au FileType xslt,xml,css,html,xhtml,javascript,sh,config,c,cpp,docbook set smartindent shiftwidth=2 softtabstop=2 expandtab
    au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab

    " Confirm to PEP8
    au FileType python set tabstop=4 softtabstop=4 expandtab shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
  augroup END

  augroup perl
    " reset (disable previous 'augroup perl' settings)
    au!  

    au BufReadPre,BufNewFile
    \ *.pl,*.pm
    \ set formatoptions=croq smartindent shiftwidth=2 softtabstop=2 cindent cinkeys='0{,0},!^F,o,O,e' " tags=./tags,tags,~/devel/tags,~/devel/C
    " formatoption:
    "   t - wrap text using textwidth
    "   c - wrap comments using textwidth (and auto insert comment leader)
    "   r - auto insert comment leader when pressing <return> in insert mode
    "   o - auto insert comment leader when pressing 'o' or 'O'.
    "   q - allow formatting of comments with "gq"
    "   a - auto formatting for paragraphs
    "   n - auto wrap numbered lists
    "   
  augroup END


  " Always jump to the last known cursor position. 
  " Don't do it when the position is invalid or when inside
  " an event handler (happens when dropping a file on gvim). 
  autocmd BufReadPost * 
    \ if line("'\"") > 0 && line("'\"") <= line("$") | 
    \   exe "normal g`\"" | 
    \ endif 

endif " has("autocmd")

" Plugins "

" Install and run vim-plug on first run
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" LSP testing
    "Plug 'dense-analysis/ale'
    "Plug 'prabirshrestha/async.vim'
    "Plug 'prabirshrestha/vim-lsp'
    "Plug 'ajh17/vimcompletesme'
    Plug 'dbeniamine/cheat.sh-vim'
    Plug 'tpope/vim-obsession'
    Plug 'fedorenchik/qt-support.vim'
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
    Plug 'itchyny/lightline.vim'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'mhinz/vim-startify'
    Plug 'tpope/vim-commentary'
"    Plug 'terryma/vim-multiple-cursors'
call plug#end()

" Customizig LightLine
function! LightlineObsession()
  let s = ''
  if exists('g:this_obsession')
    let s .= '%#DiffChange#' " Use the "DiffAdd" color if in a session
  endif
  let s .= "%{ObsessionStatus()}"
  if exists('v:this_session') && v:this_session != ''
    let s:obsession_string = v:this_session
    let s:obsession_parts = split(s:obsession_string, '/')
    if len(s:obsession_parts) == 1
      " windows path seperator
      let s:obsession_parts = split(s:obsession_string, '\\')
    endif
    let s:obsession_filename = s:obsession_parts[-1]
    let s .= ' ' . s:obsession_filename
    " let s .= '%*' " Restore default color
  endif
  return s
endfunction

let g:lightline = {
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype'], 
      \              [ 'obsession' ]]
      \ },
      \ 'component_expand': {
      \   'obsession': 'LightlineObsession'
      \ },
    \ }

" FZF customization
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', 'bat {}']}, <bang>0)

" ~~~~~~~~~~~~~~~~~~ Session configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:sessions_dir = '~/vim-sessions'

" Remaps for Sessions
exec 'nnoremap <Leader>ss :Obsession '. g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'



" ~~~~~~~~~~~~~~~~~~~~~~~~~ End Session configurations ~~~~~~~~~~~~~~~

" autocmd! " Remove ALL autocommands for the current group.
if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd', '--background-index']},
                    \ 'whitelist': ['c', 'cpp'],
                    \ })
	autocmd FileType cpp setlocal omnifunc=lsp#complete
    augroup end
endif
