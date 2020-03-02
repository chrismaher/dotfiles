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

Plug 'junegunn/vader.vim'

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
endfun"}}}

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

noremap <leader>tw :call TrimWhitespace()<cr>

" inoremap <C-o> <esc>O}}}

" Filetype Settings{{{
if has("autocmd")
    filetype on
    autocmd BufReadPost fugitive://* set bufhidden=delete " clean fugitive Gedit buffers

    " Go{{{
    augroup filetype_go
        autocmd!
        autocmd FileType go setlocal autowrite ts=8 sts=8 sw=8 noet
        autocmd FileType go nmap <leader>b  <Plug>(go-build)
        autocmd FileType go nmap <leader>r  <Plug>(go-run)
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
        autocmd FileType yaml setlocal foldmethod=indent ts=2 sts=2 sw=2 et
    augroup End"}}}
endif"}}}
