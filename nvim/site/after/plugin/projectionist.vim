
if !exists("g:autoloaded_projectionist")
  finish
endif

" try to extend transformation

function! s:env(var) abort
  return exists('*DotenvGet') ? DotenvGet(a:var) : eval('$'.a:var)
endfunction

function! g:projectionist_transformations.domain(input, o) abort
  return s:env('DOMAIN')
endfunction


" https://github.com/tpope/vim-projectionist/blob/master/doc/projectionist.txt
"
" https://www.youtube.com/watch?v=3jDafvUESbs
" https://github.com/wincent/wincent/blob/57a3bf2001/roles/dotfiles/files/.vim/after/plugin/projectionist.vim
" https://github.com/fsharpasharp/vim-dirvinist
" https://github.com/andyl/vim-projectionist-elixir/blob/master/ftdetect/elixir.vim
" https://github.com/naps62/dotfiles/blob/master/config/nvim/rc/skel.vim
" https://github.com/noahfrederick/dots/tree/master/vim/after/plugin
" https://github.com/noahfrederick/dots/blob/master/vim/autoload/my/snippet.vim
" https://github.com/noahfrederick/dots/blob/master/vim/autoload/my/project.vim
" https://www.reddit.com/r/vim/comments/3rsvbr/vimprojectionist/
" https://robots.thoughtbot.com/extending-rails-vim-with-custom-commands
