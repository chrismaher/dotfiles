" Settings{{{
syntax on
set number
set autoindent

" centralize swap files
set directory^=$HOME/.vim/tmp//

set smarttab
set expandtab
set tabstop=4
set shiftwidth=4

set clipboard=unnamed

" allow backspace in insert mode
set backspace=indent,eol,start

" disable error bells
set noerrorbells

set pastetoggle=<leader>pt"}}}

" Plugins{{{
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired'

Plug 'vim-airline/vim-airline'

Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'fatih/vim-go', { 'for': 'go' }

Plug 'christoomey/vim-tmux-navigator'

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vader.vim'
Plug 'junegunn/gv.vim'

" tabular is required for vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

Plug 'chrismaher/vim-dbt'
Plug 'chrismaher/vim-lookml'

call plug#end()"}}}

" Functions{{{
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
endfunction"}}}

" Mappings{{{
" leaders
let mapleader = ","
let maplocalleader = "\\"

" .vimrc editing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" remap insert-mode escape
inoremap jk <esc>
inoremap <esc> <nop>

" yank to system clipboard
noremap <leader>y "*y

" map vim exits
noremap <leader>w :w<cr>
noremap <leader>q :qa<cr>
noremap <leader>Q :qa!<cr>
noremap <leader>z :wa <bar> :qa <cr>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" insert lines from normal mode
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<cr>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<cr>

" buffer mappings
noremap <leader>bn :bn<cr>

" visually select pasted text
nnoremap gp `[v`]

noremap <leader>tw :call TrimWhitespace()<cr>

" inoremap <C-o> <esc>O}}}

" Plugin Settings & Mappings{{{

" NERDCommenter
let g:NERDSpaceDelims = 1

" NERDTree
noremap <leader>nt :NERDTreeToggle<cr>

" VimWiki
let g:vimwiki_list = [{ 'path': '~/.wiki/', 'syntax':'markdown', 'ext': '.md' }]

" Fugitive
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :Gdiffsplit!<cr>"}}}

" SQL Functions & Abbreviations{{{

