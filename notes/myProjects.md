# My neovim lua project

 - [ ] with old files open from cmdline
 - [ ] set layout out project window from last old file 


A buffer may have projections
these projections are set as a buffer var named 'projections'
the value of the projections var is a projections are a flat lua table.
A projections table 'key' represents something that can be done with or assigned to the buffer

## projectionist keys

The keys represent something we can handle per buffer
Some global actions can have a local value e.g

```
h option-summary
\global-local
```

 cscopeprg
 equalprg 
 formatprg 
 grepprg
 keywordprg 
 makeprg
 errorformat 
 

define
dictionary
include
statusline
tags 
thesaurus

browsedir

1. format:  the value should set the 'formatprg' for the buffer
            - can use Neofomat

2. test:    sets makeprg and err

3. build

1. 'type':  projections will not be set unless there is a 'type' detected for the buffer
    The type key allow commandline navigation.

  -  makeprg 
