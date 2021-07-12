--[[ this module exposes the interface of lua functions:
define here the lua functions that activate the plugin ]]

local main = require("lsp-ui.main")
local config = require("lsp-ui.config")

local ui = {}

function ui.setup ()

end

ui.handlers = {
  codeAction = require('lsp-ui.handlers.code-action'),
}

return ui
