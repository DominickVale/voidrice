set path+=**
let mapleader =" "

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

" Conditional function helper
function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree', Cond(!exists('g:vscode'))
Plug 'roryokane/detectindent'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'gruvbox-community/gruvbox'
Plug 'mbbill/undotree'
Plug 'psliwka/vim-smoothie'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-scripts/Tabmerge'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'jose-elias-alvarez/null-ls.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'APZelos/blamer.nvim'

" Autocompletion
Plug 'mattn/emmet-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'
Plug 'ray-x/lsp_signature.nvim'
Plug 'onsails/lspkind-nvim'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" Snippets
Plug 'L3MON4D3/luasnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'rafamadriz/friendly-snippets'
Plug 'tpope/vim-fugitive'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

Plug 'easymotion/vim-easymotion', Cond(!exists('g:vscode'))
Plug 'asvetliakov/vim-easymotion', Cond(exists('g:vscode'), { 'as': 'vsc-easymotion' })

" Prettier"
Plug 'sbdchd/neoformat'

call plug#end()

set title
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noruler
set laststatus=0
set noshowcmd
set termguicolors
set smartindent
set scrolloff=8
set signcolumn=yes
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'

" Lua requires (@todo: fix / refactor)
lua require("_lsp")
lua require("_telescope")
lua require'nvim-treesitter.configs'.setup { indent = { enable = true }, highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
lua  require("trouble").setup{}
lua require('nvim-autopairs').setup{}
lua require('nvim-ts-autotag').setup()
lua require('colorizer').setup()

" Some basics:
	nnoremap c "_c
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber
" Enable autocompletion:
	set wildmode=longest,list,full
	set wildmenu
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>
" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>
	map <leader>o :setlocal spell! spelllang=en_us<CR>
" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright
" Easymotion
	map <leader><leader>. <Plug>(easymotion-repeat)
	map <leader><leader>f <Plug>(easymotion-bd-f)
	map <leader><leader>j <Plug>(easymotion-bd-line)
	map <leader><leader>k <Plug>(easymotion-bd-line)
	map <leader><leader>w <Plug>(easymotion-bd-w)
	map  / <Plug>(easymotion-sn)
	omap / <Plug>(easymotion-tn)
	map  n <Plug>(easymotion-next)
	map  N <Plug>(easymotion-prev)

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
         if has('nvim')
	     let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
         else
	     let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
        endif

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l
	noremap <silent> <C-S-Right> :vertical resize +5<CR>
	noremap <silent> <C-S-Left> :vertical resize -5<CR>
	noremap <silent> <C-S-Up> :resize -5<CR>
	noremap <silent> <C-S-Down> :resize +5<CR>

" Replace ex mode with gq
	map Q gq

" Replace all
	nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>

" Open corresponding .pdf/.html or preview
	map <leader>pv :!opout <c-r>%<CR><CR>

" Jump to start and end of line using the home row keys
	map H ^
	map L $

"  Really just general stuff
	nnoremap <leader>u :UndotreeShow<CR>
	nnoremap <leader>x :silent !chmod +x %<CR>
	vnoremap J :m '>+1<CR>gv=gv
	vnoremap K :m '<-2<CR>gv=gv

	nnoremap Y yg$
	nnoremap n nzzzv
	nnoremap N Nzzzv
	nnoremap J mzJ`z

	xnoremap <leader>p "_dP

	nnoremap <leader>y "+y
	vnoremap <leader>y "+y
	nnoremap <leader>Y gg"+yG

	nnoremap <leader>d "_d
	vnoremap <leader>d "_d

vnoremap < <gv
vnoremap > >gv

	nnoremap <c-w>m :Tabmerge

" Open current folder in a new terminal window
	nnoremap <leader>t :!{nohup st </dev/null >/dev/null 2>&1 &}<CR><CR>

" Git stuff
	nnoremap <leader>gll :let g:_search_term = expand("%")<CR><bar>:Gclog -- %<CR>:call search(g:_search_term)<CR>
	nnoremap <leader>gln :cnext<CR>:call search(_search_term)<CR>
	nnoremap <leader>glp :cprev<CR>:call search(_search_term)<CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

let g:neoformat_enabled_javascript = ['prettier', 'eslint_d']
let g:neoformat_verbose = 1
let g:neoformat_only_msg_on_error = 1
nnoremap <leader>== :silent Neoformat<CR>

let g:smoothie_speed_exponentiation_factor=1.2

let g:blamer_enabled = 1
let g:blamer_delay = 5000
highlight Blamer guifg=#454545

function! Redir(cmd, rng, start, end)
	for win in range(1, winnr('$'))
		if getwinvar(win, 'scratch')
			execute win . 'windo close'
		endif
	endfor
	if a:cmd =~ '^!'
		let cmd = a:cmd =~' %'
			\ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
			\ : matchstr(a:cmd, '^!\zs.*')
		if a:rng == 0
			let output = systemlist(cmd)
		else
			let joined_lines = join(getline(a:start, a:end), '\n')
			let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
			let output = systemlist(cmd . " <<< $" . cleaned_lines)
		endif
	else
		redir => output
		execute a:cmd
		redir END
		let output = split(output, "\n")
	endif
	vnew
	let w:scratch = 1
	setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
	call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)

augroup DetectIndent
   autocmd!
   autocmd BufReadPost *  DetectIndent
augroup END

augroup JsonToJsonc
			autocmd! FileType json set filetype=jsonc
augroup END

augroup ProjectDrawer
			autocmd!
			autocmd VimEnter * if argc() == 0 | Explore! | endif
augroup END
