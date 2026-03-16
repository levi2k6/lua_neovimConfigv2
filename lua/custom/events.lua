local settings = require("custom.settings.settingsState")
local settingsManager = require("custom.settings.settingsManager")


vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
	callback = function()
		settingsManager.applySettings(settings)
	end
})

vim.api.nvim_create_autocmd({"VimLeavePre"}, {
	callback = function()
		settingsManager.saveSettings(settings)
	end
})

