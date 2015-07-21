set nocompatible
set nu
syntax on
filetype indent on
set autoindent
set ic
set hls
set lbr
colorscheme delek
set incsearch
set hlsearch
":au BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set backup
set backupdir=$HOME/.vimbackup
set directory=$HOME/.vimswap
set viewdir=$HOME/.vimviews
set noignorecase

au BufRead,BufNewFile *.go set filetype=go 

" Creating directories if they don't exist
silent execute '!mkdir -p $HOME/.vimbackup'
silent execute '!mkdir -p $HOME/.vimswap'
silent execute '!mkdir -p $HOME/.vimviews'
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview

filetype plugin on
filetype detect
set hidden
set nonumber

"highlight trailing spaces in red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
autocmd BufRead *.java set efm=%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#
autocmd BufRead set makeprg=ant\ -find\ build.xml
nnoremap <C-e> :CommandT<CR>
set tags=tags
let g:CommandTNeverShowDotFiles=1
let g:CommandTAcceptSelectionSplitMap='<C-t>'

fun SetupVAM()
          " YES, you can customize this vam_install_path path and everything still works!
          let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
          exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

          " * unix based os users may want to use this code checking out VAM
          " * windows users want to use http://mawercer.de/~marc/vam/index.php
          "   to fetch VAM, VAM-known-repositories and the listed plugins
          "   without having to install curl, unzip, git tool chain first
          if !isdirectory(vam_install_path.'/vim-addon-manager') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
            " I'm sorry having to add this reminder. Eventually it'll pay off.
            call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
            exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
          endif

          call vam#ActivateAddons([], {'auto_install' : 0})
          " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
          " where pluginA could be github:YourName or snipmate-snippets see vam#install#RewriteName()
          " also see section "5. Installing plugins" in VAM's documentation
          " which will tell you how to find the plugin names of a plugin
        endf
        call SetupVAM()
        " experimental: run after gui has been started (gvim) [3]
        " option1:  au VimEnter * call SetupVAM()
        " option2:  au GUIEnter * call SetupVAM()
        " See BUGS sections below [*]

map <C-n> :NERDTreeToggle<CR>
set laststatus=2

set colorcolumn=120
function! WriteRegs()
    let vi = &vi
    let &vi = "'0,/0,:0,@0,f0,h,s100"
    wviminfo ~/.vimregs
    let &vi = vi
endfunction

function! ReadRegs()
    if filereadable(expand("~/.vimregs"))
        rviminfo! ~/.vimregs
    endif
endfunction

if has("autocmd")
    augroup regshare
        autocmd!

        autocmd FocusLost * call WriteRegs()
        autocmd FocusGained * call ReadRegs()
    augroup END
endif
set wildignore=*.swp,*.bak,*.pyc,*.class,*.jpg,*.png,*.jar,*~
set wildignore+=*.o,*.obj,.git,*.class,dependencies*,*.txt
let g:CommandTMaxFiles = 20000
set makeprg=./sbt\ compile
set efm=%E\ %#[error]\ %f:%l:\ %m,%C\ %#[error]\ %p^,%-C%.%#,%Z,
       \%W\ %#[warn]\ %f:%l:\ %m,%C\ %#[warn]\ %p^,%-C%.%#,%Z,
       \%-G%.%#
