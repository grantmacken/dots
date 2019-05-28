"GF: nvim/site/lua/my/qf.lua
command! -nargs=0 Prove lua require('my.jobs').qfJobs('prove')
command! -nargs=0 Qnext lua require('my.qf').rotateNext()
command! -nargs=0 Qprev lua require('my.qf').rotatePrev()
command! -nargs=0 Qtoggle lua require('my.qf').toggle()
