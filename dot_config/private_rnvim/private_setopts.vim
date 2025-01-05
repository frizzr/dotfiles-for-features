" ------------------------------------------------------
" General vim configurations
"
" vim-sensible takes care of most of the really common configuration changes
" for us. These configurations are more personal and to my liking.
"
scriptencoding utf-8

set t_Co=256
set visualbell
silent! colorscheme Atelier_SeasideDark
set background=dark
set noshowmode
set textwidth=120

" Vertical split coloring
highlight VertSplit ctermbg=8 ctermfg=black
set fillchars+=vert:│

" Highlight coloring for cursor line and column
nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

set number     " Show line numbers
set nowrap     " Don't visually wrap lines
set cursorline " Highlight the current cursor line
set cursorcolumn " Highlight the current cursor column
set hidden     " Allow buffer switching without having to save
set list       " Show non-printable characters
set hlsearch   " Highlight searched text
set ignorecase " Ignore case when searching
set smartcase  " Don't ignore case when using uppercase in a search
set confirm    " Ask for confirmation when closing unsaved files
set nu
set diffopt=iwhite
set errorformat=\ %#%f(%l\\\,%c):\ %m
set termguicolors
"set foldmethod=syntax
"set foldlevel=1

" Incremental scrolling
set sidescroll=1
set sidescrolloff=1
set nosol

" Don't autoselect the first entry when doing completion
set completeopt=longest,menuone

" Tab configurations
set smartindent expandtab tabstop=4 shiftwidth=4

" Ignore cache type files
set wildignore+=*/cache/*,*.sassc

" Better list characters
set listchars=tab:\›\ ,trail:-
highlight SpecialKey ctermbg=8 ctermfg=10

" Clear the background of the sign column (guter)
highlight clear SignColumn

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
  "setglobal bomb
  set fileencodings=ucs-bom,utf-8,latin1
endif

set sessionoptions+=winpos,terminal,folds

" Open help windows on the right in a vertical split
augroup help_win
  au!
  au FileType help wincmd L
augroup END

" Lightline plugin configuration
" ----------------------------
let g:lightline = {
      \ 'colorscheme': 'ayu_mirage',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'gitbranch', 'fileformat', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

let g:clipboard = {
  \   'name': 'WslClipboard',
  \   'copy': {
  \      '+': 'clip.exe',
  \      '*': 'clip.exe',
  \    },
  \   'paste': {
  \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  \   },
  \   'cache_enabled': 0,
  \ }

" Neotree configuration
" -----------------------
nnoremap <leader>co :Neotree toggle<CR>

if !has("gui_running")
    set t_Co=256
endif

" Toggle whitespace to be ignored in vimdiff with gs
" ----------------------------------------
 if &diff
     map gs :call IwhiteToggle()<CR>
     function! IwhiteToggle()
       if &diffopt =~ 'iwhite'
         set diffopt-=iwhite
       else
         set diffopt+=iwhite
       endif
     endfunction
 endif

" ------------------------------------------------------
"  Mappings

map <f1> :Neotree toggle<CR>
map <f2> :copen<CR>
map <f3> :cclose<CR>
"map <f5> :lcd %:p:h<CR>:!buildThis<CR>
"
"<f6> and <f7> used in gvim (gui.vim) only - open for console vim
"
map <f8> :TagbarToggle<CR>
"let g:spf13_edit_config_mapping='<f9>'
map <f10> :windo diffthis<CR>
map <f11> :windo diffoff<CR>
"let g:spf13_apply_config_mapping='<f12>'
"
nnoremap <space>gxa :Git add %:p<CR><CR>
nnoremap <space>gxs :Gstatus<CR>
nnoremap <space>gxc :Gcommit<CR>
nnoremap <space>gxd :Gdiff<CR>
nnoremap <leader>vh :vsp %:r.h*<CR>
nnoremap <leader>vc :vsp %:r.c*<CR>
nnoremap <leader>sh :sp %:r.h*<CR>
nnoremap <leader>sc :sp %:r.c*<CR>
nnoremap <leader>ec :e ++enc=cp1252<CR>
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
nnoremap <space><C-S-h> <nop>
noremap <Right> <nop>
nnoremap <space><C-S-l> <nop>

cabbrev vb vert sb

" ------------------------------------------------------
" File type specific configurations
" Mostly consisting of Auto commands applied when matching files are opened

autocmd BufReadPost fugitive://* set bufhidden=delete

" Return to last edit position when opening files
" (https://rogin.xyz/blog/sensible-neovim)
" -----------------------
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd User fugitive 
  \ if get(b:, 'fugitive_type', '') =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif

augroup my_fts
  au BufRead,BufNewFile *.md        set filetype=markdown
  au BufRead,BufNewFile *.rt        set filetype=html
  au BufRead,BufNewFile *.raml      set filetype=yaml
  au BufRead,BufNewFile *Jenkinsfile set syntax=groovy
augroup END

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

if has("gui_running")
  scriptencoding utf-8

  set guioptions -=mrLT
  "set guifont=Source_Code_Pro_for_Powerline:h9:cANSI:qDRAFT
  "set guifont=Space_Mono_for_Powerline:h7:cANSI:qDRAFT
  "set guifont=@D2Coding_ligature:h10:cANSI
  "set guifont=Hack_NF:h9:cANSI:qDRAFT
" set guifont=CaskaydiaCove_NF:h11:cANSI:qDRAFT
set guifont=Iosevka_Nerd_Font_Mono:h11:cANSI:qDRAFT
  colorscheme darkblue
endif

