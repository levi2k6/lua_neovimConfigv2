local settings = require("custom.settings.settingsState")
local settingsManager = require("custom.settings.settingsManager")

vim.api.nvim_create_user_command("SetRelative", function(opts)
	local val = opts.args:lower()
	if val == "true" then
		settings.isNumberRelative = true
	elseif val == "false" then 
		settings.isNumberRelative = false
	else 
		print("Use true or false to set")
		return
	end

	settingsManager.applySettings(settings)
end, {nargs=1})

vim.api.nvim_create_user_command("SetNumber", function(opts)
	local val = opts.args:lower()
	if val == "true" then
		settings.isNumberSet = true
	elseif val == "false" then
		settings.isNumberSet = false
	else
		print("Use true or false to set")
		return
	end

	settingsManager.applySettings(settings)
end, {nargs=1})

vim.api.nvim_create_user_command("SetWidth", function(opts)
	local num = tonumber(opts.args) 
	if num then
		settings.sizeWidth = num
	else 
		print("Invalid input numbers only")
		return
	end

	settingsManager.applySettings(settings)
end, {nargs=1})


