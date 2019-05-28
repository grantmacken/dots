if !exists('g:loaded_shebang')
  finish
endif

AddShebangPattern! lua ^#!/usr/bin/env\s\+resty\>
