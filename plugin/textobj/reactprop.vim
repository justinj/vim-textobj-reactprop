" React Prop Text Object
" Requires https://github.com/kana/vim-textobj-user

" Given foo={bar}
" ar => |foo={bar}|
" ir => foo=|{bar}|

call textobj#user#plugin('reactprop', {
\   '-': {
\     '*sfile*': expand('<sfile>:p'),
\     'select-a-function': 's:ReactPropA',
\     'select-a': 'ar',
\     'select-i-function': 's:ReactPropI',
\     'select-i': 'ir',
\   },
\ })

function! s:ReactPropA()
  return s:ReactProp("before")
endfunction

function! s:ReactPropI()
  return s:ReactProp("after")
endfunction

function! s:ReactProp(when_to_get_position)
  let found = s:ToBeginningOfReactProp()
  if found

    if a:when_to_get_position == "before"
      let head_pos = getpos('.')
    endif

    " Jump to after the = sign
    normal! f=l

    if a:when_to_get_position == "after"
      let head_pos = getpos('.')
    endif

    let tail_pos = s:ToMatchingSurrounder()
    return ['v', head_pos, tail_pos]
  else
    return 0
  end
endfunction

let s:REACT_PROP_BEGINNING_RE = "\\s\\?\\<\\w\\+="
function! s:ToBeginningOfReactProp()
  " b = search backwards
  " c = accept a match at the cursor position
  " line(".") = stop after searching this line
  let result = search(s:REACT_PROP_BEGINNING_RE, "bc", line("."))
  if result == 0
    " We didn't find it searching backwards on this line, so try searching
    " forwards
    let result = search(s:REACT_PROP_BEGINNING_RE, "c", line("."))
  endif
  return result != 0
endfunction

function! s:ToMatchingSurrounder()
  " the character delimiting the value - either { or "
  let char_under_cursor = getline('.')[col('.')-1] 

  if char_under_cursor == "{"
    normal! %
  else
    normal! f"
  endif

  return getpos('.')
endfunction
