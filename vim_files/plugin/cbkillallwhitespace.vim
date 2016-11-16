"Simple function for removing all whitespace
"after the last printable character
"
"Operates on all lines in an entire buffer

"TODO: Make so this can work on a visual selection or a range
function! g:CbKillExtraWhitespace()

    "Get a list of all lines in the buffer
    let l:listOfBufLines = getline(1,"$")

    let l:listOfBufLines = map(copy(l:listOfBufLines) , 'substitute(v:val, "\\s\\+$", "", "" )')

    "Loop through and replace lines
    let l:lineCount = 1
    for l:currLine in l:listOfBufLines
        "Update our buffer
        call setline(l:lineCount, l:currLine)
        let l:lineCount = l:lineCount + 1
    endfor

endfunction
