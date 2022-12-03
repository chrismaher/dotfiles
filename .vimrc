" Settings{{{
syntax on
set number
set autoindent

set smarttab
" use spaces when pressing tab in insert
set expandtab
" a tab character has length 4
set tabstop=4
" used for indent features ('<<' and the like)
set shiftwidth=4
" backspace over 4 spaces if possible
set softtabstop=4
" round < and the like to nearest shiftwidth
set shiftround

set clipboard=unnamed

" allow backspace in insert mode
set backspace=indent,eol,start

" disable error bells
set noerrorbells
set vb t_vb=

" open new vertical splits on the right
set splitright

if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

" Keep 200 lines of command history
set history=200

" vertical diff split
set diffopt+=vertical

if executable('rg')
    let grepprg = 'rg --vimgrep'
endif
"}}}

" Plugins{{{
call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'

" Plug 'dense-analysis/ale', { 'for': 'haskell' }

Plug 'fatih/vim-go', { 'for': 'go' }

" note: the filetype check here is breaking Gdiff*
" Plug 'git@github-personal:chrismaher/vim-dbt'
Plug 'git@github-personal:chrismaher/vim-lookml.git'
Plug 'git@github-personal:chrismaher/sqlfluff.vim.git'
Plug 'git@github-personal:chrismaher/vim-sql-case.git', { 'for': 'sql' }

" Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vader.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'mbbill/undotree'

" Plug 'mileszs/ack.vim'

Plug 'nvie/vim-flake8'

Plug 'preservim/nerdtree'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-unimpaired'

Plug 'vim-airline/vim-airline'

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

call plug#end()"}}}

" Functions{{{
" tabline
function TabLabel(n)
    return fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':~')
endfunction

function! TabLine()
    let l:tabline = ''
    for i in range(tabpagenr('$'))
        " select the highlighting
        if i + 1 == tabpagenr()
            let l:tabline .= '%#TabLineSel#'
        else
            let l:tabline .= '%#TabLine#'
        endif

        " set the tab page number
        let l:tabline .= '%' . (i + 1) . 'T'

        " the label is made by TabLabel
        let l:tabline .= ' %{TabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let l:tabline .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let l:tabline .= '%=%#TabLine#%999Xclose'
    endif

    return l:tabline
endfunction

set tabline=%!TabLine()

"
function! ToggleQuickfix()
    let l:quickfix = filter(getwininfo(), 'v:val.quickfix')
    if empty(l:quickfix)
        " execute 'copen' . exists("w:quickfix_height") ? ' ' . w:quickfix_height : ''
        execute 'copen ' . get(w:, 'quickfix_height', '')
    else
        let w:quickfix_height = l:quickfix[0].height
        cclose
    endif
endfunction

" delete all buffers that aren't in a window or changed
function! CleanBufferList()
    let _hidden = &hidden
    set nohidden

    let bufs = getbufinfo()
    let delnum = 0
    for buf in bufs
        if buf.listed == 1 && empty(buf.windows) && buf.changed == 0
            exec 'bdelete ' .  buf.bufnr
            let delnum += 1
        endif
    endfor

    let &hidden = _hidden

    echo "Deleted " . delnum . " buffers"
endfunction

" trim trailing whitespace
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

function! s:Preserve(func)
    let _s=@/
    let l = line(".")
    let c = col(".")
    call a:func()
    let @/=_s
    call cursor(l, c)
endfunction

" autocomplete-ready function to list Z results
function! s:z(a, l, p) abort
    let list = systemlist('_z -l ' . a:a)
    return map(list, {_, v -> substitute(v, '\S\+\s\+', '', '')})
endfunction

" tcd to the most frecent Z result
function! s:zcd(pattern) abort
    try
        let l:dir = s:z(a:pattern, '', '')[-1]
        execute 'tcd ' . l:dir
    catch
        echohl WarningMsg | echo "No Z entry for '" . a:pattern . "' found" | echohl None
    endtry
