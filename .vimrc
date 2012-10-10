
"ignored if we are not on debian
runtime! debian.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" inspired by: 
"   https://github.com/amix/vimrc
"
"     > yankring.vim - http://www.vim.org/scripts/script.php?script_id=1234
"       Emacs's killring, useful when using the clipboard:
"
"     > surround.vim - http://www.vim.org/scripts/script.php?script_id=1697
"       Makes it easy to work with surrounding text:
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader = ","
let g:mapleader = ","

let s:remember_session=0
"set runtimepath+=$VIMRUNTIME

"==============================================================================
" vundle   https://github.com/gmarik/vundle/
"==============================================================================
"     :BundleList          - list configured bundles
"     :BundleInstall(!)    - install(update) bundles
"     :BundleSearch(!) foo - search(or refresh cache first) for foo
"     :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
set nocompatible               " be iMproved
filetype off                   " required!

set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'kien/ctrlp.vim'

filetype plugin indent on     " required!


fun! IsWindows()
    return has('win32') || has('win64')
endfun

fun! IsMac()
    return has('gui_macvim')
endfun

" 'is GUI' means vim is _not_ running within the terminal.
" sample values:
"   &term  = win32 //vimrc running in cygwin terminal
"   $TERM  = xterm-color , cygwin
"   &term  = builtin_gui //*after* vimrc but *before* gvimrc
"   &shell = C:\Windows\system32\cmd.exe , /bin/bash
fun! IsGui()
    return has('gui_running') || strlen(&term) == 0 || &term == 'builtin_gui'
endfun

" 'has GUI' means vim is "gui-capable"--but we may be using gvim/macvim from within the terminal.
fun! HasGui()
    return has('gui')
endfun

set showcmd     	" Show (partial) command in status line.
"set autowrite		" Automatically save before commands like :next and :make
set hidden          " Allow buffer switching even if unsaved 
set mouse=a     	" Enable mouse usage (all modes)



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sets how many lines of history VIM has to remember
set history=700

" Set to auto read when a file is changed from the outside
"set autoread

" Fast saving
nmap <leader>w :w!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set 7 lines to the curors - when moving vertical..
set so=7

set wildmode=full
set wildmenu
set ruler 
set cmdheight=2 "The commandbar height

" Set backspace config
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set ignorecase "Ignore case when searching
set smartcase
set hlsearch "Highlight search matches
set incsearch "Make search act like search in modern browsers
set nolazyredraw "Don't redraw while executing macros 

set magic "Set magic on, for regular expressions

set showmatch "Show matching brackets when text indicator is over them
set mat=2 "How many tenths of a second to blink

" No sound on errors
set noerrorbells
set novb t_vb=
set tm=500


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nonumber
set background=dark
set showtabline=1

if has("syntax")
    syntax enable "Enable syntax highlighting
endif

if HasGui() && IsGui() 
    "no toolbar
    set guioptions-=T
    set t_Co=256
endif

" platform-specific settings
if IsWindows()
    set gfn=Consolas:h10

    if IsWindows()
        " expects &runtimepath/colors/{name}.vim.
        colorscheme molokai
    endif
else
    if IsMac()
        " Use option (alt) as meta key.
        set macmeta

        if IsGui()
            " macvim options  :view $VIM/gvimrc
            let macvim_skip_colorscheme=1
            let macvim_skip_cmd_opt_movement=1

            " expects &runtimepath/colors/{name}.vim.
            colorscheme molokai
            "
            "set guifont=Monaco:h16
            set guifont=Menlo:h16

            let g:Powerline_symbols = 'unicode'
        endif
    elseif IsGui() "linux or other
        set gfn=Monospace\ 10
    endif
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "file type priority


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is source control anyway...
set nobackup

"Persistent undo
if IsWindows()
    if strlen($TEMP) && isdirectory($TEMP)
        set undodir=$TEMP
        set directory=$TEMP
    endif
