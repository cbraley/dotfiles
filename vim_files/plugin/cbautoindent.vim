"Constants

    "If any of these are found on a line decrease its indents by one
    let s:decIndentSpecialList = [ 'public:' , 'private:' , 'protected:' ]

    "Should we remove extra whitespace at EOL?
    let s:removeWhiteSpaceAtEOL = 1


"TODO: Accout for lines > 80 chars
"TODO: Help find mispaced brackets
"TODO: Account for being inside of comments like // and /* and inside literals like "something }"
"TODO: Include rules for what to do when a line wraps toa  second line
"TODO: Accout for array initializers



"This function takes a string theString which
"is a line of code.  The other argument, inABlockComment
"should be true if, upon entering the line we are in a 
"/*block comment*/, false otherwise
"
"This function returns a 2-element list, where the 
"first element is the number of }'s and the second
"is the number of }'s
"
function! GetBraceInfo(theString, inABlockComment)
    let l:idx = 0
    let l:currentlyInBlockComment = a:inABlockComment

    while l:idx < strlen(a:theString)
        let l:currChar = strpart(a:theString, l:idx, 1)    



        let l:idx = l:idx + 1
    endwhile

endfunction

"Cout the number of times a SINGLE CHARACTER toFind
"occurs in a string theString
"This WILL NOT WORK if toFind is > than one character
function! CountNumOccurances(theString, toFind)
    let l:startSearch = 0
    let l:count = -1
    while l:startSearch != -1
        let l:foundOne = stridx(a:theString, a:toFind, l:startSearch)

        if l:foundOne == -1
            let l:startSearch = -1
        else
            let l:startSearch = l:foundOne + 1
        endif
        let l:count = l:count + 1
    endwhile

    return l:count
endfunction






function! g:cbAutoIndent()

    "Get a list of all lines in the buffer
    let l:listOfBufLines = getline(1,"$")

    "Get the users current tabstop (the size of a single indent)
    let l:indentSize =  &ts "&ts gets tabstop...

    "Create a list that will contain indentation levels
    "negative means the line is empty
    "0 = no indent
    "+n = n * (indent_size)
    let l:indentAmts = []

    "Also, create a stack and push on numbers
    "If we find a { on line X we push X on to the stack
    "every time we find a } we pop the stack
    let l:braceStack = []

    "Loop through the list adding indents
    let l:indentLevel = 0
    let l:lineCount = 1
    for l:currLine in l:listOfBufLines

        let l:thisLinesIndentAmt = l:indentLevel

        "Note that here we don't count the line as a { line if there 
        "are comment chars before it...for instance:
        " //else{ 
        "would not count.


        if stridx(l:currLine, "{") >= 0 && stridx(l:currLine, "{") > stridx(l:currLine, "//")  
            echo "{ brace at line: " l:lineCount

            "Push onto stack
            let l:temp = 0
            while l:temp < CountNumOccurances(l:currLine, "{")
                call add(l:braceStack, l:lineCount)
                let l:temp = l:temp + 1
            endwhile

            let l:indentLevel = l:indentLevel + CountNumOccurances(l:currLine, "{")
        endif

        if stridx(l:currLine, "}") >= 0 && stridx(l:currLine, "}") > stridx(l:currLine, "//")  
            echo "} brace at line: " l:lineCount

            "Pop off of the stack
            let l:temp = 0
            while l:temp < CountNumOccurances(l:currLine, "}")

                "Check if stack is empty.  If it is, this indicates an error
                "of an unmatched ending brace at the current line
                if len(l:braceStack) == 0
                    echo "Error"
                    echo "The } at line"  l:lineCount  " was unmatched!"
                    return
                endif

                let l:popped =  remove(l:braceStack, len(l:braceStack) - 1)
                let l:temp = l:temp + 1
            endwhile

            let l:indentLevel = l:indentLevel - CountNumOccurances(l:currLine, "}")
            let l:thisLinesIndentAmt = l:thisLinesIndentAmt - CountNumOccurances(l:currLine, "}")
        endif


        "Add the current indent amount
        call add( l:indentAmts , l:thisLinesIndentAmt )

        let l:lineCount = l:lineCount + 1
    endfor

    "If we got here and the brace stack is not empty, we have an unmatched brace
    if len(l:braceStack) != 0
        echo "Error"
        echo "The following { braces were unmatched:"
        for l:badLine in l:braceStack
            echo "    The { " . " at line " . l:badLine . " was unmatched."
        endfor
    endif

    "Transform the line list to remove spaces
    let l:listOfBufLines = map(copy(l:listOfBufLines) , 'substitute(v:val, "^ \\+", "", "" )')


    "Transform the line list to remove extra spaces at the end of the line
    "if the user wants
    if s:removeWhiteSpaceAtEOL
        let l:listOfBufLines = map(copy(l:listOfBufLines) , 'substitute(v:val, " \\+$", "", "" )')
    endif

    "Remove whitespace from all VIM lines
    let l:count = 1
    for l:modCurrLine in l:listOfBufLines
        let l:currIndent = (l:indentAmts[l:count - 1]) * l:indentSize
        let l:indentedLine = l:modCurrLine

        "Change the indent for special cases
        for l:specialText in s:decIndentSpecialList
            if stridx(l:modCurrLine, l:specialText) == 0
                let l:currIndent = l:currIndent - l:indentSize
            endif
        endfor

        "Keep appending spaces until we dont need to
        "but don't do this for lines of all whitespace
        if l:indentedLine !~ '^\s*$'
            while l:currIndent > 0
                let l:indentedLine = ' ' . l:indentedLine
                let l:currIndent = l:currIndent - 1
            endwhile
        else
            let l:indentedLine = ""
        endif


        "Update our buffer
        call setline(l:count, l:indentedLine)

        "inc count
        let l:count = l:count + 1
    endfor

endfunction