endfunction

" :Z command to switch to frecent directories
command! -nargs=1 -complete=customlist,<sid>z Z call <sid>zcd(<q-args>)

function! ToggleDiff()
    if &diff == 1
        :diffoff
    else
        NERDTreeClose
        windo diffthis
    endif
endfunction

function! ListLeaders()
    silent! redir @a
    silent! nmap <leader>
    silent! redir END
    silent! new
    silent! put! a
    silent! g/^s*$/d
    silent! %s/^.*,//
    silent! normal ggVg
    silent! sort
    silent! let lines = getline(1,"$")
endfunction

function! CleanWhitespace()
    silent! %s/\s\+,/,/g
    silent! %s/\(\w\)\s\+\(\w\)/\1 \2/g
endfunction
nnoremap <leader><tab> :call CleanWhitespace()<cr>

function! ToggleInteractiveShell()
    " toggle to make vim’s :! shell
    " behave like interactive shell
    let l:flag = &shellcmdflag
    if l:flag ==# '-c'
        set shellcmdflag=-ic
    elseif l:flag ==# '-ic'
        set shellcmdflag=-c
    endif
    echom 'shellcmdflag=' . &shellcmdflag
endfunction"}}}

" Mappings{{{
" leaders
let mapleader = ","
let maplocalleader = "\\"

" open single-key/prefix mappings
" nnoremap <space>
" nnoremap <tab>

" open leader single-key mappings
" nnoremap <leader><space>
" nnoremap <leader><tab>
" nnoremap <leader><bar>
" nnoremap <leader>=

" open leader mappings
" nnoremap <tab>
" nnoremap <leader>k
" nnoremap <leader>i
" nnoremap <leader>j
" nnoremap <leader>m
" nnoremap <leader>o
" nnoremap <leader>p
" nnoremap <leader>z

" list arguments
nnoremap <silent> <leader>. :args<cr>

" list buffers
nnoremap <silent> <leader>, :buffers<cr>

" list registers
nnoremap <silent> <leader>; :registers<cr>

" .vimrc editing
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" remap insert-mode escape
inoremap jk <esc>
inoremap <esc> <nop>

" make Y behave like C and D
nnoremap Y y$

" shift line downward
nnoremap _ ddp

" toggle hidden
nnoremap <leader>hi :set hidden!<cr>

" start a search
nnoremap <space>s :s/
nnoremap <space><space> :%s/

" mapping to flip vertical to horizontal
nnoremap <leader>hf <c-w>t<c-w>K

" mapping to flip horizontal to vertical
nnoremap <leader>vf <c-w>t<c-w>H

" yank to system clipboard
noremap <leader>y "*y

" yank buffer to system clipboard... shouldn't move cursor!
noremap <leader>Y ggVG"*y``

" paste last yank
nnoremap <leader>py "0p

" add to the argument list
nnoremap <leader>aa :argadd<cr>

" delete the previous argument
nnoremap <leader>ad :argdelete #<cr>

" reread buffer from file
nnoremap <silent> <leader>- :edit!<cr>

" vim writes & exits
noremap <space>w :w<cr>
noremap <leader>W :wa<cr>
noremap <space>q :q<cr>
noremap <leader>q :qa<cr>
noremap <leader>x :q!<cr>
noremap <leader>X :qa!<cr>

" argument mappings
nnoremap <leader>af :first<cr>

" new buffer
nnoremap <silent> <space>e :enew<cr>

" alternate buffer mappings
nnoremap <space>v :vertical sbuffer #<cr>
nnoremap <space>d :bd #<cr>
nnoremap <silent> <leader>bc :bp\|bd #<cr>

" buffer select
" nnoremap <leader>bb :ls<cr>:b<space>

" start :Z command
nnoremap <space>z :Z<space>