else
    set undodir=~/.vim/undodir
    if !isdirectory(&undodir)
        set undodir=/tmp
    endif

    "set directory=~/.vim/swpdir
endif

set undofile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set formatoptions+=rn1

set expandtab
set shiftwidth=4
set tabstop=4
set smarttab

set linebreak "wrap long lines at 'breakat' character
set textwidth=500

set autoindent
set smartindent
set nowrap 
"set textwidth=80
set colorcolumn=80 "highlight the specified column
set cursorline     "highlight the current line

function! BreakBraces()
    :%s/{/{\r/g
    :%s/}/\r}\r/g
    :%s/;/;\r/g
endfunction

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" In visual mode, press * or # to search for the current selection
vnoremap * :call VisualSearch('f')<CR>
vnoremap # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // ./*.<left><left><left><left><left><left>


function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Command mode 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove the Windows ^M - when the encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

map <leader>pp :setlocal paste!<cr>
" Smart mappings on the command line
cno $h e ~/
cno $d e ~/Desktop/
cno $j e ./
cno $c e <C-\>eCurrentFileDir("e")<cr>

" $q is super useful when browsing on the command line
cno $q <C-\>eDeleteTillSlash()<cr>


func! DeleteTillSlash()
  let g:cmd = getcmdline()
  if IsWindows()
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
  else
    let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
  endif
  if g:cmd == g:cmd_edited
    if IsWindows()
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
    else
      let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
    endif
  endif   
  return g:cmd_edited
endfunc

func! CurrentFileDir(cmd)
  return a:cmd . " " . expand("%:p:h") . "/"
endfunc


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Close the current buffer
map <leader>bd :Bclose<cr>

" Close all the buffers
"map <leader>ba :1,300 bd!<cr>

" ctrl+arrow to switch buffers
map <c-right> :bn<cr>
map <c-left> :bp<cr>

" avoid annoying insert-mode ctrl+u behavior
imap <C-u> <Esc><C-u>

" Tab configuration
map <leader>tn :tabnew<cr>
map <leader>te :tabedit 
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove 

" switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>


command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction


""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
set laststatus=2 " Always show the statusline
let g:Powerline_stl_path_style = 'short'


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

function! StatuslineLineEndings()
    let l:line_ending_message = &ff
    if search('\r\n', 'nw') && (search('[^\n]\r$', 'nw') || search('[^\r]\n$', 'nw'))
        let l:line_ending_message = l:line_ending_message . ',mixed'
    endif
    return '['.l:line_ending_message.']'
endfunction


