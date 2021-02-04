set nocompatible
syntax on

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'zacgeis/base16-vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'mhinz/vim-signify'
call plug#end()

set hlsearch
set number
set showmatch
set incsearch
set background=dark
set hidden
set backspace=indent,eol,start
set ruler
set wrap
set dir=/tmp//
set scrolloff=5
set nofoldenable
" Requied to prevent Neovim from using a line cursor in insert.
set guicursor=
set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set ignorecase
set smartcase
set wildignore+=*.pyc,*.o,*.class

" base16 unified colorschemes
" vimrc_background comes from base16-shell
if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
endif

" Override fzf Files command to ignore specific directories.
" let $FZF_DEFAULT_COMMAND = ''
command! -bang -nargs=? -complete=dir ProjectFiles call fzf#vim#files(<q-args>, {'source': 'find * -path "*/\.*" -prune -o -path "build/*" -prune -o -path "out/*" -prune -o -type f -print -o -type l -print 2> /dev/null'})

" vim-lsp config
let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1 " enable signs
let g:lsp_diagnostics_highlights_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_diagnostics_signs_priority = 20 " Ensure lsp diagnostics have priority over vim-signify gutter signs.
let g:lsp_highlights_enabled = 1
let g:lsp_textprop_enabled = 0
let g:lsp_virtual_text_enabled = 0

let g:lsp_signs_error = {'text': 'E>'}
let g:lsp_signs_warning = {'text': 'W>'}
let g:lsp_signs_hint = {'text': 'H>'}
if executable('clangd')
  augroup lsp_clangd
    autocmd!
    autocmd User lsp_setup call lsp#register_server({
          \ 'name': 'clangd',
          \ 'cmd': {server_info->['clangd']},
          \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
          \ })
    autocmd FileType c setlocal omnifunc=lsp#complete
    autocmd FileType cpp setlocal omnifunc=lsp#complete
    autocmd FileType objc setlocal omnifunc=lsp#complete
    autocmd FileType objcpp setlocal omnifunc=lsp#complete
  augroup end
endif

let g:asyncomplete_auto_popup = 0
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction
inoremap <silent><expr> <TAB>
  \ pumvisible() ? "\<C-n>" :
  \ <SID>check_back_space() ? "\<TAB>" :
  \ asyncomplete#force_refresh()

map <silent> gh :LspHover<CR>
map <silent> gd :LspDefinition<CR>
map <silent> gr :LspReferences<CR>
map <silent> gf :LspDocumentRangeFormat<CR>
map <silent> gF :LspDocumentFormat<CR>

