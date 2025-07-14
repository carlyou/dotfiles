"--------------------
" .vimrc by Carl You
"--------------------
set incsearch
set hlsearch
set ignorecase
set smartcase

set laststatus=2
set linebreak
set listchars=tab:▸\ ,eol:¬

set tabstop=2 " spaces per tab
set softtabstop=2 " spaces per tab (when tabbing/backspacing)
set shiftwidth=2 " spaces per tab (when shifting)
set expandtab " always use spaces instead of tabs
set shiftround

set showcmd
set number
set smartindent
filetype plugin indent on
syntax on

set nobackup
set nowritebackup
set noswapfile

set modelines=0     " CVE-2007-2438
set nocompatible    " Use Vim defaults instead of 100% vi compatibility
set backspace=2     " more powerful backspacing

set autochdir

"--------------------
" GUI/MacVim options
"--------------------
set guifont=Monaco:h12
if has("gui_macvim")
  "set transparency=1
  set cursorline
endif
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

"--------------------
" Key Mapping
"--------------------
vnoremap Y "*y

noremap 0 ^
noremap LL <C-w>l
noremap HH <C-w>h
noremap <Space> :noh<CR>


"--------------------
" Plugs
"--------------------
call plug#begin()
" The default plugin directory will be as follows:
"   - Vim (Linux/macOS): '~/.vim/plugged'
"   - Vim (Windows): '~/vimfiles/plugged'
"   - Neovim (Linux/macOS/Windows): stdpath('data') . '/plugged'
" You can specify a custom plugin directory by passing it as the argument
"   - e.g. `call plug#begin('~/.vim/plugged')`
"   - Avoid using standard Vim directory names like 'plugin'

Plug 'github/copilot.vim'

" Make sure you use single quotes
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'preservim/nerdcommenter'
Plug 'kien/ctrlp.vim'
Plug 'jparise/vim-graphql'
Plug 'udalov/kotlin-vim'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-surround'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'XadillaX/json-formatter.vim'

" File types
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" colors
"Plug 'flazz/vim-colorschemes'
"Plug 'gertjanreynaert/cobalt2-vim-theme'
"Plug 'gregsexton/Atom'
"Plug 'haishanh/night-owl.vim'
"Plug 'joshdick/onedark.vim'
"Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'nordtheme/vim'
"Plug 'rhysd/vim-color-spring-night'


" Initialize plugin system
" - Automatically executes `filetype plugin indent on` and `syntax enable`.
call plug#end()
" You can revert the settings after the call like so:
"   filetype indent off   " Disable file-type-specific indentation
"   syntax off            " Disable syntax highlighting

"--------------------
" Plug: copilot
"--------------------
let g:copilot_node_command = "/opt/homebrew/bin/node"

"--------------------
" Plug: nerdtree
"--------------------
noremap <leader>/ :NERDTree<CR>

"--------------------
" Plug: gitgutter
"--------------------
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0


"--------------------
" Plug: vim-easy-align
"--------------------
vnoremap <silent> <Enter> :EasyAlign<Enter>
let g:easy_align_ignore_groups    = ['Comment', 'String']
let g:easy_align_ignore_unmatched = 1

"--------------------
" Plug: airline
"--------------------
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.whitespace = 'Ξ'
"let g:airline_section_b = ''
"let g:airline_section_c = '%t'
"let g:airline_section_x = '%{getcwd()}'
let g:airline_section_b = '%{getcwd()}'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename

"--------------------
" Plug: fzf
"--------------------
command! -bang -nargs=* GGrep
      \ call fzf#vim#grep(
      \   'git grep --line-number '.shellescape(<q-args>), 0,
      \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
command! -nargs=? -bang -complete=dir FzfFiles
      \ call fzf#vim#files(<q-args>, <bang>O ? fzf#vim#with_preview('up:60%') : {}, <bang>O)

noremap     <leader>f   :Files!<CR>
noremap     <leader><leader>f   :Files! ~<CR>

noremap     <leader>g   :GFiles!<CR>
noremap     <leader><leader>g   :GGrep!<CR>
"

"--------------------
" File types
"--------------------
"autocmd BufRead,BufNewFile *.thrift set filetype=thrift
"autocmd! Syntax thrift source ~/.vim/thrift.vim

"--------------------
" Color
"--------------------
set background=dark

if (has("termguicolors"))
 set termguicolors
endif

" let g:material_theme_style = 'default' | 'palenight' | 'ocean' | 'lighter' | 'darker' | 'default-community' | 'palenight-community' | 'ocean-community' | 'lighter-community' | 'darker-community'
"let g:material_theme_style = 'darker'

"colorscheme night-owl
"let g:spring_night_high_contrast = 1
"colorscheme spring-night
color nord
hi Normal guifg=#d8dee9 guibg=#292e39