" window operations
nnoremap <silent> <space>n :vnew<cr>
nnoremap <silent> <leader>wh <c-w>t<c-w>K
nnoremap <silent> <leader>wv <c-w>t<c-w>H
nnoremap <silent> <leader>wr <c-w>R
nnoremap <silent> <leader>wt <c-w>T
nnoremap <silent> <leader>wo <c-w>o
nnoremap <silent> <space>o :only<cr>

" tab operations
nnoremap <silent> <space>t :tabedit<cr>
nnoremap <silent> <leader>tq :tabclose<cr>

" nnoremap <silent> ]t :tabnext<cr>
" nnoremap <silent> [t :tabprevious<cr>
nnoremap <silent> <space>] :tabnext<cr>
nnoremap <silent> <space>[ :tabprevious<cr>

" nnoremap <silent> <leader>] :tabmove +1<cr>
" nnoremap <silent> <leader>[ :tabmove -1<cr>
nnoremap <silent> ]t :tabmove +1<cr>
nnoremap <silent> [t :tabmove -1<cr>
nnoremap <silent> <leader>tf :tabfirst<cr>
nnoremap <silent> <leader>tl :tablast<cr>
nnoremap <silent> <space>1 1gt
nnoremap <silent> <space>2 2gt
nnoremap <silent> <space>3 3gt
nnoremap <silent> <space>4 4gt
nnoremap <silent> <space>5 5gt
nnoremap <silent> <space>6 6gt
nnoremap <silent> <space>7 7gt
nnoremap <silent> <space>8 8gt
nnoremap <silent> <space>9 9gt

" operations on pasted text
nnoremap gp `[v`]
" how to make these work?
" nnoremap <leader>v= `[v`]=
" nnoremap <leader>< V`]<
" nnoremap <leader>> V`]>

" change matches with cgn, starting with the word under the cursor
nnoremap <silent> <leader>cw :let @/=expand('<cword>')<cr>cgn
" nnoremap <Leader>x *``cgn
" nnoremap <Leader>X #``cgN

" wrap words in single or double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" change directory
" these isn't useful...
nnoremap <silent> <leader>up :tcd ..<cr>
nnoremap <silent> <leader>cd :tcd %:p:h<cr>

" change filetype
nnoremap <leader>sq :set filetype=sql<cr>

" force correct spacing around commas
nnoremap <leader>cs :s/\v\s*,\s*/, /g<cr>
xnoremap <leader>cs :s/\v\s*,\s*/, /g<cr>
" nnoremap <leader> :s/\v(\S+)\s{2,}(\S+)/\1 \2/g<cr>
" nnoremap <leader>cs :s/\s*(=|<=|>=)\s*/, /g<cr>
" parentheses, operators

" split list with newlines
nnoremap <silent> <leader>sl :s/\v\s*,\s*/,\r/g \| :normal! V``j=<cr>

" noremap <leader>rt :%retab<cr>

nnoremap <leader>cb :call CleanBufferList()<cr>
noremap <leader>tw :call TrimWhitespace()<cr>

" toggle mappings
noremap <silent> <leader>ti :call ToggleInteractiveShell()<cr>
noremap <silent> <leader>td :call ToggleDiff()<cr>
nnoremap <silent> <leader>tq :call ToggleQuickfix()<cr>
nnoremap <silent> <leader>ts :if exists("g:syntax_on") <bar> syntax off <bar> else <bar> syntax enable <bar> endif <cr>

" open & close terminal buffer
nnoremap <silent> <leader>ht :terminal<cr>
nnoremap <silent> <leader>vt :vertical terminal<cr>
tnoremap <esc> <C-\><C-n>:bd!<cr>

" run 'throwaway' macros in the q register with Q
nnoremap Q @q

" repeat the @q macro to the end of the buffer
nnoremap <silent> <C-@> :.,$normal @q<cr>

" clone paragragh
" noremap cp yap<S-}>p