nnoremap <leader>cc :cclose<CR>
nnoremap ]q :cnext<CR>
nnoremap [q :cprev<CR>

" Ale config
" set completeopt-=preview
" let g:ale_completion_enabled = 1
" let g:ale_completion_delay = 100
" let g:ale_completion_max_suggestions = 50
" imap <C-X><C-O> <Plug>(ale_complete)
" let g:ale_set_highlights = 0
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_linters_explicit = 1
" let g:ale_list_window_size = 3
" let g:ale_linters = {
"       \   'rust': ['rustc', 'cargo'],
"       \   'go': ['go build', 'goimports'],
"       \   'ruby': ['ruby'],
"       \   'python': ['pyls'],
"       \}
"       " \   'c': ['clangd'],
"       " \   'cpp': ['clangd'],
" map <silent> gh :ALEHover<CR>
" map <silent> gd :ALEGoToDefinition<CR>
" map <silent> gr :ALEFindReferences<CR>

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let g:rubycomplete_buffer_loading = 1

let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let go_highlight_trailing_whitespace_error = 0

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType tex setlocal textwidth=80
autocmd Filetype go setlocal noexpandtab
autocmd Filetype scheme setlocal expandtab
autocmd FileType rust setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd BufNewFile,BufRead *.txt setlocal textwidth=80
autocmd BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown textwidth=80

imap <C-p> ->
map <silent> <C-p> :ProjectFiles<CR>
map <silent> <LocalLeader>rt :!echo "Generating ctags" && ctags -R --exclude=".git" --exclude="log" --exclude="tmp" --exclude="db" --exclude="pkg" --exclude="deps" --exclude="_build" --extra=+f --fields=+l --langmap=c:.c.h --langmap=c++:.c++.c.cc.cpp.h .<CR>
map <silent> <LocalLeader>ff :ProjectFiles<CR>
map <silent> <LocalLeader>fa :Files<CR>
map <silent> <LocalLeader>fb :Buffers<CR>
map <silent> <LocalLeader>ft :Tags<CR>
map <silent> <LocalLeader>nh :nohls<CR>
map <silent> <LocalLeader>bd :bufdo :bd<CR>
map <silent> <LocalLeader>cc :TComment<CR>
map <silent> <LocalLeader>sc :setlocal spell! spelllang=en_us<CR>
" set compiler and makeprg with make
map <LocalLeader>m :make<CR>

function! GrepPattern(pattern)
  cgetexpr system("grep -nIr --exclude-dir=.* --exclude-dir=*build* --exclude=tags --exclude=.* '" . a:pattern . "'")
  cwin
endfunction
function! GrepWord()
  call GrepPattern(expand("<cword>"))
endfunction
function! GrepPrompt()
  let l:pattern = input("Pattern: ")
  call GrepPattern(l:pattern)
endfunction
command! -nargs=0 GrepWord :call GrepWord()
map <silent> gw :GrepWord<CR>
command! -nargs=0 GrepPrompt :call GrepPrompt()
map <silent> gp :GrepPrompt<CR>

nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

" Highlight trailing whitespace
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd BufRead,InsertLeave * match ExtraWhitespace /\s\+$/

" Remove trailing whitespace
autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e

" Set up highlight group & retain through colorscheme changes
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

set laststatus=2
set statusline=
set statusline+=%<\                       " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\        " buffer number, and flags
set statusline+=%-40f\                    " relative path
set statusline+=%=                        " seperate between right- and left-aligned
set statusline+=%1*%y%*%*\                " file type
set statusline+=%10(L(%l/%L)%)\           " line
set statusline+=%2(C(%v/125)%)\           " column
set statusline+=%P                        " percentage of file

if version >= 703
  set undodir=~/.vim/undodir
  set undofile
  set undoreload=10000 "maximum number lines to save for undo on a buffer reload
endif
set undolevels=1000 "maximum number of changes that can be undone

" for :e **/* autocomplete display
set wildmenu

" Shortcut for new tabs
nmap gn :tabnew<cr>

" Prevent automatic comment insertion on newlines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Remove trailing whitespace
autocmd FileType * autocmd BufWritePre <buffer> :%s/\s\+$//e

" Quick cycle through buffers
" nnoremap <Tab> :bnext <CR>
" nnoremap <S-Tab> :bprevious<CR>

" NerdTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

" Disable escape
inoremap <Esc> <Nop>
vnoremap <Esc> <Nop>

" Fix Ctrl-C block insert mode
inoremap <C-c> <Esc>
vnoremap <C-c> <Esc>

" Chicken Scheme
nmap <silent> <leader>sf :call SchemeEvalDefun()<cr>
nmap <silent> <leader>sb :call SchemeSendSexp("(load \"" . expand("%:p") . "\")\n")<cr>
nmap <silent> <leader>se :call SchemeNew()<cr>
nmap <silent> <leader>sq :call SchemeQuit()<cr>

function! SchemeEvalDefun()
    let pos = getpos('.')
    silent! exec "normal! 99[(yab"
    call SchemeSendSexp(@")
    call setpos('.', pos)
endfun

function! SchemeSendSexp(sexp)
    let ss = escape(a:sexp, '\"')
    call system("tmux send-keys -t 1 \"" . ss . "\n\"")
endfun

function! SchemeNew()
  call system("tmux send-keys -t 1 C-c C-l csi C-m")
endfun

function! SchemeQuit()
  call system("tmux send-keys -t 1 C-c C-d C-l")
endfun

augroup Binary
  au!
  au BufReadPre  *.bmp let &bin=1
  au BufReadPost *.bmp if &bin | %!xxd
  au BufReadPost *.bmp set ft=xxd | endif
  au BufWritePre *.bmp if &bin | %!xxd -r
  au BufWritePre *.bmp endif
  au BufWritePost *.bmp if &bin | %!xxd
  au BufWritePost *.bmp set nomod | endif
augroup END

" For project specific .vimrc files
set exrc
set secure
