 " Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" Change <Leader>
let mapleader = ","

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

"Added by Harry
let g:user_emmet_leader_key=","

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

:let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

set backspace=2   " Backspace deletes like most programs in insert mode

set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set cursorline    " highlight the current line the cursor is on
set complete=.,w,b,u,t,i
set ttyfast
set lazyredraw

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Numbers
set relativenumber
set number
set numberwidth=5

"sm:    flashes matching brackets or parentheses
set showmatch

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab
set re=1
set clipboard=unnamed

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·

"sta:   helps with backspacing because of expandtab
set smarttab

" When scrolling off-screen do so 3 lines at a time, not 1
set scrolloff=3

set guifont=Droid\ Mono\ Sans\ for\ Powerline\ Nerd\ CtrlP\ Types:h12
set encoding=utf8
let g:airline_powerline_fonts=1

" Enable tab complete for commands.
" first tab shows all matches. next tab starts cycling through the matches
set wildmenu

set spelllang=en_gb

if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
inoremap <S-Tab> <c-n>

let g:solarized_termcolors=256
set background=dark
colorscheme solarized

let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1

" Slit hack to enable changed files to be reloaded
filetype plugin indent on

augroup AutoSwap
        autocmd!
        autocmd SwapExists *  call AS_HandleSwapfile(expand('<afile>:p'), v:swapname)
augroup END

function! AS_HandleSwapfile (filename, swapname)
        " if swapfile is older than file itself, just get rid of it
        if getftime(v:swapname) < getftime(a:filename)
                call delete(v:swapname)
                let v:swapchoice = 'e'
        endif
endfunction
autocmd CursorHold,BufWritePost,BufReadPost,BufLeave *
  \ if isdirectory(expand("<amatch>:h")) | let &swapfile = &modified | endif

augroup checktime
    au!
    if !has("gui_running")
        "silent! necessary otherwise throws errors when using command
        "line window.
        autocmd BufEnter,CursorHold,CursorHoldI,CursorMoved,CursorMovedI,FocusGained,BufEnter,FocusLost,WinLeave * checktime
    endif
augroup END

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Cucumber navigation commands
  autocmd User Rails Rnavcommand step features/step_definitions -glob=**/* -suffix=_steps.rb
  autocmd User Rails Rnavcommand config config -glob=**/* -suffix=.rb -default=routes

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  "autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=72
  autocmd FileType gitcommit setlocal spell

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-
augroup END

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

nnoremap <leader>[ :SidewaysLeft<cr>
nnoremap <leader>] :SidewaysRight<cr>

" bind K to grep word under cursor
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" bind \ (backward slash) to grep shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!

nnoremap \ :Ag<SPACE>

" Exclude Javascript files in :Rtags via rails.vim due to warnings when parsing
let g:Tlist_Ctags_Cmd="ctags --exclude='*.js'"

" configure syntastic syntax checking to check on open as well as save
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" veritcal line config
let g:indentLine_color_term = 239
let g:indentLine_char = '|'

" set listchars+=space:·

let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]

let g:ctrlp_extensions = ['tag']
let g:ctrlp_show_hidden = 1

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Open the Rails ApiDock page for the word under cursor, using the 'open'
  " command
let g:browser = 'open '

function! OpenRailsDoc(keyword)
let url = 'http://apidock.com/rails/'.a:keyword
exec '!'.g:browser.' '.url
endfunction

" Open the Ruby ApiDock page for the word under cursor, using the 'open'
" command
function! OpenRubyDoc(keyword)
let url = 'http://apidock.com/ruby/'.a:keyword
exec '!'.g:browser.' '.url
endfunction

" NERDTree
let NERDTreeQuitOnOpen=1
" colored NERD Tree
let NERDChristmasTree = 1
let NERDTreeHighlightCursorline = 1
let NERDTreeShowHidden = 1
" map enter to activating a node
let NERDTreeMapActivateNode='<CR>'
let NERDTreeIgnore=['\.DS_Store','\.pdf', '.beam']

" Allow NERDTREE to have relative number
let NERDTreeShowLineNumbers=1
" make sure relative line numbers are used
autocmd FileType nerdtree setlocal relativenumber


autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let expect scenario
highlight def link rubyRspec Function

"" Shortcuts!!

" Index ctags from any project, including those outside Rails
map <Leader>ct :!ctags -r .<CR>

" Run commands that require an interactive shell
nnoremap <Leader>ru :RunInInteractiveShell<space>
map <leader>r :!ruby %<cr>

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Tab navigation
nmap <leader>tn :tabnext<CR>
nmap <leader>tp :tabprevious<CR>
nmap <leader>te :tabedit

