set nocompatible              " 去除VI一致性,必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=~/.vim/bundle/Vundle.vim

" ---------------------------------------------------------------
call vundle#begin()
" 另一种选择, 指定一个vundle安装插件的路径
"call vundle#begin('~/some/path/here')

" 让vundle管理插件版本,必须
Plugin 'VundleVim/Vundle.vim'

" 以下范例用来支持不同格式的插件安装.

" 请将安装插件的命令放在vundle#begin和vundle#end之间.
"
" Github上的插件
" 格式为 Plugin '用户名/插件仓库名'
"Plugin 'tpope/vim-fugitive'
Plugin 'sickill/vim-monokai'
Plugin 'scrooloose/nerdtree'
Plugin 'yegappan/grep'
Plugin 'vim-scripts/taglist.vim'
Plugin 'Shougo/neocomplete.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'godlygeek/tabular'
Plugin 'majutsushi/tagbar'
Plugin 'jiangmiao/auto-pairs'
Plugin 'flazz/vim-colorschemes'
"Plugin 'WolfgangMehner/c-support'
Plugin 'WolfgangMehner/lua-support'
Plugin 'tpope/vim-unimpaired'
Plugin 'tpope/vim-surround'
"Plugin 'mileszs/ack.vim'

" 来自 http://vim-scripts.org/vim/scripts.html 的插件
" Plugin '插件名称' 实际上是 Plugin 'vim-scripts/插件仓库名' 只是此处的用户名可以省略
"Plugin 'L9'
"
" 由Git支持但不再github上的插件仓库 Plugin 'git clone 后面的地址'
"Plugin 'git://git.wincent.com/command-t.git'
"
" 本地的Git仓库(例如自己的插件) Plugin 'file:///+本地插件仓库绝对路径'
"Plugin 'file:///home/gmarik/path/to/plugin'
"Plugin 'file:///home/yangyuan/.vim/local/taglist_46'
" 插件在仓库的子目录中.
" 正确指定路径用以设置runtimepath. 以下范例插件在sparkup/vim目录下
"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" 安装L9，如果已经安装过这个插件，可利用以下格式避免命名冲突
"Plugin 'ascenator/L9', {'name': 'newL9'}

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
" -------------------------------------------------------------------------

filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本
" 忽视插件改变缩进,可以使用以下替代:
"filetype plugin on
"
" 简要帮助文档
" :PluginList       - 列出所有已配置的插件
" :PluginInstall    - 安装插件,追加 `!` 用以更新或使用 :PluginUpdate
" :PluginSearch foo - 搜索 foo ; 追加 `!` 清除本地缓存
" :PluginClean      - 清除未使用插件,需要确认; 追加 `!` 自动批准移除未使用插件
"
" 查阅 :h vundle 获取更多细节和wiki以及FAQ
" 将你自己对非插件片段放在这行之后


" ～～～～～～～～～～～～～～～～～～～～～～～～～～～～
" ～～～～～～～～～～～～～～～～～～～～～～～～～～～～
" 接下来就是用户自己的个人配置了，自己的配置喜好都放在这里

"
" 函数定义------------------------------------------- start
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Don't close window, when deleting a buffer
"command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum   = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

" Delete trailing white space on save, useful for Python and CoffeeScript ;)
function! DeleteTrailingWS()
    exe "normal mz"
    %s/\s\+$//ge
    exe "normal `z"
endfunction

function! DeleteTillSlash()
    let g:cmd = getcmdline()

    if has("win16") || has("win32")
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\]\\).*", "\\1", "")
    else
        let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*", "\\1", "")
    endif

    if g:cmd == g:cmd_edited
        if has("win16") || has("win32")
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[\\\\\]\\).*\[\\\\\]", "\\1", "")
        else
            let g:cmd_edited = substitute(g:cmd, "\\(.*\[/\]\\).*/", "\\1", "")
        endif
    endif   

    return g:cmd_edited
endfunction