function! CurDir()
    let curdir = substitute(getcwd(), '/Users/justin/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
iab xdate <c-r>=strftime("%d/%m/%y %H:%M:%S")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Remap VIM 0
map 0 ^
"disable help key
noremap <F1> <ESC>
"inoremap jj <ESC>

"toggle/untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if IsMac()
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Cope
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Do :help cope if you are unsure what cope is. It's super useful!
map <leader>cc :botright cope<cr>
map <leader>n :cn<cr>
map <leader>p :cp<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Omni complete functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType css set omnifunc=csscomplete#CompleteCSS


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return 
au FileType python inoremap <buffer> $i import 
au FileType python inoremap <buffer> $p print 
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class 
au FileType python map <buffer> <leader>2 /def 
au FileType python map <buffer> <leader>C ?class 
au FileType python map <buffer> <leader>D ?def 


""""""""""""""""""""""""""""""
" => JavaScript section
"""""""""""""""""""""""""""""""
au FileType javascript call JavaScriptFold()
au FileType javascript setl fen
au FileType javascript setl nocindent

au FileType javascript imap <c-a> alert();<esc>hi

au FileType javascript inoremap <buffer> <leader>r return 
au FileType javascript inoremap <buffer> $f //--- PH ----------------------------------------------<esc>FP2xi

function! JavaScriptFold() 
    setl foldmethod=syntax
    setl foldlevelstart=1
    syn region foldBraces start=/{/ end=/}/ transparent fold keepend extend

    function! FoldText()
    return substitute(getline(v:foldstart), '{.*', '{...}', '')
    endfunction
    setl foldtext=FoldText()
endfunction


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctrlp
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildignore+=*.o,*.obj,.git,*.pyc,*/tmp/*,*.so,*.swp,*.zip,*.exe

if IsWindows()
    set wildignore+=.git\\*,.hg\\*,.svn\\*,Windows\\*,Program\ Files\\*,Program\ Files\ \(x86\)\\* 
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/* 
endif

let g:ctrlp_cmd = 'CtrlPMixed' 
let g:ctrlp_extensions = ['tag', 'buffertag']
if IsWindows()
    let g:ctrlp_buftag_ctags_bin = '~/bin/ctags.exe'
endif

" CtrlP auto-generates exuberant ctags for the current buffer!
nnoremap <m-p> :CtrlPBufTagAll<cr> 

let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.cache$|AppData\|eclipse_workspace', 
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pdf$|\.regtrans-ms$\|\.blf$\|\.dat$\|ntuser',
  \ 'link': 'some_bad_symbolic_links',
  \ }


function! ScrubPath(path)
    let b:path=a:path

    if IsWindows()
        let b:path = substitute(b:path, '/', '\', 'g')
    "assume that paths have slashes; only scrub for Windows
    "else
    "    let b:path = substitute(b:path, '\', '/', 'g')
    endif

    return b:path
endfunction

" session  
"   http://vim.wikia.com/wiki/Go_away_and_come_back
function! GetSessionDir()
    "expand ~ to absolute path so that mkdir works on windows CMD
    "                     . substitute(getcwd(), 'C:', '/c', 'g')
    return ScrubPath(expand(expand("~/.vim/sessions"))) 
endfunction

function! SaveSession()
  "disable session save/load for CLI
  if !HasGui() || !IsGui()
    return
  endif

  let b:sessionfile = ScrubPath(GetSessionDir() . "/session.vim")

  if (filereadable(b:sessionfile))
    let b:sessionfile_bk = b:sessionfile . '.' . strftime("%Y-%m-%d") . '.bk'
    echo b:sessionfile_bk
    if IsWindows()
        exe 'silent !copy ' . b:sessionfile . ' ' . b:sessionfile_bk
    else
        exe 'silent !cp ' . b:sessionfile . ' ' . b:sessionfile_bk
    endif
  endif

  if (filewritable(GetSessionDir()) != 2)
    if IsWindows()
        exe 'silent !mkdir ' . GetSessionDir()
    else
        exe 'silent !mkdir -p ' . GetSessionDir()
    endif
    redraw!
  endif

  exe "mksession! " . b:sessionfile
endfunction

function! LoadSession()
  "disable session save/load for CLI
  if !HasGui() || !IsGui()
    return
  endif

  let b:sessionfile = GetSessionDir() . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction


" Auto Commands
if has("autocmd")
    " Jump to the last position when reopening a file
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    if IsGui()
        set viminfo+=% "remember buffer list

        if !exists("s:remember_session") || s:remember_session != 0
            autocmd VimEnter * nested :call LoadSession()
            autocmd VimLeave * :call SaveSession()
        endif
    endif
endif

" always maximize GUI window size
if IsWindows()
    au GUIEnter * simalt ~x 
endif


" enforce black bg, etc.
highlight Normal ctermbg=black guibg=black 
highlight Normal ctermfg=white guifg=white 

"j,k move by screen line instead of file line
nnoremap j gj
nnoremap k gk

"disable F1 help key
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" Toggle hlsearch 
" nmap <silent> <leader>hs :set hlsearch! hlsearch?<CR>
nmap <silent> <leader>hs :noh<cr>

" Disable Ex mode shortcut
nmap Q <nop>

