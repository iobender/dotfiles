set number					" show line numbers
set relativenumber			" show line numbers relative to current line
set hlsearch				" hightlight search matches
set cindent					" indent C-style
set autoindent				" keep indentation of previous line if no indentation from filetype
set ignorecase				" ignore case when searching
set tabstop=4				" 4 spaces per tab
set softtabstop=4			" 4 spaces per tab backspace
set shiftwidth=4			" 4 spaces for indent
set showcmd					" show command as it's entered
set scrolloff=5				" always have at least 5 lines visible above/below the cursor
set formatoptions=croq		" auto-wrap comments, auto-insert comment leader after <Enter>, o, or O, allow formatting with gq
set gdefault				" replace all by default, not just first on line
set virtualedit=block		" allows blocks in visual mode to go past text
set clipboard=unnamedplus	" copy/paste using system's 

set matchpairs+=<:>			" match <> like (), etc.

let mapleader=" "			" makes Space bar leader

" remove highlights from search and displayed message
nnoremap <Leader><Leader> :silent noh<Bar>echo<CR>

" move up/down 1 line, including when wrapped
nnoremap k gk
nnoremap j gj		

" format when pasting text (esp. auto-indenting)
nnoremap p ]p

" Y yanks to end of line, emulating other capitals
nnoremap Y y$

" clear all current line, stay in command mode
nnoremap <Leader>D ^D

" delete/change into unused buffer
nnoremap <Leader>d "_d
nnoremap <Leader>c "_c

" insert a line below/above without going into insert mode
nnoremap <Leader>o mzo<Esc>`z
nnoremap <Leader>O mzO<Esc>`z

" center screen when finding search results
" nnoremap n  nzz
" nnoremap N  Nzz
" nnoremap *  *zz
" nnoremap #  #zz
" nnoremap g* g*zz
" nnoremap g# g#zz

" ';' starts command mode, ',' finds last search forwards, ':' finds last search backwards
nnoremap ; :
nnoremap , ;
nnoremap : ,
vnoremap ; :
vnoremap , ;
vnoremap : ,

" swap functionality of backtick and single quote 
" backtick now just goes to the beginning of the mark's line
" while single quote now goes directly to the mark
nnoremap ' `
nnoremap ` '

" maps r to redo, and R to old r (replace char)
nnoremap r <C-R>
nnoremap R r

nnoremap <Leader>n :w<CR>:bn<CR>
nnoremap <Leader>p :w<CR>:bp<CR>

" ignores swap files on startup, but still allows creation of swap files
:au SwapExists * let v:swapchoice='e'

" enter w!! to save as root
cmap w!! w !sudo tee > /dev/null %

" put all backup/swap files there
set backupdir=~/.vim/backup
set directory=~/.vim/swap

" new splits will open below/right instead of above/left
set splitbelow
set splitright

" reload .vimrc file
" todo?: change to reload current file instead
nnoremap <F5> :source ~/.vimrc<CR> 

" comment/uncomment out a single line depending on filetype
" supported filetypes are Python, Perl, Ruby, shell, Vim, C, C++ (including headers), Java, and Haskell
" todo: extend to block comments
function! CommentLine()
	let filename = expand("%:t")
	if filename =~ "\.py$" || filename =~ "\.pl$" || filename =~ "\.rb$" || filename =~ "\.sh$"
		execute "normal I# \<Esc>j"
		return
	elseif filename =~ "\.vim" " no $ to allow for .vimrc files, for example
		execute "normal I\" \<Esc>j"
		return
	elseif filename =~ "\.c$" || filename =~ "\.h$" || filename =~ "\.cpp$" || filename =~ "\.hpp$" || filename =~ "\.java$"
		execute "normal I/* \<Esc>A */\<Esc>j"
		return
	elseif filename =~ "\.hs$"
		execute "normal I-- \<Esc>j"
	elseif filename =~ "\.ml$"
		execute "normal I(* \<Esc>A *)\<Esc>j"
	endif
endfunction

function! UncommentLine()
	let filename = expand("%:t")
	if filename =~ "\.py$" || filename =~ "\.pl$" || filename =~ "\.rb$" || filename =~ "\.sh$"
		execute "normal ^2xj""
		return
	elseif filename =~ "\.vim" " no $ to allow for .vimrc files, for example
		execute "normal ^2xj"
		return
	elseif filename =~ "\.c$" || filename =~ "\.h$" || filename =~ "\.cpp$" || filename =~ "\.hpp$" || filename =~ "\.java$"
		execute "normal $xxx^3xj"
		return
	elseif filename =~ "\.hs$"
		execute "normal ^3xj"
	endif
endfunction

" comment/uncomment line (with /* */), and move to next line *
nnoremap <Leader>lc :call CommentLine()<CR>
nnoremap <Leader>lu :call UncommentLine()<CR>

function! CurChar()
	return strpart(getline('.'), col('.')-1, 1)
endfunction

" commented the following because it was getting annoying, and conflicted with some commenting
" should find a better way to do things
" autoclosing for braces, parens, and quotes
" todo: angle braces
" inoremap ( ()<Left>
" inoremap (<CR> (<CR>)<Esc>O
" inoremap (( (
" inoremap () ()
" inoremap <expr>) CurChar() == ")" ? "\<Right>" : ")"
" 
" inoremap { {}<Left>
" inoremap {<CR> {<CR>}<Esc>O
" inoremap {{ {
" inoremap {} {}
" inoremap <expr>) CurChar() == ")" ? "\<Right>" : ")"
" 
" inoremap [ []<Left>
" inoremap [<CR> [<CR>]<Esc>O
" inoremap [[ [
" inoremap [] []
" inoremap <expr>] CurChar() == "]" ? "\<Right>" : "]"
" 
" inoremap "" "
" inoremap <expr>" CurChar() == "\"" ? "\<Right>" : "\"\"\<Left>"
" 
" inoremap '' '
" inoremap <expr>' CurChar() == "\'" ? "\<Right>" : "\'\'\<Left>"
" 
" inoremap `` `
" inoremap <expr>` CurChar() == "`" ? "\<Right>" : "``\<Left>"

" creates a box of a given character around the current line
" may not work with some special characters
" todo: extend to multiple lines
" todo: make work when line doesn't start at first char
function! Box(var1)
	let ch=a:var1
	execute "normal I" . ch . " \<Esc>A " . ch . "\<Esc>yyPpk"
	execute 's/./' . ch
	execute "normal 2j"
	execute 's/./' . ch
endfunction

nnoremap <Leader>* :call Box('*')<CR>
nnoremap <Leader># :call Box('#')<CR>
nnoremap <Leader>= :call Box('=')<CR>

" navigate between splits 
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Colors
highlight PreProc term=underline ctermfg=6 guifg=DarkCyan
highlight Comment term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
highlight Constant term=underline ctermfg=1 cterm=bold guifg=Magenta gui=bold
highlight Special ctermfg=6 cterm=NONE
highlight Title ctermfg=white cterm=NONE
