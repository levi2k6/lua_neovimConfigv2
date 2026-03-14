local settingsState = require("custom.settings.settingsState")
local settingsManager = require("custom.settings.settingsManager")

local loaded = settingsManager.loadSettings() do
	if loaded then
		for k, v in pairs(loaded) do
			settingsState[k] = v
		end
	end
end

settingsManager.applySettings(settingsState)
