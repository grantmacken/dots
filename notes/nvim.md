
# pack notes
h: pack
packages in the pack 'start' dir should load at runtime

 - filetype plugins 'could' go here

packages in the pack 'opt' dir only load when requested
via  `packadd {name}`
where {name} is the directory name not file name

 - colors scheme should go in opt

packadd! {name} means no plugin or ftdetect files are added
after you can to load plugins -- load-plugins


## notes
h: api
h: lua-stdlib

vim.fn.{func}
Read, set and clear
print(vim.g.my_global_variable)
vim.g.my_global_variable = 5
vim.g.my_global_variable = nil

vim.g  g: 
vim.b  b:
vim.b  w:
vim.v  v:
vim.o  option
vim.bo buffer option
vim.wo window option

inpect
paste - can be used to scrub term color-codes


