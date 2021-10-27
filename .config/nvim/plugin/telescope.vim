nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
nnoremap <leader><C-p> :lua require('telescope.builtin').git_files()<CR>
nnoremap <Leader>pf :lua require('telescope.builtin').find_files()<CR>
nnoremap <C-F> :lua require('telescope.builtin').live_grep()<CR>

nnoremap <leader>pw :lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
nnoremap <leader>pb :lua require('telescope.builtin').buffers()<CR>
nnoremap <leader>ph :lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>pgc :lua require('_telescope').git_branches()<CR>
noremap <leader>pgw :lua require('telescope').extensions.git_worktree.git_worktrees()<CR>
nnoremap <leader>pgm :lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>
