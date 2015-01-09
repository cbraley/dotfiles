"Vim please; not vi...
set nocompatible

" I use pathogen to install some plugins.
execute pathogen#infect()

"Use ',' as the "leader" key; not '\'
let mapleader = ","

"Helpers for editing and sourcing ~/.vimrc
nmap <silent> <leader>ev :tabnew $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

"Helpers for looking up documentation in Dash.
nmap <silent> <leader>d <Plug>DashSearch

"Yankring mapings
"nmap <silent> <leader>yrs :YRShow<CR>
"nmap <silent> <leader>yrc :YRClear<CR>

" Clang format mappings
" Use ctrl-K or use LEADER f c to Format Code (FC)
map <C-K> :pyf ~/tools/clang-format.py<CR>
imap <C-K> <ESC>:pyf ~/tools/clang-format.py<CR>
nmap <silent> <leader>fc :pyf ~/tools/clang-format.py<CR>

"Yankring config setup
"let g:yankring_min_element_length = 2 "Don't add single letter deletes to ring
"Default to let Ctrl->N and Ctrl->P cycle through the yankring

"CTags
nmap <silent> <leader>gc :!ctags -R *<CR>

" Turn off swap files
set noswapfile

set cursorline
set cursorcolumn

"Wildmenu is cool
set wildmode=longest,full
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
"calmar256-dark, lucius, mustang, camo, herald, xoria256
set background=dark
let DFLT_COLOR_SCHEME = "mustang"

"Cycle color schemes with F11
map <C-F11> <ESC>:call CycleColorScheme(1)<CR><ESC>:echo g:colors_name<CR>
map <S-F11> <ESC>:call CycleColorScheme(0)<CR><ESC>:echo g:colors_name<CR>
map <A-F11> <ESC>:call PrintColorSchemeList()<CR>
map <leader>rcs :call RandomColorScheme(1)<CR><ESC>:echo g:colors_name<CR>

"F4 = Toggle external paste mode
noremap <F4> :set invpaste paste?<CR>
set pastetoggle=<F4>

"F5 = turn on and off spell check
map <F5> <ESC>:call ToggleSpellCheck()<CR>
command! ToggleSpellCheck call ToggleSpellCheck()

"F9 = call custom autoindent function
command! AutoIndent call g:cbAutoIndent()
map <F9> <ESC>:AutoIndent<CR>

"Shift+F9 = kill extra whitespace function written by me
command! KillExtraWhiteSpace call g:cbKillExtraWhitespace()
map <S-F9> <ESC>:KillExtraWhiteSpace<CR>

"Also map ,kew to kill extra whitespace
nmap <silent> <leader>kew <ESC>:KillExtraWhiteSpace<CR>

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

"Better locating of C++ comments
"got this on the internet somewhere...
set comments=sl:/*,mb:\ *,elx:\ */

" Visually display current mode.
set showmode

"Only use case sensitive search when search string has uppercase letters.
set ignorecase
set smartcase

"Include whitespace in word selections
set aw

"Show cursor position
set ruler

"Enable backspace in  insert mode
set bs=2

"Dark BG by default
set background=dark

"Show line numbers
set number

"Show the title in the console title bar
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
"but NOT in makefile since in Makefile you need tabs
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
autocmd FileType make setlocal noexpandtab

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


" Identify lines that go over the 80 char limit.
highlight TooLong ctermfg=Red guifg=Red ctermbg=Black guibg=Black
call matchadd("TooLong", ".\{-80}.*")
" This matches a line longer than 80 chars
"2match TooLong /.\{-80}.*/

" This matches from chars [80-1000]
2match TooLong /\%<1000v.\%>80v/

highlight ExtraSpace ctermfg=Red guifg=Red ctermbg=Red guibg=Red
3match ExtraSpace /\s\+$/

"autocmd BufEnter * highlight TooLong ctermfg=Red guifg=Red ctermbg=Black guibg=Black
"autocmd BufEnter * call matchadd("TooLong", ".\{-80}.*")


