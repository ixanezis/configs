" insert content of this file in your ~/.vim/plugin/pycalc.vim
" created by Romka :)
" August 2015

function! DoPyCalc()
python << EOF
import vim as __vim

__SEP = "#>"
__MARGIN = 2

__b = __vim.current.buffer
__N = len(__b)
__cursor = __vim.current.window.cursor
__lines = []
for __i, __line in enumerate(__b):
    if __SEP in __line:
        __code = __line.rpartition(__SEP)[0][:-2]
    else:
        __code = __line
    if __i + 1 == __cursor[0]:
        __code = __code[:__cursor[1]] + __code[__cursor[1]:].rstrip()
    else:
        __code = __code.rstrip()
    __lines.append(__code)

__maxlen = max(map(len, __lines))
for __i in xrange(__N):
    if not __lines[__i].strip():
        continue
    try:
        __res = str(eval(__lines[__i]))
    except:
        try:
            exec(__lines[__i])
            try:
                __lhs = __lines[__i].split("=")[0].strip()
                __res = str(eval(__lhs))
                if len(__res) > 30:
                    __res = __res[:27] + "..."
                __res = __lhs + " = " + __res
            except:
                __res = "(ok)"
        except Exception as e:
            __res = str(e)
    if __res:
        __res = " " + __res

    __lines[__i] += " " * (__maxlen + __MARGIN - len(__lines[__i])) + __SEP + __res

__vim.current.buffer[:] = __lines
EOF
endfunction

function! ErasePyCalc()
python << EOF
import vim as __vim

__SEP = "#>"

__b = __vim.current.buffer
__cursor = __vim.current.window.cursor
__lines = []
for __i, __line in enumerate(__b):
    if __SEP in __line:
        __code = __line.rpartition(__SEP)[0][:-2]
    else:
        __code = __line
    if __i + 1 == __cursor[0]:
        __code = __code[:__cursor[1]] + __code[__cursor[1]:].rstrip()
    else:
        __code = __code.rstrip()
    __lines.append(__code)

__vim.current.buffer[:] = __lines
EOF
endfunction

map <leader>c :call TogglePyCalc()<CR>
let g:pycalc_on=0
function! TogglePyCalc()
  if g:pycalc_on
    let g:pycalc_on=0
    autocmd! pycalc
    call ErasePyCalc()
    echo "PyCalc turned off"
  else
    let g:pycalc_on=1
    augroup pycalc
        autocmd InsertLeave,CursorMovedI,CursorMoved * call DoPyCalc()
    augroup END
    call DoPyCalc()
    echo "PyCalc turned on"
  endif
endfunction
