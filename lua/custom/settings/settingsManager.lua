local settingsDir = vim.fn.stdpath("data") .. "/my_settings"
vim.fn.mkdir(settingsDir, "p")
local settingsPath = settingsDir .. "/state.lua"


local function saveSettings(tbl)
	local lines = {"return {"}
	for k, v in pairs(tbl) do
		local val = type(v) == "string" and string.format("%q", v) or tostring(v)
		table.insert(lines, " " .. k .. " = " .. val .. ",")
	end
	table.insert(lines, "}")
	vim.fn.writefile(lines, settingsPath)
end


local function loadSettings()
	local ok, loaded = pcall(dofile, settingsPath)
	if ok and loaded then
		return loaded
	end

	return nil
end


local function applySettings(tbl)
	if tbl.isNumberSet ~= nil then
		vim.wo.number = tbl.isNumberSet
	end
	if tbl.isNumberRelative ~= nil then
		vim.wo.relativenumber = tbl.isNumberRelative
	end
	if tbl.sizeWidth ~= nil then
		vim.o.shiftwidth = tbl.sizeWidth
		vim.o.tabstop = tbl.sizeWidth
	end
end

return{
	saveSettings = saveSettings,
	loadSettings = loadSettings,
	applySettings = applySettings
}

