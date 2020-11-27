source ~/.vimcommon

set ttymouse=sgr

"Set shell
if executable("zsh")
    set shell=zsh
endif

" Switch between tabs
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt

" Select all text
noremap vA ggVG

"Mode Settings
set cursorline

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[3 q" "SR = REPLACE mode
let &t_EI.="\e[2 q" "EI = NORMAL mode (ELSE)
" ========== Cursor settings: ===============
" {{{
"  1 -> blinking block
"  2 -> solid block 
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar

if has("autocmd") && $GNOME_SHELL_SESSION_MODE != ""
  " echo "Changing cursors in GNOME SHELL"
  au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
  au InsertEnter,InsertChange *
    \ if v:insertmode == 'i' | 
    \   silent execute '!echo -ne "\e[5 q"' | redraw! |
    \ elseif v:insertmode == 'r' |
    \   silent execute '!echo -ne "\e[3 q"' | redraw! |
    \ endif
  au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
endif
" }}}
" ========== END Cursor settings ==============

" copy (write) highlighted text to .vimbuffer
vmap <C-S-c> y:new ~/.vimbuffer<CR>VGp:x<CR> \| :!cat ~/.vimbuffer \| clip.exe <CR><CR>
" paste from buffer
map <C-S-v> :r ~/.vimbuffer<CR>

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

set clipboard=unnamedplus " save to system clipboard
syntax on

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

set encoding=utf-8

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
    "set guifont=DejaVuSansMono_NF:h9:cEASTEUROPE:qDRAFT 
    colorscheme colorsbox-stbright
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
  " Causes some problems in gitguttter and do not need it
  " augroup AutoChdir
  "   autocmd!
  "   autocmd BufEnter * if &buftype != 'terminal' | lcd %:p:h | endif
  " augroup END

  " Put these in an autocmd group, so that we can delete them easily.
  augroup mysettings
    au FileType xslt,xml,css,html,xhtml,javascript,sh,config,c,cpp,docbook set smartindent shiftwidth=2 softtabstop=2 expandtab
    au FileType tex set wrap shiftwidth=2 softtabstop=2 expandtab

    " Confirm to PEP8
    au FileType python set tabstop=4 softtabstop=4 expandtab shiftwidth=4 cinwords=if,elif,else,for,while,try,except,finally,def,class
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
if has("win32")
    if !filereadable(expand('$HOME\vimfiles\autoload\plug.vim'))
      echo "plug.vim is not installed , installing"
      let current_shell = &shell
      echo "Current shell is " current_shell
      set shell=powershell
      silent !"iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |` ni $HOME/vimfiles/autoload/plug.vim -Force"
      let &shell=current_shell
    endif
elseif empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
" LSP testing
" Plug 'dense-analysis/ale'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'ajh17/vimcompletesme'
Plug 'ap/vim-css-color'
Plug 'machakann/vim-highlightedyank'
Plug 'dbeniamine/cheat.sh-vim'
Plug 'tpope/vim-obsession'
Plug 'fedorenchik/qt-support.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'itchyny/lightline.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" {{{
  nnoremap <silent> <leader>f   :Files<CR>
  nnoremap <silent> <leader>gf   :GFiles<CR>
  nnoremap <silent> <leader>b   :Buffers<CR>
  nnoremap <silent> <leader>?  :History<CR>
  nnoremap <silent> <leader>bl   :BLines<CR>
  nnoremap <silent> <leader>l   :Lines<CR>
  nnoremap <silent> <leader>c   :Commits<CR>
  nmap <silent> cc :Commands!<CR>
" }}}
Plug 'scrooloose/nerdtree'
" {{{
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeWinSize = 31
  let g:NERDTreeChDirMode = 2
  let g:NERDTreeAutoDeleteBuffer = 1
  let g:NERDTreeShowBookmarks = 1
  let g:NERDTreeCascadeOpenSingleChildDir = 1

  " Check if NERDTree is open or active
  function! IsNERDTreeOpen()
    return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
  endfunction

  function! CheckIfCurrentBufferIsFile()
    return strlen(expand('%')) > 0
  endfunction

  " Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
  " file, and we're not in vimdiff
  function! SyncTree()
    if &modifiable && IsNERDTreeOpen() && CheckIfCurrentBufferIsFile() && !&diff
      NERDTreeFind
      wincmd p
    endif
  endfunction

  " Highlight currently open buffer in NERDTree
  autocmd BufRead * call SyncTree()

  function! ToggleTree()
    if CheckIfCurrentBufferIsFile()
      if IsNERDTreeOpen()
        NERDTreeClose
      else
        NERDTreeFind
      endif
    else
      NERDTree
    endif
  endfunction

  " open NERDTree with ctrl + n
  nmap <F3> :call ToggleTree()<CR>
  " }}}
Plug 'mhinz/vim-startify'
" {{{
  " remove cow header
  let g:startify_custom_header =['     >>>>  Startify VIM <<<<']
" }}}
Plug 'tpope/vim-commentary'
Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'powerline/powerline'
call plug#end()
let g:deoplete#enable_at_startup = 1

" Customizing signify
nnoremap <leader>gd :SignifyDiff<cr>
nnoremap <leader>gp :SignifyHunkDiff<cr>
nnoremap <leader>gu :SignifyHunkUndo<cr>

" hunk jumping
nmap <leader>gj <plug>(signify-next-hunk)
nmap <leader>gk <plug>(signify-prev-hunk)

" hunk text object
" omap ic <plug>(signify-motion-inner-pending)
" xmap ic <plug>(signify-motion-inner-visual)
" omap ac <plug>(signify-motion-outer-pending)
" xmap ac <plug>(signify-motion-outer-visual)

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
" command! -bang -nargs=? -complete=dir Files
"     \ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', 'bat --color=always --style=header,grid --line-range :300 {}']}, <bang>0)

" command! -bang -nargs=? -complete=dir GFiles
"     \ call fzf#vim#files(<q-args>, {'options': ['--info=inline', '--preview', 'bat --color=always --style=header,grid --line-range :300 {}']}, <bang>0)

" ~~~~~~~~~~~~~~~~~~ Session configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
let g:sessions_dir = '~/vim-sessions'
set sessionoptions-=blank

" Remaps for Sessions
exec 'nnoremap <Leader>ss :Obsession '. g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'



" ~~~~~~~~~~~~~~~~~~~~~~~~~ End Session configurations ~~~~~~~~~~~~~~~

" autocmd! " Remove ALL autocommands for the current group.
if executable('/home/codac-dev/Documents/clangd/build/bin/clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['/home/codac-dev/Documents/clangd/build/bin/clangd', '--background-index']},
                    \ 'whitelist': ['c', 'cpp'],
                    \ })
	autocmd FileType cpp setlocal omnifunc=lsp#complete
    augroup end
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
		setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    " nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
 
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" vim: set sw=2 ts=2 et foldlevel=0 foldmethod=marker:
