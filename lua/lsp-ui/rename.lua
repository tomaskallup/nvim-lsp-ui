local popupApi = require('lsp-ui.popup')
local popup = {
    shown = false,
    current_name = nil,
    bufnr = nil,
    winid = nil,
    original_bufnr = nil
}

local prompt_prefix = 'New name: '

popup.show = function(current_name)
    popup.shown = true
    popup.current_name = current_name
    popup.original_bufnr = vim.fn.bufnr('%')

    local width = #prompt_prefix + 30 + #current_name * 2

    local bufnr, winid = popupApi.show_window({width = width})
    vim.api.nvim_win_set_option(winid, 'scrolloff', 0)
    vim.api.nvim_win_set_option(winid, 'sidescrolloff', 0)
    vim.api.nvim_buf_set_option(bufnr, 'modifiable', true)
    vim.api.nvim_buf_set_option(bufnr, 'buftype', 'prompt')
    vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
    vim.fn.prompt_setprompt(bufnr, prompt_prefix)
    vim.api.nvim_buf_add_highlight(bufnr, -1, 'Comment', 0, 0, #prompt_prefix)
    vim.cmd [[startinsert!]]
    vim.fn.feedkeys(current_name)
    vim.api.nvim_command(
        "autocmd QuitPre <buffer> ++nested ++once :silent lua require('lsp-ui.rename').close()")

    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<CR>',
                                "<cmd>lua require('lsp-ui.rename').do_rename()<CR>",
                                {noremap = true})

    popup.bufnr = bufnr
    popup.winid = winid
end

popup.do_rename = function()
    if not popup.shown or not popup.bufnr then return end

    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    local new_name = first_line:sub(#prompt_prefix + 1)

    popup.hide()

    if not (#new_name > 0) or new_name == popup.current_name then return end

    local params = vim.lsp.util.make_position_params()
    params.newName = new_name

    vim.lsp.buf_request(0, 'textDocument/rename', params)
end

popup.hide = function()
    if popup.shown then
        vim.cmd [[stopinsert!]]
        popup.shown = false
        popup.current_name = nil

        -- Close buffer and its window
        if popup.bufnr then
            vim.api.nvim_buf_delete(popup.bufnr, {force = true})
            popup.bufnr = nil
            popup.winid = nil
        end

        -- Close window if its somehow visible without the rename buffer
        if popup.winid then
            vim.api.nvim_win_close(popup.winid, {force = true})
            popup.winid = nil
        end
    end
end

local M = {}

M.rename = function()
    if not popup.shown then popup.show(vim.fn.expand('<cword>')) end
end

M.close = function() popup.hide() end

M.do_rename = function() popup.do_rename() end

return M