" Remap F1 from Help to ESC.  No more accidents.
nmap <F1> <Esc>
map! <F1> <Esc>

" search next/previous -- center in page
nmap n nzz
nmap N Nzz
nmap * *Nzz
nmap # #nzz

" Yank from the cursor to the end of the line, to be consistent with C and D.
nnoremap Y y$

" Easily lookup documentation on apidock
noremap <leader>rb :call OpenRubyDoc(expand('<cword>'))<CR>
noremap <leader>rr :call OpenRailsDoc(expand('<cword>'))<CR>

" Easily spell check
" http://vimcasts.org/episodes/spell-checking/
nmap <silent> <leader>s :set spell!<CR>


map <C-c>n :cnext<CR>
map <C-c>p :cprevious<CR>

" Added by Leo

" Switch into background mode
nnoremap <leader>. <C-z>

" inoremap <C-o> my<Esc>o<Esc>`yi
" Git shortcut
map <leader>g :Git<space>

" Move between splits
nnoremap <S-Tab> <C-W>W
nnoremap <Tab> <C-W><C-W>

" Cycle forward and backward through open buffers
nnoremap <leader>h :bprevious<CR>
nnoremap <leader>l :bnext<CR>

" No highlight after a search
nnoremap <leader><space> :noh<cr>

" Paste mode in and out
nnoremap <leader>p :set paste<CR>
nnoremap <leader>np :set nopaste<CR>

" Create split, close split
nnoremap <leader>w <C-w>v<C-w>1
nnoremap <leader>q <C-w>q

" Create a new tab
nnoremap <leader>y :tabnew<CR>

"vim fugitive maping
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gm :Gmove<Space>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>go :Git checkout<Space>

"Vim Rails key mapping
nnoremap <leader>mo :Vmodel<CR>
nnoremap <leader>co :Vcontroller<CR>
nnoremap <leader>vi :Vview<CR>
nnoremap <leader>un :Vunittest<CR>
nnoremap <leader>fu :Vfunctionaltest<CR>
nnoremap <leader>fe :Vintegrationtest
nnoremap <leader>ja :Vjavascript<CR>

" Nerdtree
map <C-t> :NERDTreeToggle<CR>

" JJ escape
inoremap jj <ESC>:wa<CR>

au FocusLost * :wa

"save and run last command
nnoremap <CR> :wa<CR>:!!<CR>
noremap <C-j> <ESC>:wa<CR>:!!<CR>

"open vimrc
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" source vimrc
nnoremap <leader>es :so $MYVIMRC

"make ctrl-c work with vim on a mac
vnoremap <C-c> :w !pbcopy<CR><CR> noremap <C-v> :r !pbpaste<CR><CR>

autocmd FileType javascript inoremap (; ();<Esc>hi
set autowrite

" I'm not happy with this but I don't understand how vim/zsh work
" Maybe use tslime
set shell=/bin/sh

" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" let g:rspec_command = 'call Send_to_Tmux("spring rspec {spec}\n")'
let g:rspec_command = "Dispatch bin/rspec {spec}"

let g:rspec_runner = "os_x_iterm2"

" Cucumber mapping
map <Leader>c :w<cr>:!cucumber<cr>

" Easymotion
map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

" keep cursor column when JK motion
let g:EasyMotion_startofline = 0
let g:EasyMotion_smartcase = 1

" Two keyword search
nmap s <Plug>(easymotion-s2)

" such very magic
:nnoremap / /\v
:cnoremap %s/ %s/\v

" Indentation
nnoremap <Leader>i m^gg=G`^

" Multi Line Select
let g:multi_cursor_use_default_mapping=0

let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

let g:multi_cursor_start_key='<C-n>'
let g:multi_cursor_start_word_key='g<C-n>'

" Strip Whitespace
nnoremap <leader>ws :StripWhitespace<CR>

" Autoformat
map <Leader>f :Autoformat<CR>

" Indentation
nnoremap <Leader>i gg=G``
nnoremap == gg=G``

" Move up and down by visual line (as opposed to line break only)
nnoremap j gj
nnoremap k gk

" Supercharges '%' to work on do-end, def-end, class-end, module-end etc.
runtime macros/matchit.vim

" Toggle Paste
nnoremap <leader>p :set invpaste paste?<CR>
imap <leader>p <C-O>:set invpaste paste?<CR>
set pastetoggle=<leader>p

nnoremap <Leader>H :%s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>

au BufNewFile,BufRead *.ejs set filetype=html

set nocompatible
if has("autocmd")
  filetype indent plugin on
endif

" Requires 'jq' (brew install jq)
function! s:PrettyJSON()
  %!jq .
  set filetype=json
endfunction
command! PrettyJSON :call <sid>PrettyJSON()