" insert-mode mappings
inoremap <M-b> <C-O>b
inoremap <M-B> <C-O>B
inoremap <M-o> <C-O>O
inoremap <M-I> <C-O>^
inoremap <M-A> <C-O>$
inoremap <C-J> <Down>
inoremap <C-K> <Up>
" inoremap <C-b> <C-o>b
" inoremap <M-o>      <C-O>o
"}}}

" Plugin Settings & Mappings{{{
" Ale
" let g:ale_linters = {
"     \   'haskell': ['stack-ghc', 'hlint', 'hdevtools', 'hfmt'],
"     \}

" " EasyAlign
" " Start interactive EasyAlign in visual mode (e.g. vipga)
" xmap ga <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap ga <Plug>(EasyAlign)

" Fugitive
" function! ToggleBlame()
"     if &l:filetype ==# 'fugitiveblame'
"         close
"     else
"         :G blame<CR>
"     endif
" endfunction
" nnoremap gb :call <SID>ToggleBlame()<CR>

nnoremap <leader>gb :G blame<cr>
nnoremap <leader>gf :G fetch<cr>
nnoremap <leader>pu :G pull<cr>
nnoremap <leader>po :G push origin HEAD<cr>
nnoremap <leader>ci :G commit<cr>
nnoremap <leader>co :G co<space>
nnoremap <leader>gd :Gdiffsplit!<cr>
nnoremap <leader>gh :Gbrowse<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <space>g :G<cr>

xnoremap <leader>gh :Gbrowse<cr>
xnoremap <leader>gb :Gblame<cr>

" same bindings for merging diffs as in normal mode
xnoremap <leader>dp :diffput<cr>
xnoremap <leader>do :diffget<cr>

" GV
noremap <leader>gv :GV<cr>
noremap <leader>gV :GV!<cr>

" Rhubarb
nnoremap <leader>pr :G hub pull-request<cr>

" NERDTree
noremap <leader>nt :NERDTreeToggle<cr>

" Unimpaired
let g:nremap = {"[t": "", "]t": ""}

" Undotree
noremap <leader>ut :UndotreeToggle<cr>

" VimWiki
let g:vimwiki_list = [{ 'path': '~/.wiki/', 'syntax':'markdown', 'ext': '.md' }]
nnoremap <leader>wx :VimwikiToggleListItem<cr>
" autocmd FileType vimwiki let g:vimwiki_list = [{'path': '~/.wiki/', 'syntax': 'markdown', 'ext': '.md'}]

" fzf{{{
" autocmd! FileType fzf
" autocmd  FileType fzf set noshowmode noruler nonu

" make fzf open in a tmux popup window
" https://github.com/junegunn/fzf/blob/master/README-VIM.md#starting-fzf-in-a-popup-window

" inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" Browse help files and README.md:
" https://github.com/junegunn/vim-plug/wiki/extra#browse-help-files-and-readmemd

let g:fzf_layout = { 'down': '40%' }

" ignore filename when fzf searches rg output
" https://stackoverflow.com/questions/59885329/how-to-exclude-file-name-from-fzf-filtering-after-ripgrep-search-results
command! -bang -nargs=* RG call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)

" nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"

" fzf for branches
nnoremap <silent> <space>c :call fzf#run(fzf#wrap({'source': 'git branch', 'sink': function({arg -> execute('Git checkout ' . substitute(arg, '\s\+', '', -1))})}))<CR>

" fzf for pull requests
nnoremap <silent> <space>p :call fzf#run(fzf#wrap({'source': 'gh pr list --json number,title --template '.shellescape('{{range .}}{{tablerow (printf "#%v" .number \| color "green") .title}}{{end}}'), 'sink': function({arg -> execute('G gh pr checkout ' . substitute(arg, '\s\+.*', '', -1))}), 'options': '--ansi'}))<CR>

