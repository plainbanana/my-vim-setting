"#####表示設定#####
set ruler "ルーラーの表示
set number "行番号を表示する
set title "編集中のファイル名を表示
set showmatch "括弧入力時の対応する括弧を表示
set hlsearch
syntax on
set tabstop=4 "インデントをスペース4つ分に設定
set autoindent "オートインデント
"set statusline+=%r "読み込み専用かどうか表示
set laststatus=2
set statusline+=[WC=%{exists('*WordCount')?WordCount():[]}] " 現在のファイルの文字数をカウント
set statusline+=[%p%%] " 現在行が全体行の何%目か表示

set background=dark

" タブ文字の代わりにスペース2個を使う場合の設定。
" この場合、'tabstop'はデフォルトの8から変えない。
set shiftwidth=2
set softtabstop=2
set expandtab
set mouse=a " マウスを有効

"#####検索設定#####
set ignorecase "大文字/小文字の区別なく検索する
set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
set wrapscan "検索時に最後まで行ったら最初に戻る

"#####編集機能#####
set clipboard+=unnamed "OSのクリップボードを使用する
set wildmenu wildmode=list:full "コマンド補完

"#####w!! でスーパーユーザーとして保存
"   （sudoが使える環境限定）          #####
cmap w!! w !sudo tee > /dev/null %

"カーソルラインをハイライト表示
set cursorline

"自動文字数カウント
augroup WordCount
  autocmd!
  autocmd BufWinEnter,InsertLeave,CursorHold * call WordCount('char')
augroup END
let s:WordCountStr = ''
let s:WordCountDict = {'word': 2, 'char': 3, 'byte': 4}
function! WordCount(...)
  if a:0 == 0
    return s:WordCountStr
  endif
  let cidx = 3
  silent! let cidx = s:WordCountDict[a:1]
  let s:WordCountStr = ''
  let s:saved_status = v:statusmsg
  exec "silent normal! g\<c-g>"
  if v:statusmsg !~ '^--'
    let str = ''
    silent! let str = split(v:statusmsg, ';')[cidx]
    let cur = str2nr(matchstr(str, '\d\+'))
    let end = str2nr(matchstr(str, '\d\+\s*$'))
    if a:1 == 'char'
      " ここで(改行コード数*改行コードサイズ)を'g<C-g>'の文字数から引く
      let cr = &ff == 'dos' ? 2 : 1
      let cur -= cr * (line('.') - 1)
      let end -= cr * line('$')
    endif
    let s:WordCountStr = printf('%d/%d', cur, end)
  endif
  let v:statusmsg = s:saved_status
  return s:WordCountStr
endfunction

"###########################
" Start Neobundle Settings.
"###########################
" bundleがインストールされていなければインストール
if has('vim_starting')
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install neobundle..."
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
  endif
  set runtimepath+=~/.vim/bundle/neobundle.vim
endif

" bundleで管理するディレクトリを指定
set runtimepath+=~/.vim/bundle/neobundle.vim/

call neobundle#begin(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'
call neobundle#end()
 
" Required:
call neobundle#begin(expand('~/.vim/bundle/'))
 
" neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'

" この辺りにロードするプラグインを記入
" molokai設定
NeoBundle 'tomasr/molokai'
" solarlized
NeoBundle 'altercation/vim-colors-solarized'
" gruvbox
NeoBundle 'morhetz/gruvbox'
" NERDTreeを設定
NeoBundle 'scrooloose/nerdtree'
" 鉤括弧自動で2個入力
NeoBundle 'Townk/vim-autoclose'
" HTML書くときに便利らしい
NeoBundle 'mattn/emmet-vim'
" ちょっとしたコード偏を書いて実行して確認
NeoBundle 'thinca/vim-quickrun'
" シンタックスチェック系
"NeoBundle 'scrooloose/syntastic'
" 履歴記憶
NeoBundle "yegappan/mru"
" Phython構文解析
NeoBundle "davidhalter/jedi-vim"
" タブ補完
NeoBundle "Shougo/neocomplete.vim"
" インデントを見やすく
NeoBundle "nathanaelkane/vim-indent-guides"
" テキスト編集
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/Align'
NeoBundle 'vim-scripts/YankRing.vim'
" アンドゥ
NeoBundle "sjl/gundo.vim"
" ステータスラインを綺麗に
NeoBundle 'itchyny/lightline.vim'
" ALEで非同期構文チェック
NeoBundle 'w0rp/ale'
" 絵文字
NeoBundle 'junegunn/vim-emoji'
NeoBundle 'mattn/emoji-vim'
" Github補完
NeoBundle 'rhysd/github-complete.vim'
"  ESKKIME
NeoBundle 'tyru/eskk.vim'


call neobundle#end()
 
" Required:
filetype plugin indent on
 
" 未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
" 毎回聞かれると邪魔な場合もあるので、この設定は任意です。
NeoBundleCheck
 
"#########################
" End Neobundle Settings.
"#########################

"############################
"###補完関連デフォルト設定###
"############################
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"######################
"#####END##############
"######################

"jedi completion settings without using neocomplete
autocmd FileType python setlocal omnifunc=jedi#completions
let g:jedi#completions_enabled = 0
let g:jedi#auto_vim_configuration = 0

if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif

let g:neocomplete#force_omni_input_patterns.python = '\h\w*\|[^.\t]\.\w*'
" jedi settings end

" gruvbox設定
colorscheme gruvbox
" インデント可視化
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
" ESKK設定
let g:eskk#large_dictionary = {
  \ 'path': "~/.eskk/SKK-JISYO.L",
  \ 'sorted': 1,
  \ 'encoding': 'euc-jp',
  \}
let g:eskk#enable_completion = 1
let g:eskk#egg_like_newline = 1
" ALEの結果をステータスラインに表示する
let g:ale_statusline_format = ['x %d', '! %d', '⬥ ok']
" NERDTreeの初期画面設定
let g:NERDTreeShowBookmarks=1
" autocmd vimenter * NERDTree
" ファイル名が指定されて起動したときはNerdTreeを表示しない
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'component': {
"       \   'readonly': '%{&readonly?"x":""}',
"       \   'char_counter' : '%', 
"       \   'ale' : 'ALEStatus'
"       \ },
"       \ 'separator': { 'left': '', 'right': '' },
"       \ 'subseparator': { 'left': '|', 'right': '|' }
"       \ }
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left' : [
      \    ['mode', 'paste'],
      \    ['readonly', 'filename', 'modified'],
      \    ['ale'],
      \  ]
      \ },
      \ 'component_function': {
      \   'ale': 'ALEStatus'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '|', 'right': '|' }
      \ }
" function! ALEStatus()
"   return ALEGetStatusLine()
" endfunction
" 未取得のbundleがあれば取得する
" .vimrcの最後に記述する
if(!empty(neobundle#get_not_installed_bundle_names()))
  echomsg 'Not installed bundles: '
    \ string(neobundle#get_not_installed_bundle_names())
  if confirm('Install bundles now?', "yes\nNo", 2) == 1
    " vimrc を再度読み込み、インストールした Bundle を有効化
    " vimrc は必ず再読み込み可能な形式で記述すること
    NeoBundleInstall
    source ~/.vimrc
  endif
end
