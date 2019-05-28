
function! my#project#value(val) abort
  for [root, value] in projectionist#query(a:val)
    return value
    break
  endfor
endfunction