" SQL Keywords {{{
let s:keywords = [
    \   'absolute'
    \ , 'action'
    \ , 'add'
    \ , 'after'
    \ , 'all'
    \ , 'allocate'
    \ , 'alter'
    \ , 'and'
    \ , 'any'
    \ , 'are'
    \ , 'array'
    \ , 'as'
    \ , 'asc'
    \ , 'asensitive'
    \ , 'assertion'
    \ , 'asymmetric'
    \ , 'at'
    \ , 'atomic'
    \ , 'authorization'
    \ , 'avg'
    \ , 'before'
    \ , 'begin'
    \ , 'between'
    \ , 'bigint'
    \ , 'binary'
    \ , 'bit'
    \ , 'bit_length'
    \ , 'blob'
    \ , 'boolean'
    \ , 'both'
    \ , 'breadth'
    \ , 'by'
    \ , 'call'
    \ , 'called'
    \ , 'cascade'
    \ , 'cascaded'
    \ , 'case'
    \ , 'cast'
    \ , 'catalog'
    \ , 'char'
    \ , 'character'
    \ , 'character_length'
    \ , 'char_length'
    \ , 'check'
    \ , 'clob'
    \ , 'close'
    \ , 'coalesce'
    \ , 'collate'
    \ , 'collation'
    \ , 'column'
    \ , 'commit'
    \ , 'condition'
    \ , 'connect'
    \ , 'connection'
    \ , 'constraint'
    \ , 'constraints'
    \ , 'constructor'
    \ , 'contains'
    \ , 'continue'
    \ , 'convert'
    \ , 'corresponding'
    \ , 'count'
    \ , 'create'
    \ , 'cross'
    \ , 'cube'
    \ , 'current'
    \ , 'current_date'
    \ , 'current_default_transform_group'
    \ , 'current_path'
    \ , 'current_role'
    \ , 'current_time'
    \ , 'current_timestamp'
    \ , 'current_transform_group_for_type'
    \ , 'current_user'
    \ , 'cursor'
    \ , 'cycle'
    \ , 'data'
    \ , 'date'
    \ , 'day'
    \ , 'deallocate'
    \ , 'dec'
    \ , 'decimal'
    \ , 'declare'
    \ , 'default'
    \ , 'deferrable'
    \ , 'deferred'
    \ , 'delete'
    \ , 'depth'
    \ , 'deref'
    \ , 'desc'
    \ , 'describe'
    \ , 'descriptor'
    \ , 'deterministic'
    \ , 'diagnostics'
    \ , 'disconnect'
    \ , 'distinct'
    \ , 'do'
    \ , 'domain'
    \ , 'double'
    \ , 'drop'
    \ , 'dynamic'
    \ , 'each'
    \ , 'element'
    \ , 'else'
    \ , 'elseif'
    \ , 'end'
    \ , 'equals'
    \ , 'escape'
    \ , 'except'
    \ , 'exception'
    \ , 'exec'
    \ , 'execute'
    \ , 'exists'
    \ , 'exit'
    \ , 'external'
    \ , 'extract'
    \ , 'false'
    \ , 'fetch'
    \ , 'filter'
    \ , 'first'
    \ , 'float'
    \ , 'for'
    \ , 'foreign'
    \ , 'found'
    \ , 'free'
    \ , 'from'
    \ , 'full'
    \ , 'function'
    \ , 'general'
    \ , 'get'
    \ , 'global'
    \ , 'go'
    \ , 'goto'
    \ , 'grant'
    \ , 'group'
    \ , 'grouping'
    \ , 'handler'
    \ , 'having'
    \ , 'hold'
    \ , 'hour'
    \ , 'identity'
    \ , 'if'
    \ , 'immediate'
    \ , 'in'
    \ , 'indicator'
    \ , 'initially'
    \ , 'inner'
    \ , 'inout'
    \ , 'input'
    \ , 'insensitive'
    \ , 'insert'
    \ , 'int'
    \ , 'integer'
    \ , 'intersect'
    \ , 'interval'
    \ , 'into'
    \ , 'is'
    \ , 'isolation'
    \ , 'iterate'
    \ , 'join'
    \ , 'key'
    \ , 'language'
    \ , 'large'
    \ , 'last'
    \ , 'lateral'
    \ , 'leading'
    \ , 'leave'
    \ , 'left'
    \ , 'level'
    \ , 'like'
    \ , 'local'
    \ , 'localtime'
    \ , 'localtimestamp'
    \ , 'locator'
    \ , 'loop'
    \ , 'lower'
    \ , 'map'
    \ , 'match'
    \ , 'max'
    \ , 'member'
    \ , 'merge'
    \ , 'method'
    \ , 'min'
    \ , 'minute'
    \ , 'modifies'
    \ , 'module'
    \ , 'month'
    \ , 'multiset'
    \ , 'names'
    \ , 'national'
    \ , 'natural'
    \ , 'nchar'
    \ , 'nclob'
    \ , 'new'
    \ , 'next'
    \ , 'no'
    \ , 'none'
    \ , 'not'
    \ , 'null'
    \ , 'nullif'
    \ , 'numeric'
    \ , 'object'
    \ , 'octet_length'
    \ , 'of'
    \ , 'old'
    \ , 'on'
    \ , 'only'
    \ , 'open'
    \ , 'option'
    \ , 'or'
    \ , 'order'
    \ , 'ordinality'
    \ , 'out'
    \ , 'outer'
    \ , 'output'
    \ , 'over'
    \ , 'overlaps'
    \ , 'pad'
    \ , 'parameter'
    \ , 'partial'
    \ , 'partition'
    \ , 'path'
    \ , 'position'
    \ , 'precision'
    \ , 'prepare'
    \ , 'preserve'
    \ , 'primary'
    \ , 'prior'
    \ , 'privileges'
    \ , 'procedure'
    \ , 'public'
    \ , 'range'
    \ , 'read'
    \ , 'reads'
    \ , 'real'
    \ , 'recursive'
    \ , 'ref'
    \ , 'references'
    \ , 'referencing'
    \ , 'relative'
    \ , 'release'
    \ , 'repeat'
    \ , 'resignal'
    \ , 'restrict'
    \ , 'result'
    \ , 'return'
    \ , 'returns'
    \ , 'revoke'
    \ , 'right'
    \ , 'role'
    \ , 'rollback'
    \ , 'rollup'
    \ , 'routine'
    \ , 'row'
    \ , 'rows'
    \ , 'savepoint'
    \ , 'schema'
    \ , 'scope'
    \ , 'scroll'
    \ , 'search'
    \ , 'second'
    \ , 'section'
    \ , 'select'
    \ , 'sensitive'
    \ , 'session'
    \ , 'session_user'
    \ , 'set'
    \ , 'sets'
    \ , 'signal'
    \ , 'similar'
    \ , 'size'
    \ , 'smallint'
    \ , 'some'
    \ , 'space'
    \ , 'specific'
    \ , 'specifictype'
    \ , 'sql'
    \ , 'sqlcode'
    \ , 'sqlerror'
    \ , 'sqlexception'
    \ , 'sqlstate'
    \ , 'sqlwarning'
    \ , 'start'
    \ , 'state'
    \ , 'static'
    \ , 'submultiset'
    \ , 'substring'
    \ , 'sum'
    \ , 'symmetric'
    \ , 'system'
    \ , 'system_user'
    \ , 'table'
    \ , 'tablesample'
    \ , 'temporary'
    \ , 'then'
    \ , 'time'
    \ , 'timestamp'
    \ , 'timezone_hour'
    \ , 'timezone_minute'
    \ , 'to'
    \ , 'trailing'
    \ , 'transaction'
    \ , 'translate'
    \ , 'translation'
    \ , 'treat'
    \ , 'trigger'
    \ , 'trim'
    \ , 'true'
    \ , 'under'
    \ , 'undo'
    \ , 'union'
    \ , 'unique'
    \ , 'unknown'
    \ , 'unnest'
    \ , 'until'
    \ , 'update'
    \ , 'upper'
    \ , 'usage'
    \ , 'user'
    \ , 'using'
    \ , 'value'
    \ , 'values'
    \ , 'varchar'
    \ , 'varying'
    \ , 'view'
    \ , 'when'
    \ , 'whenever'
    \ , 'where'
    \ , 'while'
    \ , 'window'
    \ , 'with'
    \ , 'within'
    \ , 'without'
    \ , 'work'
    \ , 'write'
    \ , 'year'
    \ , 'zone'
    \ ]"}}}

