"Vim please; not vi...
set nocompatible

"Use ',' as the "leader" key; not '\'
let mapleader = ","

" ESC is too far away! Use a quick tap of jj to leave insert mode.
ino jj <ESC>

"Helpers for editing and sourcing ~/.vimrc
" ,EV = [E]dit ~/.[v]imrc
nmap <silent> <leader>ev :tabnew $MYVIMRC<CR>
" ,SV = [S]ource ~/.[v]imrc
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" Clang format mappings
" Use ctrl-K or ,fc to [F]ormat [C]ode
map <C-K> :pyf ~/tools/clang-format.py<CR>
imap <C-K> <ESC>:pyf ~/tools/clang-format.py<CR>
" ,FC = [F]ormat [C]code.
nmap <silent> <leader>fc :pyf ~/tools/clang-format.py<CR>

" Turn off swap files
set noswapfile

" Only show curorcolumn highlight in the active window.
augroup HighlightActive
  autocmd!
  autocmd WinEnter * set cursorcolumn
  autocmd WinEnter * set cursorline

  autocmd WinLeave * set nocursorcolumn
  autocmd WinLeave * set nocursorline
augroup END

" Highlight column 81.
let &colorcolumn=join([81],",")

"Wildmenu controls filename autocompletion.
set wildmode=longest:list,full
set wildmenu

" Enable click support.
set mouse=a

" Don't do line wrapping.
set nowrap

"F6 to compile latex documents.
function! CompileTheLatex()
  "Get input and output names
  "Assume only 1 .tex file, no bibliography, and an output file with the
  "same name as the tex file
  let inTex = bufname("%")
  let outPdf = inTex[:len(inTex)-4] . "pdf"
  echo "Compiling " inTex " to produce " outPdf

  "Execute as an ex mode command
  :execute "!latex " inTex "&& pdflatex " inTex " && evince -s " outPdf
endfunction
map <F6> <ESC>:call CompileTheLatex()<CR><ESC>:echo "Compiled the latex!"<CR>

"Set my color scheme
set t_Co=256 "My terminal has 256 colors

"Good color schemes
set background=dark
let DFLT_COLOR_SCHEME = "thezone"

"Shift + F11 = Cycle color schemes.
map <C-F11> <ESC>:call CycleColorScheme(1)<CR><ESC>:echo g:colors_name<CR>
map <S-F11> <ESC>:call CycleColorScheme(0)<CR><ESC>:echo g:colors_name<CR>
map <A-F11> <ESC>:call PrintColorSchemeList()<CR>
map <leader>rcs :call RandomColorScheme(1)<CR><ESC>:echo g:colors_name<CR>

"F4 = Toggle external paste mode.
noremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>

"F5 = turn on and off spell check.
map <F5> <ESC>:call ToggleSpellCheck()<CR>
command! ToggleSpellCheck call ToggleSpellCheck()

"Shift+F9 = kill extra whitespace function.
command! KillExtraWhiteSpace call g:CbKillExtraWhitespace()
map <S-F9> <ESC>:KillExtraWhiteSpace<CR>

" F12 = clear previous searches.
map <F12> <esc> :noh<return>

",kew = [K]ill [E]xtra [W]hitespace
nmap <silent> <leader>kew <ESC>:KillExtraWhiteSpace<CR>

" Markdown file support.
autocmd BufNewFile,BufRead *.md setfiletype markdown

" https://github.com/timheap/.dot-files/blob/master/docs/tmux-vim-console.md
if &term =~ '256color'
    " Disable Background Color Erase (BCE) so that color schemes work
    " properly when Vim is used inside tmux and GNU screen.
    " See also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif
if &term =~ '^screen'
    " Page up/down keys
    " http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
    execute "set t_kP=\e[5;*~"
    execute "set t_kN=\e[6;*~"

    " Home/end keys
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>

    " Arrow keys
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif


" Window resizing mappings
"Inspired by: http://vim.wikia.com/wiki/Fast_window_resizing_with_plus/minus_keys
" Maps Ctrl-F1-F4 to split resizing; use Ctrl for more granularity
map <C-S-F1> <ESC><C-w>15+
map <C-S-F2> <ESC><C-w>15-
map <C-S-F3> <ESC><C-w>15>
map <C-S-F4> <ESC><C-w>15<
"More granular
map <C-F1> <ESC><C-w>1+
map <C-F2> <ESC><C-w>1-
map <C-F3> <ESC><C-w>1>
map <C-F4> <ESC><C-w>1<

"Cycle through active splits
map <C-M-F1> <C-w>w

"Cycle through active tabs with ctrl-w [ to move left and ctrl-w ] to move
"right.
map <C-w>[ :tabprevious<CR>
map <C-w>] :tabnext<CR>

"Maximize current split
map <C-M-F2> <C-w>=

"Word cycling
map <S-Left> <C-Left>
map <S-Right> <C-Right>

