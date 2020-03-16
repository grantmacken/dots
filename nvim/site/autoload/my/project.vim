
function! my#project#value(val) abort
  for [root, value] in projectionist#query(a:val)
    return value
    break
  endfor
endfunction

function! my#project#paths() abort
 return system("cut -d: -f1 /etc/passwd")
endfunction