nnoremap <silent> <space>b :Buffers<CR>
nnoremap <silent> <space>f :Files<CR>
nnoremap <silent> <space>F :GFiles<CR>
nnoremap <silent> <space>r :RG<CR>
nnoremap <silent> <space>h :Helptags<CR>
nnoremap <silent> <space>l :BLines<CR>
nnoremap <silent> <space>L :Lines<CR>
nnoremap <silent> <space>; :History:<CR>
nnoremap <silent> <space>/ :History/<CR>
" nnoremap <silent> <space>' :Marks<CR>
"}}}
"}}}

" Filetype Settings{{{
if has("autocmd")
    filetype on

    " autocmd BufWritePost .vimrc source $MYVIMRC

    autocmd BufReadPost fugitive://* set bufhidden=delete " clean fugitive Gedit buffers
    " autocmd CmdwinEnter * map <buffer> <leader><space> <CR>q:

    " Go{{{
    augroup filetype_go
        autocmd!

        autocmd FileType go setlocal autowrite tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

        let g:go_list_type = "quickfix"
        " 10 seconds it the default, but it can be adjusted
        " with g:go_test_timeout as necessary
        let g:go_test_timeout = '10s'
        let g:go_fmt_command = "goimports"
        " this setting controls whether doc strings are selected
        " with af motion
        let g:go_textobj_include_function_doc = 1

        " the default
        " let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
        " let g:go_metalinter_autosave = 1
        " let g:go_metalinter_autosave_enabled = ['vet', 'golint']
        " let g:go_metalinter_deadline = \"5s\"

        " run :GoBuild or :GoTestCompile based on the go file
        function! s:build_go_files()
            let l:file = expand('%')
            if l:file =~# '^\f\+_test\.go$'
                call go#test#Test(0, 1)
            elseif l:file =~# '^\f\+\.go$'
                call go#cmd#Build(0)
            endif
        endfunction

        autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
        autocmd FileType go nmap <leader>r <Plug>(go-run)
        autocmd FileType go nmap <leader>t <Plug>(go-test)
        autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
        autocmd FileType go nmap <leader>i <Plug>(go-info)

        autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
        autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
        autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
        autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')

    augroup END"}}}

    " Haskell{{{
    augroup filetype_haskell
        autocmd!
        " autocmd FileType haskell set formatprg=stylish-haskell
        autocmd FileType haskell nnoremap <leader>b :! stack ghc -- %<CR>
        autocmd FileType haskell nnoremap <leader>r :! runhaskell %<CR>
    augroup END"}}}

    " Help{{{
    augroup filetype_help
        autocmd!
        " open vim help in a vertical split
        autocmd FileType help wincmd L
        autocmd FileType help nnoremap <buffer>q :q<CR>
    augroup END"}}}

    " LookML{{{
    augroup filetype_lookml
        autocmd!
        autocmd FileType lookml setlocal tabstop=2 softtabstop=2 shiftwidth=2
    augroup END"}}}

    " Python{{{
    augroup filetype_python
        autocmd!
        autocmd FileType python setlocal textwidth=79
        autocmd FileType python set fileformat=unix
        autocmd FileType python nnoremap <leader>f8 :call flake8#Flake8()<CR>
    augroup END"}}}

    " Shell{{{
    augroup filtetype_sh
        autocmd!
        autocmd FileType sh setlocal foldmethod=marker
    augroup End"}}}

    " SQL{{{
    augroup filetype_sql
        autocmd!
        autocmd FileType sql nmap <leader>sc <Plug>(sql-case)
        autocmd FileType sql nmap <leader>sf <plug>(sqlfluff-lint)
        autocmd FileType sql setlocal foldmethod=indent
        autocmd FileType sql setlocal commentstring=--\ %s
    augroup END"}}}

    " Vimscript{{{
    augroup filtetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup End"}}}

    " YAML{{{
    augroup filetype_yaml
        autocmd!
        autocmd FileType yaml setlocal tabstop=2 sts=2 shiftwidth=2
    augroup End"}}}
endif"}}}