" map <F7> to toggle NERDTree window
map <silent><F7> <plug>NERDTreeTabsToggle<CR>
" autochdir will open nerdtree in the directory of the active buffer.
set autochdir

"Toggle spell check on and off using F5
let g:spellOn = 0
function! ToggleSpellCheck()
  if g:spellOn == 0
    setlocal spell! spelllang=en_us
    echo "Spell check on, use z to suggest words."
    let g:spellOn = 1
  else
    setlocal nospell
    echo "Spell check off."
    let g:spellOn = 0
  endif
endfunction

syntax enable

" Syntax highlighting for GLSL shaders.
autocmd BufNewFile,BufRead *.vp,*.fp,*.gp,*.vs,*.fs,*.gs,*.tcs,*.tes,*.cs,*.vert,*.frag,*.geom,*.tess,*.shd,*.gls,*.glsl set ft=glsl450

".def should be highlighted like Python files.
au BufNewFile,BufRead *.def set filetype=python

"Better locating of C++ comments
"got this on the internet somewhere...
set comments=sl:/*,mb:\ *,elx:\ */

" Visually display current mode.
set showmode

"Only use case sensitive search when search string has uppercase letters.
set ignorecase
set smartcase

"Include whitespace in word selections.
set aw

"Show cursor position.
set ruler

"Enable backspace in insert mode.
set bs=2

"Dark BG by default
set background=dark

"Show line numbers.
set number

" Use relative line numbers. Toggle this with ,tns.
" TNS = [T]oggle line [N]umber [S]ettings.
let g:relative_num_on = 1
function! NumberToggle()
  if g:relative_num_on == 1
    set norelativenumber
    let g:relative_num_on = 0
    echo "Relative number is off"
  else
    set relativenumber
    let g:relative_num_on = 1
    echo "Relative number is on"
  endif
endfunc
nmap <silent> <leader>tns <ESC>:call NumberToggle()<ESC><CR>

" Misc helper key mappings.
" Leader + s + r will being up a search and replace dialog using the current
" word under the cursor.
" SR = [S]earch and [R]eplace.
:nnoremap <Leader>sr :%s/\<<C-r><C-w>\>/<C-r><C-w>/gci

"Disable Ex mode.
nnoremap Q <nop>

"Show the title in the console title bar.
set title

"Don't wrap lines
set nowrap

"Show status line always
set ls=2

"Highlight searches
set hlsearch

" Use ,/ to un-highlight the search text.
nnoremap <silent> <Leader>/ :nohlsearch<CR>

" The mapping ,ht highlights the word under the cursor but does *not* move the
" view. HT = [H]ighlight [W]word.
:nnoremap <Leader>hw :let @/="<C-r><C-w>"<CR>

" Add the ability to copy and paste text into the OS's copy and paste buffer.

" ,pfc = [P]aste [F]rom [C]lipboard.
noremap <leader>pfc :r !xsel -o -b <CR>

" Use ,ytc in visual mode to copy the selection to the clipboard.
" TODO(cbraley): Use pbcopy on Mac.
" ,ytc = [Y]ank [T]o [C]lipboard.
function! CopyVisualSelectionToClipboard() range
    let n = @n
    silent! normal gv"ny
    echo "Copied selection to clipboard." . system("echo -n '" . @n . "' | xsel -i -b")
    let @n = n
    " bonus: restore the visual selection.
    normal! gv
endfunction
xnoremap <leader>ytc :call CopyVisualSelectionToClipboard()<CR>


"2 line high command section.
set cmdheight=2

" Integration with make.
set makeprg=make

"Indenting options for C/C++
set autoindent
set smartindent
set t_Co=256

"Set all tabs to 2 spaces
"but NOT in makefiles since in a Makefile you must use tabs.
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
autocmd FileType make setlocal noexpandtab

" Set VIM statusline to be more informative.
" "[<file type>] column:<column_num> filename:<line_number>
set statusline=%y\ %f:%04l\ %=col=%03c,line=%03l

" Use a custom function to render each tab text.
" Modified from:
" http://stackoverflow.com/questions/33710069/how-to-write-tabline-function-in-vim
" This shows all splits in the tab name.
set tabline=%!MyTabLine()  " Custom tab pages function.
function! MyTabLine()
  let s = ''
  " Loop through each tab page.
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#' " WildMenu
    else
      let s .= '%#Title#'
    endif
    " Set the tab page number (for mouse clicks).
    let s .= '%' . (i + 1) . 'T '
    " Set page number string.
    let s .= i + 1 . ''
    " Get buffer names and statuses.
    let n = ''  " temp str for buf names
    let m = 0   " &modified counter

    " Loop through each buffer in a tab.
    let buflist = tabpagebuflist(i + 1)
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        let n .= fnamemodify(bufname(b), ':t') . ', ' " pathshorten(bufname(b))
      endif
      if getbufvar(b, "&modified")
        let m += 1
      endif
    endfor  " End loop over buffers.

    "let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ', $', '', '')
    let n = '[' . n . ']'
    " Add modified label.
    if m > 0
      let s .= '+'
      "let s .= '[' . m . '+]'
    endif
    if i + 1 == tabpagenr()
      let s .= ' %#TabLineSel#'
    else
      let s .= ' %#TabLine#'
    endif
    " Add buffer names.
    if n == ''
      let s.= '[New]'
    else
      let s .= n
    endif
    " Switch to no underlining and add final space.
    let s .= ' '
  endfor
  let s .= '%#TabLineFill#%T'
  " right-aligned close button
  "if tabpagenr('$') > 1
  "  let s .= '%=%#TabLineFill#%999Xclose'
  "endif
  return s
