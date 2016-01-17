" bdd.vim
" Vim functions to run RSpec and Cucumber on the current file and optionally on
" the spec/scenario under the cursor.

function! ScriptIfExists(name)
  " Zeus
  if glob("`ls -a | grep '.zeus.sock'`") != ""
    return "zeus " . a:name
  " Spring
  elseif filereadable("bin/spring") && filereadable("script/rails")
    return "bin/spring " . a:name
  " Bundle exec
  elseif isdirectory(".bundle") || (exists("b:rails_root") && isdirectory(b:rails_root . "/.bundle"))
    return "bundle exec " . a:name
  " System Binary
  else
    return a:name
  end
endfunction

function! RunSpec(args)
  let spec = ScriptIfExists("rspec")
  let cmd = spec . " " . @% . a:args
  execute ":! echo " . cmd . " && " . cmd
endfunction

function! RunCucumber(args)
  let cucumber = ScriptIfExists("cucumber")
  let cmd = cucumber . " " . @% . a:args
  execute ":! echo " . cmd . " && " . cmd
endfunction

function! RunExUnit(args)
  let cmd = "mix test" . " " . @% . a:args
  execute ":! echo " . cmd . " && " . cmd
endfunction

function! RunTestFile(args)
  if @% =~ "\.feature$"
    call RunCucumber("" . a:args)
  elseif @% =~ "\.rb$"
    call RunSpec("" . a:args)
  elseif @% =~ "\.exs$"
    call RunExUnit(":" . line('.') . a:args)
  end
endfunction

function! RunTest(args)
  if @% =~ "\.feature$"
    call RunCucumber(":" . line('.') . a:args)
  elseif @% =~ "\.rb$"
    call RunSpec(":" . line('.') . a:args)
  elseif @% =~ "\.exs$"
    call RunExUnit(":" . line('.') . a:args)
  end
endfunction

map <Leader>; :call RunTest("")<CR>
map <Leader>' :call RunTestFile("")<CR>
