if exists('g:loaded_nvim_lsp_ui') | finish | endif

" expose vim commands and interface here
" nnoremap <Plug>PlugCommand :lua require(...).plug_command()<CR>

let s:save_cpo = &cpo
set cpo&vim

let g:loaded_nvim_lsp_ui = 1

command! -nargs=0 CustomPopup  lua require('lsp-ui.popup').show_window()

let &cpo = s:save_cpo
unlet s:save_cpo
