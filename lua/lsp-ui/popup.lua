local tbl = require('lsp-ui.tbl')

local M = {}

M.show_window = function(conf)
    bufnr = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')

    winid = vim.api.nvim_open_win(bufnr, true, tbl.apply_defaults(conf, {
        relative = 'cursor',
        width = 30,
        height = 1,
        row = 1,
        col = 0,
        border = 'double'
    }))

    return bufnr, winid
end

return M