endfunction


"------------------------------------------------------------------------------
"Color scheme related stuff
"------------------------------------------------------------------------------

let s:scheme = 0 "Current color scheme
function! CycleColorScheme(dir)
  "First clear the color scheme stuff
  hi clear

  let colFiles = system("ls ~/.vim/colors/*[.]vim")
  let cSchemeList = split(colFiles) "List of color schemes

  "Update color scheme index
  if a:dir > 0
    let s:scheme = s:scheme + 1
  else
    let s:scheme = s:scheme - 1
  endif

  "Clamp color scheme index
  if s:scheme >= len(cSchemeList)
    let s:scheme = 0
  elseif s:scheme < 0
    let s:scheme = len(cSchemeList) - 1
  endif

  "Apply new scheme
  let tempStr = matchstr(cSchemeList[s:scheme],"[^/]*[.]vim$")
  :execute "colorscheme " strpart(tempStr, 0, len(tempStr)-4)
  echo "Temp Str = " tempStr
endfunction

"Set a color scheme by name
function! SetColorScheme(name)
  :execute "colorscheme " a:name
endfunction
call SetColorScheme(DFLT_COLOR_SCHEME)

function! GenRand(maxVal)
  return localtime() % a:maxVal
endfunction

"Get a random color scheme
function! RandomColorScheme(dir)
  let colFiles = system("ls ~/.vim/colors/*[.]vim")
  let cSchemeList = split(colFiles) "List of color schemes

  "Update color scheme index
  let s:scheme = s:scheme + GenRand(len(cSchemeList))

  "Clamp color scheme index
  if s:scheme >= len(cSchemeList)
    let s:scheme = 0
  elseif s:scheme < 0
    let s:scheme = len(cSchemeList) - 1
  endif

  "Apply new scheme
  let tempStr = matchstr(cSchemeList[s:scheme],"[^/]*[.]vim$")
  execute "colorscheme " strpart(tempStr, 0, len(tempStr)-4)
endfunction

function! PrintColorSchemeList()
  let colFiles = system("ls ~/.vim/colors/*[.]vim")
  let cSchemeList = split(colFiles) "List of color schemes
  call map(cSchemeList, 'matchstr(v:val,"[^/]*[.]vim$")' )
  echo "Color Schemes: " cSchemeList
endfunction

"Highlight groups

" Highlight text like TODO, FIXME, WARNING, and ERROR
highlight SpecialText term=bold ctermbg=Yellow guibg=Yellow ctermfg=red guifg=red
call matchadd("SpecialText", "TODO.*")
call matchadd("SpecialText", "FIXME.*")
call matchadd("SpecialText", "WARNING.*")
call matchadd("SpecialText", "ERROR.*")
highlight ExtraSpace ctermfg=Red guifg=Red ctermbg=Red guibg=Red

" Source google-internal VIM functions if we are on a machine that has them.
set nocompatible
let google_vimrc = "/usr/share/vim/google/google.vim"
if filereadable(google_vimrc)
  execute "source" google_vimrc

  " Map ,cr to clang-rename.
  noremap <leader>cr :pyf /google/src/head/depot/google3/third_party/llvm/llvm/tools/clang/tools/clang-rename/clang-rename.py<cr>

  Glug youcompleteme-google
  " Try using clangd for faster completation:
  " https://g3doc.corp.google.com/devtools/c/g3doc/clangd/index.md?cl=head
  let g:ycm_use_clangd = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_always_populate_location_list = 1
  let g:ycm_complete_in_strings = 0
  "let g:ycm_clangd_binary_path='/usr/bin/clangd --index-service=blade:fozzie'

  " In vim versions >= 8 we can leave the "gutter" column on. In earlier
  " versions of vim YCM caused the "gutter" to flicker distractingly whenever
  " a compiler error was introduced.
  if v:version >= 8
    set signcolumn=yes
  elseif
    " Turn of YCM diagnostics in the gutter in older versions of Vim.
    let g:ycm_enable_diagnostic_signs=0
  endif

  Glug blaze plugin[mappings]='<leader>b'
endif
filetype plugin indent on
syntax on
