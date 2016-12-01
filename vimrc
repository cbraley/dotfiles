"Vim please; not vi...
set nocompatible

"Use ',' as the "leader" key; not '\'
let mapleader = ","

"Helpers for editing and sourcing ~/.vimrc
nmap <silent> <leader>ev :tabnew $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"Helpers for looking up documentation in Dash.
nmap <silent> <leader>d <Plug>DashSearch

" Clang format mappings
" Use ctrl-K or use LEADER f c to Format Code (FC)
map <C-K> :pyf ~/tools/clang-format.py<CR>
imap <C-K> <ESC>:pyf ~/tools/clang-format.py<CR>
nmap <silent> <leader>fc :pyf ~/tools/clang-format.py<CR>

" Clang include fixer.
"noremap <leader>cf :pyf /google/data/ro/projects/cymbal/tools/include-fixer/clang-include-fixer.py<cr>
"noremap <C-I> :pyf /google/data/ro/projects/cymbal/tools/include-fixer/clang-include-fixer.py<cr>

" Fix deps for blaze and includes (slow)
" Fix It All.
"noremap <leader>fia :pyf /google/data/ro/projects/cymbal/tools/include-fixer/clang-include-fixer.py<cr>:BlazeDepsUpdate<cr>

" Turn off swap files
set noswapfile

set cursorline
set cursorcolumn

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

",kew = kill extra whitespace
nmap <silent> <leader>kew <ESC>:KillExtraWhiteSpace<CR>

" Markdown file support.
autocmd BufNewFile,BufRead *.md setfiletype markdown

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

"Maximize current split
map <C-M-F2> <C-w>=

"Word cycling
map <S-Left> <C-Left>
map <S-Right> <C-Right>

" map <F7> to toggle NERDTree window
map <silent><F7> :NERDTreeToggle<CR>
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
set relativenumber
nmap <silent> <leader>tns <ESC>:call NumberToggle()<ESC><CR>

"Show the title in the console title bar.
set title

"Don't wrap lines
set nowrap

"Show status line always
set ls=2

"Highlight searches
set hlsearch

"2 line high command section
set cmdheight=2

" Integration with make
set makeprg=make

"Indenting options for C/C++
set autoindent
set smartindent
set t_Co=256

"Set all tabs to 2 spaces
"but NOT in makefiles since in a Makefile you need tabs
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
autocmd FileType make setlocal noexpandtab

" Set VIM statusline to be more informative.
" "[<file type>] column:<column_num> filename:<line_number>
set statusline=%y\ %f:%04l\ %=col=%03c,line=%03l

" USe a custom function to render each tab text.
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
endif
filetype plugin indent on
syntax on