function! s:IsNotComment()
    return synIDattr(synIDtrans(synID(line("."), col(".") - 1, 0)), "name") !~# 'Comment\|String'
endfunction

function! s:UppercaseKeyword(text)
    if s:IsNotComment()
        return toupper(a:text)
    else
        return a:text
    endif
endfunction

function! s:UppercaseSQL()
    let joined = join(map(copy(s:keywords), {_, v -> '\<' . v . '\>'}), '\|')

    while search(joined, 'c')
        if s:IsNotComment()
            exe 's/' . joined . '/\U&/'
        endif
    endwhile
endfunction

function! s:SQLAbbrevs()
    for keyword in s:keywords
        exe 'iab <expr> <buffer> ' . keyword . ' <SID>UppercaseKeyword(' . "'" . keyword . "')"
    endfor
endfunction"}}}

" Filetype Settings{{{
if has("autocmd")
    filetype on
    autocmd BufReadPost fugitive://* set bufhidden=delete " clean fugitive Gedit buffers

    " dbt{{{
    augroup filetype_dbt
        autocmd!
        autocmd FileType dbt setlocal ts=4 sts=4 sw=4 et
        autocmd FileType dbt nmap <leader>u :call <SID>Preserve(function('<SID>UppercaseSQL'))<CR>
        autocmd FileType dbt call <SID>SQLAbbrevs()
    augroup END"}}}

    " Go{{{
    augroup filetype_go
        autocmd!
        autocmd FileType go setlocal autowrite ts=8 sts=8 sw=8 noet
        autocmd FileType go nmap <leader>b <Plug>(go-build)
        autocmd FileType go nmap <leader>r <Plug>(go-run)
    augroup END"}}}

    " Haskell{{{
    augroup filetype_haskell
        autocmd!
        autocmd FileType haskell setlocal ts=4 sts=4 sw=4 et
    augroup END"}}}

    " LookML{{{
    augroup filetype_lookml
        autocmd!
        autocmd FileType lookml setlocal ts=2 sts=2 sw=2 et
        let @d=':s/\s*\(.*\)/\tdimension: \1 {\r\t\ttype: string\r\t\tdescription: ""\r\t}/\<CR>'
    augroup END"}}}

    " Python{{{
    augroup filetype_python
        autocmd!
        autocmd FileType python setlocal ts=4 sts=4 sw=4 et
    augroup END"}}}

    " Shell{{{
    augroup filtetype_sh
        autocmd!
        autocmd FileType sh setlocal foldmethod=marker ts=4 sts=4 sw=4 et
    augroup End"}}}

    " SQL{{{
    augroup filetype_sql
        autocmd!
        autocmd FileType sql setlocal ts=4 sts=4 sw=4 et
        autocmd FileType sql nmap <silent> <leader>u :call <SID>Preserve(function('<SID>UppercaseSQL'))<CR>
        autocmd FileType sql call <SID>SQLAbbrevs()
    augroup END"}}}

    " Vimscript{{{
    augroup filtetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker ts=4 sts=4 sw=4 et
    augroup End"}}}

    " VimWiki{{{
    augroup filetype_vimwiki
        autocmd!
        autocmd FileType vimwiki set ft=markdown
    augroup End"}}}

    " YAML{{{
    augroup filetype_yaml
        autocmd!
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 et
    augroup End"}}}
endif"}}}
