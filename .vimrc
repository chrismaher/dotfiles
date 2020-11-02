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
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'ctrlpvim/ctrlp.vim'
" Plug 'dense-analysis/ale', { 'for': 'haskell' }

" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" Plug 'SirVer/ultisnips'

" Plug 'mbbill/undotree'

Plug 'mileszs/ack.vim'

Plug 'git@github-personal:chrismaher/vim-dbt'
Plug 'git@github-personal:chrismaher/vim-lookml.git'
Plug 'git@github-personal:chrismaher/vim-sql-case.git', { 'for': 'sql' }

call plug#end()"}}}

" Functions{{{
" tabline
function MyTabLabel(n)
    return fnamemodify(getcwd(tabpagewinnr(a:n), a:n), ':~')
endfunction

function! MyTabLine()
    let s = ''
    for i in range(tabpagenr('$'))
    " select the highlighting
        if i + 1 == tabpagenr()
            let s .= '%#TabLineSel#'
        else
            let s .= '%#TabLine#'
        endif

        " set the tab page number (for mouse clicks)
        let s .= '%' . (i + 1) . 'T'

        " the label is made by MyTabLabel()
        let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
    endfor

    " after the last tab fill with TabLineFill and reset tab page nr
    let s .= '%#TabLineFill#%T'

    " right-align the label to close the current tab page
    if tabpagenr('$') > 1
        let s .= '%=%#TabLine#%999Xclose'
    endif

    return s
endfun
set tabline=%!MyTabLine()

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

" :Z command to switch to frecent directories
function! s:z(a, l, p)
    let list = systemlist('_z -l ' . a:a)
    return map(list, {_, v -> substitute(v, '\S\+\s\+', '', '')})
endfunction
command! -nargs=1 -complete=customlist,<SID>z Z execute 'tcd ' . <SID>z(<q-args>, '', '')[0]

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
noremap <leader>q :q<cr>
noremap <leader>qq :q!<cr>
noremap <leader>qa :qa<cr>
noremap <leader>qqa :qa!<cr>
" noremap <leader>z :wa <bar> :qa<cr>

" map tab operations
nnoremap <silent> <leader>tn :tabnew<cr>
nnoremap <silent> <leader>tc :tabclose<cr>
nnoremap <silent> <leader>tf :tabfirst<cr>
nnoremap <silent> <leader>tl :tablast<cr>
" nnoremap <leader>tm :tabmove<space>

nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" add escape without entering insert mode
nnoremap <leader>\ i\\<esc>

" insert lines from normal mode
nnoremap <silent> <leader>o :<C-u>call append(line("."),   repeat([""], v:count1))<cr>
nnoremap <silent> <leader>O :<C-u>call append(line(".")-1, repeat([""], v:count1))<cr>

" buffer mappings
noremap <leader>bn :bn<cr>

" visually select pasted text
nnoremap gp `[v`]

nnoremap <leader>rt :%retab<cr>

noremap <leader>tw :call TrimWhitespace()<cr>
noremap <silent> <leader>ti :call ToggleInteractiveShell()<cr>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
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
nnoremap <leader>gd :Gdiffsplit!<cr>

" fzf{{{
" autocmd! FileType fzf
" autocmd  FileType fzf set noshowmode noruler nonu

" if exists('$TMUX')
  " let g:fzf_layout = { 'tmux': '-p90%,60%' }
" else
  " let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" endif

" nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":Files\<cr>"
" nnoremap <silent> <Leader>C        :Colors<CR>
" nnoremap <silent> <Leader><Enter>  :Buffers<CR>
" nnoremap <silent> <Leader>L        :Lines<CR>
" nnoremap <silent> <Leader>ag       :Ag <C-R><C-W><CR>
" nnoremap <silent> <Leader>AG       :Ag <C-R><C-A><CR>
" xnoremap <silent> <Leader>ag       y:Ag <C-R>"<CR>
" nnoremap <silent> <Leader>`        :Marks<CR>
" nnoremap <silent> q: :History:<CR>
" nnoremap <silent> q/ :History/<CR>

" inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')
" imap <c-x><c-k> <plug>(fzf-complete-word)
" imap <c-x><c-f> <plug>(fzf-complete-path)
" inoremap <expr> <c-x><c-d> fzf#vim#complete#path('blsd')
" imap <c-x><c-j> <plug>(fzf-complete-file-ag)
" imap <c-x><c-l> <plug>(fzf-complete-line)

" nmap <leader><tab> <plug>(fzf-maps-n)
" xmap <leader><tab> <plug>(fzf-maps-x)
" omap <leader><tab> <plug>(fzf-maps-o)

" function! s:plug_help_sink(line)
  " let dir = g:plugs[a:line].dir
  " for pat in ['doc/*.txt', 'README.md']
    " let match = get(split(globpath(dir, pat), "\n"), 0, '')
    " if len(match)
      " execute 'tabedit' match
      " return
    " endif
  " endfor
  " tabnew
  " execute 'Explore' dir
" endfunction

" command! PlugHelp call fzf#run(fzf#wrap({
  " \ 'source': sort(keys(g:plugs)),
  " \ 'sink':   function('s:plug_help_sink')}))

" from https://github.com/junegunn/fzf.vim
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let options = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  if a:fullscreen
    let options = fzf#vim#with_preview(options)
  endif
  call fzf#vim#grep(initial_command, 1, options, a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

nnoremap <silent> <leader>B :Buffers<CR>
nnoremap <silent> <leader>C :Commits<CR>
nnoremap <silent> <leader>F :Files<CR>
nnoremap <silent> <leader>G :Rg<CR>
nnoremap <silent> <leader>L :Lines<CR>}}}
"}}}

" Filetype Settings{{{
if has("autocmd")
    filetype on
    autocmd BufReadPost fugitive://* set bufhidden=delete " clean fugitive Gedit buffers
    " autocmd CmdwinEnter * map <buffer> <leader><space> <CR>q:

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
        autocmd FileType python setlocal ts=4 sts=4 sw=4 textwidth=79 et
        autocmd FileType python set fileformat=unix
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
        " autocmd FileType sql nmap <silent> <leader>u :call <SID>Preserve(function('<SID>UppercaseSQL'))<CR>
        " autocmd FileType sql call <SID>SQLAbbrevs()
        autocmd FileType sql nmap <leader>sc <Plug>(sql-case)
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
