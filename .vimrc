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
set vb t_vb=

set pastetoggle=<leader>pt"}}}

" Plugins{{{
" use Pathogen to ensure local plugins are in runtimepath
call pathogen#infect()

"
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'
Plug 'preservim/nerdcommenter', { 'on': [] }

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-unimpaired', { 'on': [] }
Plug 'tpope/vim-dispatch', { 'on': [] }

Plug 'vim-airline/vim-airline', { 'on': [] }

Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'fatih/vim-go', { 'for': 'go' }

Plug 'christoomey/vim-tmux-navigator'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'dense-analysis/ale', { 'for': 'haskell' }

Plug 'junegunn/vader.vim', { 'on': [] }

" disable for now
Plug 'airblade/vim-gitgutter', { 'on': [] }
Plug 'godlygeek/tabular', { 'on': [] }

call plug#end()"}}}

" Functions{{{
" trim trailing whitespace
function! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

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

" .vimrc editing{{{
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>"}}}

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

" add escape without entering insert mode
nnoremap <leader>\ i\\<esc>

" plugin-related mappings{{{

" Nerdtree
noremap <leader>nt :NERDTreeToggle<cr>

" Fugitive
nnoremap <leader>gw :Gwrite<cr>
nnoremap <leader>gr :Gread<cr>
nnoremap <leader>gs :G<cr>
nnoremap <leader>gd :Gdiffsplit!<cr>"}}}

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

" inoremap <C-o> <esc>O}}}

" Filetype Settings{{{
if has("autocmd")
    filetype on
    autocmd BufReadPost fugitive://* set bufhidden=delete " clean fugitive Gedit buffers

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
    augroup END"}}}

    " Vimscript{{{
    augroup filtetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker ts=4 sts=4 sw=4 et
    augroup End"}}}

    " YAML{{{
    augroup filetype_yaml
        autocmd!
        autocmd FileType yaml setlocal ts=4 sts=4 sw=4 et
    augroup End"}}}
endif"}}}