function! CurrentFileDir(cmd)
    return a:cmd . " " . expand("%:p:h") . "/"
endfunction

" 在Quickfix中进行正则表达式搜索
function! MatchStrInQuickFix()
    " 先判断原先Quickfix中的内容是否存在
    let old_qflist = getqflist()
    let lenofqflist = len(old_qflist)
    if lenofqflist == 0
        echohl WarningMsg | 
                    \ echomsg " Error: Quickfix is empty" | 
                    \ echohl None
        return
    endif

   " 获取当前光标下的单词
    let pattern = input("Search for pattern in quickfix: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    echo "\r"
    let quote_char = "'"
    let pattern = quote_char . pattern . quote_char
    
    " 选择查找的方式，默认就是查找指定关键词，也可以选择排除关键词的查找
    let greptype = input("Select default match or invert match\n(input (d or default) means default match but any other char means invert match): ", "d")
    let invert_match = 0
    if greptype != "d" && greptype != "default"
        let invert_match = 1
    endif

    " 将quickfix中的内容写入临时文件中，并在使用完后删除临时文件
    let tmpfile = tempname()
    let old_verbose = &verbose
    set verbose&vim
    execute "redir! > " . tmpfile
    let i = 1
    let semicolon = ";"
    while i < lenofqflist
        let tmp_text = i . semicolon . bufname(old_qflist[i].bufnr) . " " . old_qflist[i].text . "\n"
        silent echon tmp_text
        let i = i + 1
    endwhile
    " 重定向结束
    redir END
    let &verbose = old_verbose

    let current_filename = quote_char . tmpfile . quote_char

    " 命令参数的含义请在shell中执行grep --help查看
    let grep_opt = '-E'
    if invert_match == 1
        let grep_opt = grep_opt . ' -v'
    endif
    let grep_expr_option = '-e'
    let grepcmd = "grep ". grep_opt . " " 
    let grepcmd = grepcmd . grep_expr_option . " " . pattern 
    let grepcmd = grepcmd . " " . current_filename
    let cmd_output = system(grepcmd)

    call delete(tmpfile)
    if cmd_output == ""
        if invert_match == 1
            echohl WarningMsg | 
                        \ echomsg " Error: Exclude pattern " . pattern . " not found" | 
                        \ echohl None
            return    
        else
            echohl WarningMsg | 
                        \ echomsg " Error: Pattern " . pattern . " not found" | 
                        \ echohl None
            return    
        endif
    endif

    let new_qflist = []
    call add(new_qflist, old_qflist[0])
    if invert_match == 1
        let new_qflist[0].text = "[Search results for exclude pattern in quickfix: " . pattern . "]" 
    else
        let new_qflist[0].text = "[Search results for pattern in quickfix: " . pattern . "]" 
    endif

    let i = 0
    for one_text in split(cmd_output, "\n")
        let index = stridx(one_text, semicolon)
        if index == -1
            continue
        endif
        let linenumberstr = strcharpart(one_text, 0, index)
        let linenumber = str2nr(linenumberstr)
        while i < linenumber
            let i = i + 1
        endwhile
        call add(new_qflist, old_qflist[i])
    endfor

    " 重新设置quickfix，并打开其窗口
    call setqflist(new_qflist)
    botright copen
endfunction
nnoremap <F6> :call MatchStrInQuickFix()<cr>

" 在vim当前buffer中执行grep命令，并将查找结果显示在quickfix中
" 注意，当前只测试了*nix平台，Windows或Mac OS可能会有字符转换问题
function! RunGrepCommandInCurrentBuffer()
    " 获取当前光标下的单词
    let pattern = input("Search for pattern: ", expand("<cword>"))
    if pattern == ""
        return
    endif
    let quote_char = "'"
    let pattern = quote_char . pattern . quote_char
    " 获取当前buffer的文件名
    let current_filename = expand("%:p")
    if current_filename == ""
        echohl WarningMsg | 
                    \ echomsg " Error: currentfile " . current_filename . " not found" | 
                    \ echohl None
        return
    endif
    let current_filename =  quote_char . current_filename .quote_char

    " Add /dev/null to the list of filenames, so that grep print the
    " filename and linenumber when grepping in a single file
    let grep_null_device = '/dev/null'
    let current_filename = current_filename . " " . grep_null_device

    " 命令参数的含义请在shell中执行grep --help查看
    let grep_opt = '-E'
    let grep_expr_option = '-e'
    let grepcmd = "grep ". grep_opt . " -n " 
    let grepcmd = grepcmd . grep_expr_option . " " . pattern 
    let grepcmd = grepcmd . " " . current_filename

    let cmd_output = system(grepcmd)
    if cmd_output == ""
        echohl WarningMsg | 
                    \ echomsg " Error: Pattern " . pattern . " not found" | 
                    \ echohl None
        return
    endif

    " 创建临时文件保存grep指令查找到结果
    let tmpfile = tempname()
    let old_verbose = &verbose
    set verbose&vim
    " 重定向输出流到我们创建的临时文件 
    execute "redir! > " . tmpfile
    " 输出grep查找结果到tmpfile
    silent echon '[Search results for pattern: ' . pattern . "]\n"
    silent echon cmd_output
    " 重定向结束
    redir END
    let &verbose = old_verbose

    let old_efm = &errorformat
    " 设置error信息格式
    set errorformat=%f:%\\s%#%l:%m
    " 将临时文件中的内容，写入quickfix窗口中
    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif
    let &errorformat = old_efm
    " 在当前窗口下方打开quickfix窗口
    botright copen

    " 删除临时文件
    call delete(tmpfile)
endfunction
nnoremap <F7> :call RunGrepCommandInCurrentBuffer()<cr>

" 编译并执行当前Buffer(如果能的话)，目前支持c\c++\lua
function! CompileAndRunCurrentBuffer()
    let crtFlNm = expand("%:t")
    if crtFlNm == ""
        echohl WarningMsg | 
                    \ echomsg " Error: currentfile no exists" | 
                    \ echohl None
        return
    endif
    let lastDotIdx = strridx(crtFlNm, ".")
    if lastDotIdx == -1
        echohl WarningMsg | 
                    \ echomsg " Error: File type can't identify" | 
                    \ echohl None
        return
    endif
    let suffixStrLen = (strlen(crtFlNm) - 1) - lastDotIdx
    let startIdx     = lastDotIdx + 1
    let suffixStr    = strcharpart(crtFlNm ,startIdx, suffixStrLen)
    let outputName   = strcharpart(crtFlNm, 0, lastDotIdx)
    let fullName     = expand("%:p")

    let cmd = ""
    if suffixStr ==? "cpp"
        let cmd = cmd . "g++ -o " . outputName . " " . fullName . " && ./" . outputName
    elseif suffixStr ==? "c"
        let cmd = cmd . "gcc -o " . outputName . " " . fullName . " && ./" . outputName
    elseif suffixStr ==? "lua"
        let cmd = cmd . "lua " . fullName
    elseif suffixStr ==? "py"
        let cmd = cmd . "python3 " . fullName
    elseif suffixStr ==? "java"
        let cmd = cmd . "javac " . fullName . " && java " . outputName
    else
        echohl WarningMsg | 
                    \ echomsg " Error: Now file type *." 
                    \ . suffixStr . " does not support yet" | 
                    \ echohl None
        return
    endif
    let cmd_output = system(cmd)

    let tmpfile = tempname()
    let old_verbose = &verbose
    set verbose&vim
    " 重定向输出流到我们创建的临时文件 
    execute "redir! > " . tmpfile
    " 输出grep查找结果到tmpfile
    silent echon 'Run [' . crtFlNm . "] results:\n"
    silent echon cmd_output
    silent echon 'Run [' . crtFlNm . "] end."
    " 重定向结束
    redir END
    let &verbose = old_verbose

    let old_efm = &errorformat
    " 设置error信息格式
    set errorformat=%f:%\\s%#%l:%m
    " 将临时文件中的内容，写入quickfix窗口中
    if exists(":cgetfile")
        execute "silent! cgetfile " . tmpfile
    else
        execute "silent! cfile " . tmpfile
    endif
    let &errorformat = old_efm
    " 在当前窗口下方打开quickfix窗口
    botright copen

    " 删除临时文件
    call delete(tmpfile)
endfunction
" 先更新当前Buffer，然后调用函数Run Buffer
inoremap <F9> <Esc>:update<cr>:call CompileAndRunCurrentBuffer()<cr>
nnoremap <F9> :update<cr>:call CompileAndRunCurrentBuffer()<cr>

function! QuickfixFilenames()
    let bufferNumbers = {}
    for quickfixItem in getqflist()
        " Quickfix list entries with non-existing buffer number are returned
        " with "bufnr" set to zero.所以需要跳过所有"bufnr"为0的entry。因为对于
        " bufname()的参数来说0 is the alternate buffer for the current window.
        " 所以你会拿到多出来的一个未预期的文件名，这肯定不是我们想要的
        let itemNo = quickfixItem["bufnr"]
        if itemNo == 0
            continue
        endif
        let bufferNumbers[itemNo] = bufname(itemNo)
    endfor
    let result = join(map(values(bufferNumbers), 'fnameescape(v:val)'))
    return result
endfunction
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()

function! GlobalQuickSubstitutePattern()
    " 获取quickfix中所有的文件名
    let quickfixFilenames = QuickfixFilenames()
    if quickfixFilenames == ""
        echohl WarningMsg |
                    \ echomsg "quickfixFilenames is empty" |
                    \ echohl None
        return
    endif
    " 不允许输入的Old pattern为空字符串
    let oldPattern = input("Old pattern: ", expand("<cword>"))
    if oldPattern == ""
        echohl WarningMsg |
                    \ echomsg "Old pattern is empty" |
                    \ echohl None
        return
    endif
    echo "\r"
    " newPattern是可以为空字符串“”的，这样就表示删除Old pattern
    let newPattern = input("New pattern: ", expand("<cword>"))
    echo "\r"
    " 用quickfix中的文件名，覆盖参数列表
    execute "args " . quickfixFilenames
    " 对参数列表中的每一个文件执行substitute命令
    execute "argdo " . "%substitute/"
        \ . oldPattern . "/" . newPattern . "/geIl | update"
endfunction
nnoremap <F10> :call GlobalQuickSubstitutePattern()<cr>
" --------------------------------------------- end
"
"
let mapleader   = ","
let g:mapleader = ","
" 这里设置让Vim显示行号
set number

" 启用Vim的语法高亮功能，如果不先执行这个命令，在好看的颜色主题都无法表现出来
syntax enable

" 顾名思义，设置我们的颜色主题为'monokai'，即sublime text2默认的颜色主题，我比较喜欢这个配色:)
colorscheme monokai

" 设置当前行高亮显示
set cursorline
"highlight cursorline ctermbg=darkblue

" 设置Backspace键的表现方式
set backspace=indent,eol,start

" 设置光标的移动方式
set whichwrap+=h,l,<,>

" 建立F3作为NERDTreeToggle(即树型结构的开关)的快捷键
" 也就是说按下F3就相当于在是ex command 中执行了打开NERDTree的命令
nnoremap <F3> :NERDTreeToggle<CR>

"设置NERDTree的窗口信息，包括位置、大小等
let NERDChristmasTree       = 1
let NERDTreeAutoCenter      = 1
let NERDTreeMouseMode       = 2
let NERDTreeShowBookmarks   = 1
let NERDTreeShowFiles       = 1
let NERDTreeShowHidden      = 1
let NERDTreeShowLineNumbers = 1
let NERDTreeWinPos          = 'left'
let NERDTreeWinSize         = 30

" 建立在窗口之间移动的映射关系
" "对应于在Buffer中的移动规则h-->左,j-->下,k-->上,l-->右
" C代表Ctrl键，即按住Ctrl键，再按j、k、h、l进行窗口间的移动
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l 

" 设置j/k在屏幕上移动时的表现,当一行的内容显示不完全时才能正确的移动
" j基于实际行移动，而gj基于屏幕行移动,etc
nnoremap j gj
nnoremap k gk
"nnoremap $ g$

" 设置TagbarToggle的快捷键
nnoremap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_width          = 30
let g:tagbar_autoshowtag    = 1
let g:tagbar_previewwin_pos = "aboveleft"

""nnoremap <silent> <F4> :TlistToggle<CR>
" 设置taglist窗口的位置、大小等信息
""let g:Tlist_Use_Right_Window=1
""let g:Tlist_Enable_Fold_Column=0
""let g:Tlist_Exit_OnlyWindow=1
""let Tlist_WinWidth=42

" 建立F5作为Regrep的快捷键
" 默认在打开Vim的当前目录下对所有的文件内容进行模式匹配
nnoremap <silent> <F5> :Regrep<CR>

"neocomplete
let g:neocomplete#enable_at_startup             = 1
let g:acp_enableAtStartup                       = 0
let g:neocomplete#enable_smart_case             = 1
let g:neocomplete#sources#include#max_processes = 0

" 设置在插入模式下，使用方向键时，直接关闭补全(这样不用切换模式就可以很方便的
" 换行之类的,那么选择补全可以使用Ctrl-N(next)和Ctrl-P替代(prev))
inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
"nnoremap <F10> :NeoCompleteToggle<CR>

" 搜索文件<Ctrl-F> 查找已经打开过的文件<Ctrl-B>
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map               = '<c-f>'
let g:ctrlp_max_height        = 24
let g:ctrlp_custom_ignore     = 'node_modules\|^\.DS_Store\|^\.git\|^\.coffee'
nnoremap <c-b> :CtrlPBuffer<cr>

" 在插入模式下设置括号的补全，当输入左边括号时自动输入右边括号，并将光标移动至
" 括号之间,接下来的{}/[]/""/''是同样的道理
"inoremap ( ()<Esc>i
"inoremap { {}<Esc>i
"inoremap [ []<Esc>i
"inoremap " ""<Esc>i
"inoremap ' ''<Esc>i

" 禁止一行的内容过长导致无法在当前Buffer的一行中显示全部内容的时候自动换行
set nowrap

" 设置在使用/和?对打开的Buffer进行模式匹配时，高亮显示匹配的已输入文本
" 也就是说，当你输入模式的过程中就会高亮显示已经匹配的文本
" 但是仅仅设置这个变量不会高亮显示匹配完成之后的结果
set incsearch

" 设置在使用/和?进行模式匹配之后，高亮显示所有已匹配的结果
set hlsearch

" 设置Vim的历史记录的行数
set history=1000

" 设置Vim探测这个文件被外部程序改变时，并且这个文件没有被
" Vim本身改变，那么Vim重读这个文件
set autoread

" 设置滚屏的最小行数，即当我们使用j/k在一个Buffer中移动时
" 离屏幕显示的上限、下限还有5行时就会自动滚屏
set scrolloff=5

" 打开wildmenu 
set wildmenu

" 忽略编译生成的文件，以及版本控制目录下的文件 
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

" 总是显示当前光标的位置
set ruler

" 设置命令行的高度，其实默认就是1
set cmdheight=1

" 设置magic，为搜索文本时服务，其实默认就是开启的
set magic

" 设置在你输入括号的时候，如果你输入完整，光标会回退
" 到对应的左括号，然后在回到当前位置
set showmatch

" 设置输入括号时，匹配括号的闪烁时间0.3秒,默认是0.5秒
set matchtime=3

" 设置编码格式为utf8
set encoding=utf8

" 设置unix作为标准文件类型
set fileformats=unix,dos,mac

" 设置vim部分搜索命令的文件搜索路径
set path=.
set path+=,,
set path+=./**
set path+=/usr/include
set path+=/usr/local/include

" 映射在ex command 中,输入Q回车就是退出vim当前的所有窗口即q(quit)all
command! Q qall 

" 关闭Vim的备份功能 
set nobackup
set nowritebackup
set noswapfile

" 设置自动写入
set autowrite

" 设置在切换Buffer时，不提示当前Buffer是否需要写入(不设置的话，不会很方便)
set hidden

" 使用space替代tab 
set expandtab

" 开启smarttab 
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" 设置缩进
set autoindent 
set smartindent

" 针对 python、coffee去掉文件末尾多余的空白
autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

autocmd FileType css set omnifunc=csscomplete#CompleteCSS

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

" Specify the behavior when switching between buffers 
try
    set switchbuf=useopen
    set showtabline=2
catch
endtry

"恢复到上次关闭文件时光标所在的位置
autocmd BufReadPost *
            \ if line("'\"") > 0 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif
" Remember info about open buffers on close
set viminfo^=%

" 总是显示状态行 
set laststatus=2

" 设置状态行的显示格式 
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

" 重新映射0为^，0是回到行首，^也是回到行首，但是有细微的差别，你可以试一下就知道 
nnoremap 0 ^

" 重新映射单词表现，输入shijian(即时间的拼音)则将文本替换为格式化的时间
iab shijian <c-r>=strftime("(%Y年%m月%d日 %H时%M分)")<cr>

"not left margin 其实也可以不用设置，本来默认就是0
set foldcolumn=0

" 设置代码折叠方式 可以使用<z-c>关闭折叠，<z-o>打开折叠
set foldmethod=indent

" 设置代码长度边界提示
"set colorcolumn=80

" 设置多语言
if has("multi_byte") 
    "utf-8
    set termencoding=utf-8 
    set formatoptions+=mM 
    set fencs=utf-8,gbk 
    "file codings
    set encoding=utf-8
    set fileencodings=ucs-bom,utf-8,cp936,gbk,gb2312
    if v:lang =~? '^/(zh/)/|/(ja/)/|/(ko/)' 
        set ambiwidth=double 
    endif 
    if has("win32") 
        source $VIMRUNTIME/delmenu.vim 
        source $VIMRUNTIME/menu.vim 
        language messages zh_CN.utf-8 
    endif 
else 
    echoerr "Sorry, this version of (g)vim was not compiled with +multi_byte" 
endif

""设置语法检测选项
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_loc_list_height          = 8
let g:syntastic_lua_checkers             = ["luac", "luacheck"]
let g:syntastic_lua_luacheck_args        = "--no-unused-args"

"" 设置代码针对制定字符对齐(强迫症的福音)
" 让选中行按所有“=”对齐
noremap <Leader>a :Tabularize /=
" 让选中行只按第一个出现的"="对齐,af取 align first之意
noremap <Leader>af :Tabularize /^[^=]*\zs=

let g:Lua_MapLeader = ','

"添加package matchit
packadd! matchit
"autocmd FileType 
autocmd FileType lua let b:match_words = '\<if\>:\<elseif\>:\<else\>:\<end\>,'
    \ . '\<for\>:\<break\>:\<end\>,'
    \ . '\<while\>:\<break\>:\<end\>,'
    \ . '\<function\>:\<end\>,'
autocmd FileType python let b:match_words = '\<if\>:\<elif\>:\<else\>,'
    \ . '\<for\>:\<continue\>:\<break\>,'

" 固定n/N的搜索方向
nnoremap <expr> n 'Nn'[v:searchforward]
nnoremap <expr> N 'nN'[v:searchforward]

" 设置当前行高亮的表现方式(进入窗口时高亮当前行，离开窗口时关闭当前行高亮)
autocmd WinEnter * set cursorline
autocmd WinLeave * set nocursorline

" 以超级用户权限保存文件 
command! W w !sudo tee % > /dev/null
