local popup = {shown = false, actions = {}}

popup.show = function() popup.shown = true end

popup.hide = function()
    if popup.show then
        popup.shown = false
        popup.actions = {}
    end
end

popup.add_actions = function(actions)
    for _, v in ipairs(actions) do table.insert(popup.actions, v) end
end

local function handler(_, _, actions)
    popup.add_actions(actions)

    if not popup.shown then popup.show() end
end

return handler
