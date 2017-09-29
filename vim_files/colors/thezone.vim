" Forked from vimicks.vim by cbraley

" Reset highlight to defaults {{{
set background=dark

highlight clear

if exists("sytax_on")
  syntax reset
endif
" }}}

" Set name
let g:colors_name="thezone"

" Highlight(group, ctermfg, ctermbg, cterm) {{{
function! Highlight(group, fg, bg, extra)
  let fg_tmp    = a:fg    >= 0 ? a:fg    : "NONE"
  let bg_tmp    = a:bg    >= 0 ? a:bg    : "NONE"
  let extra_tmp = a:extra >= 0 ? a:extra : "NONE"

  execute "highlight" a:group "ctermfg=" . fg_tmp "ctermbg=" . bg_tmp "cterm=" . extra_tmp
endfunction
" }}}

" Link(group, target) {{{
function! Link(group, target)
  execute "highlight link" a:group a:target
endfunction
" }}}

" Basics. ---------------------------------------------------------------------

" Normal text. Note that we use -1 here for the bg color since this will be
" 'transparent' and use the underlying terminal color.
call Highlight("Normal",         -1,  -1,     -1)
" Code comments.
call Highlight("Comment",       243,  -1,     -1)
" Folded sextions.
call Highlight("Folded",        243,  237,     -1)
call Highlight("FoldColumn"  ,  243,  237,     -1)

" Constants. ------------------------------------------------------------------
call Highlight("Constant",      214,   -1,     -1)
call Highlight("String",        220,   -1,     -1)
call Highlight("Character",     171,   -1,     -1)
call Highlight("Number",        214,   -1,     -1)
call Highlight("Boolean",       149,   -1,     -1)
call Highlight("Float",         227,   -1,     -1)

" Keywords. -------------------------------------------------------------------
call Highlight("Type",           67,   -1,     -1)
call Highlight("StorageClass",   71,   -1,     -1)
call Highlight("Identifier",     69,   -1,     -1)
call Highlight("Function",      117,   -1,     -1)
call Highlight("Statement",     149,   -1, "BOLD")
call Highlight("Conditional",   110,   -1, "BOLD")
call Highlight("Repeat",        110,   -1, "BOLD")
call Highlight("Todo",           88,   88, "BOLD")

" Cursor-Surrounding. --------------------------------------------------------
call Highlight("CursorLine",    -1,   238,     -1)
call Highlight("CursorColumn",  -1,   238,     -1)

" Environment
call Highlight("Cursor",        231,  160, "BOLD")
call Link("TermCursor", "Cursor")
call Link("TermCursorNC", "Cursor")

call Highlight("LineNr",        243,  237,     -1)
call Highlight("CursorLineNr",  148,  242,     -1)
call Highlight("Vertsplit",     148,  235,     -1)
call Highlight("MatchParen",    214,  148, "BOLD")

" Searches and selections. ---------------------------------------------------
call Highlight("Visual",        254,   27,     -1)
call Highlight("VisualNOS",     254,   27,     -1)
call Highlight("Search",        227,   94,     -1)


" Status line. ----------------------------------------------------------------
" Active status line.
call Highlight("StatusLine",     16,  149,     -1)
" Inactive status line.
call Highlight("StatusLineNC",  149,   16,     -1)
" Where it says "insert mode" or other mode status.
call Highlight("ModeMsg",         9,   16, "BOLD")

" Ctrl-N completion menu.. ---------------------------------------------------
call Highlight("PMenu",         149,  235,     -1)
call Highlight("PMenuSel",      235,  149,     -1)
call Highlight("PMenuSbar",     149,  235,     -1)
call Highlight("PMenuThumb",    149,  235,     -1)

" Tabs. -----------------------------------------------------------------------
" Each tab.
call Highlight("TabLine",       149,   16,     -1)
" The selected tab.
call Highlight("TabLineSel",     16,  149,     -1)
" The rest of the tab line (after the tabs).
call Highlight("TabLineFill",   237,  237,     -1)


" Miscellaneous ---------------------------------------------------------------
call Highlight("Todo",          227,   94, "BOLD")
call Link("EndOfBuffer", "Normal")
call Highlight("Title",          67,   -1,     -1)
call Link("htmlTagN", "htmlTagName")
call Highlight("PreProc",        67,   -1,     -1)

" Darken the background after column 80.
call Highlight("ColorColumn",    -1,   52,     -1)

" Error messages.
call Highlight("ErrorMsg",          -1,   166, -1)
call Highlight("Error",             -1,   166, -1)

" YouCompleteMe ----------------------------------------------------------------
call Highlight("YcmWarningSign",    -1,   202, -1)
call Highlight("YcmWarningLine",    -1,    88, -1)
call Highlight("YcmErrorSign",      -1,   166, -1)
call Highlight("YcmErrorLine",      -1,    88, -1)
call Highlight("YcmErrorSection",   -1,    88, -1)
call Highlight("YcmWarningSection", -1,    88, -1)
