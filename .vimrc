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

set splitright

if has("persistent_undo")
    set undodir=~/.vim/undodir
    set undofile
endif

" Keep 200 lines of command history
set history=200

"}}}

" Plugins{{{
call plug#begin('~/.vim/plugged')

Plug 'christoomey/vim-tmux-navigator'

" Plug 'dense-analysis/ale', { 'for': 'haskell' }

Plug 'fatih/vim-go', { 'for': 'go' }

Plug 'git@github-personal:chrismaher/vim-dbt'
Plug 'git@github-personal:chrismaher/vim-lookml.git'
Plug 'git@github-personal:chrismaher/vim-sql-case.git', { 'for': 'sql' }

Plug 'junegunn/vim-easy-align'
Plug 'junegunn/vader.vim'
Plug 'junegunn/gv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'mbbill/undotree'

Plug 'mileszs/ack.vim'

Plug 'nvie/vim-flake8', { 'for': 'python' }

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

function! ToggleDiff()
    if &diff == 1
        :diffoff
    else
        NERDTreeClose
        windo diffthis
    endif
endfunction

" let g:quickfix_is_open = 0
" function! QuickfixToggle()
    " if g:quickfix_is_open
        " cclose
        " let g:quickfix_is_open = 0
    " else
        " copen
        " let g:quickfix_is_open = 1
    " endif
" endfunction

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

" open leader single-key mappings
" nnoremap <leader>.
" nnoremap <leader><bar>
" nnoremap <leader>[
" nnoremap <leader>]
" nnoremap <leader>-
" nnoremap <leader>=

" open leader mappings
" nnoremap <leader>m
" nnoremap <leader>k
" nnoremap <leader>j

" .vimrc editing
nnoremap <silent> <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" remap insert-mode escape
inoremap jk <esc>
inoremap <esc> <nop>

" yank to system clipboard
noremap <leader>y "*y

" list buffers
nnoremap <leader>, :buffers<cr>

" list registers
nnoremap <leader>; :registers<cr>

" vim exits
noremap <leader>w :w<cr>
noremap <leader>q :q<cr>
noremap <leader>Q :q!<cr>
noremap <leader>qa :qa<cr>
noremap <leader>Qa :qa!<cr>
" noremap <leader>z :wa <bar> :qa<cr>

" open alternate buffer in a vertical split
nnoremap <leader>sb :vertical sbuffer #<cr>

" window operations
nnoremap <silent> <leader>vn :vnew<cr>
nnoremap <silent> <leader>wr <c-w>R
nnoremap <silent> <leader>wt <c-w>T
nnoremap <silent> <leader>wo <c-w>o

" tab operations
nnoremap <silent> <leader>te :tabedit<cr>
nnoremap <silent> <leader>tn :tabnext<cr>
nnoremap <silent> <leader>tp :tabprevious<cr>
nnoremap <silent> <leader>tc :tabclose<cr>
nnoremap <silent> <leader>tm :tabmove +1<cr>
nnoremap <silent> <leader>tM :tabmove -1<cr>
nnoremap <silent> <leader>tf :tabfirst<cr>
nnoremap <silent> <leader>tl :tablast<cr>

" visually select pasted text
nnoremap <leader>vp `[v`]
nnoremap <leader>v= `[v`]=
nnoremap <leader>< V`]<
nnoremap <leader>> V`]>

" change matches with cgn, starting with the word under the cursor
nnoremap <silent> <leader>cw :let @/=expand('<cword>')<cr>cgn

" wrap words in single or double quotes
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel

" change directory
nnoremap <leader>up :tcd ..<cr>
nnoremap <silent> <leader>cd :tcd %:p:h<cr>

" change filetype
nnoremap <leader>sq :set filetype=sql<cr>

" noremap <leader>rt :%retab<cr>

noremap <leader>tw :call TrimWhitespace()<cr>

noremap <silent> <leader>ti :call ToggleInteractiveShell()<cr>
noremap <silent> <leader>dt :call ToggleDiff()<cr>
nnoremap <silent> <leader>qt :call QuickfixToggle()

" open & close terminal buffer
nnoremap <silent> <leader>ht :terminal<cr>
nnoremap <silent> <leader>vt :vertical terminal<cr>
tnoremap <esc> <C-\><C-n>:bd!<cr>

" run 'throwaway' macros in the q register with Q
nnoremap Q @q

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

" Ack
if executable('rg')
    let g:ackprg = 'rg --vimgrep'
endif
nnoremap <leader>ac :Ack <cword><cr>

" EasyAlign
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Fugitive
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :Gdiffsplit!<cr>

" GV
noremap <leader>gv :GV<cr>

" NERDTree
noremap <leader>nt :NERDTreeToggle<cr>

" Undotree
noremap <leader>ut :UndotreeToggle<cr>

" VimWiki
let g:vimwiki_list = [{ 'path': '~/.wiki/', 'syntax':'markdown', 'ext': '.md' }]

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

nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>F :GFiles<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>l :BLines<CR>
nnoremap <silent> <leader>L :Lines<CR>
nnoremap <silent> <leader>' :Marks<CR>
nnoremap <silent> <leader>/ :Rg<CR>
" nnoremap <silent> <leader>C :Commits<CR>
nnoremap <silent> <leader>C :Commands<CR>
nnoremap <silent> <leader>H :Helptags<CR>
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
    augroup END"}}}

    " Vimscript{{{
    augroup filtetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup End"}}}

    " VimWiki{{{
    augroup filetype_vimwiki
        autocmd!
        autocmd FileType vimwiki set ft=markdown
    augroup End"}}}

    " YAML{{{
    augroup filetype_yaml
        autocmd!
        autocmd FileType yaml setlocal tabstop=2 sts=2 shiftwidth=2
    augroup End"}}}
endif"}}}
