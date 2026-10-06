local state = require("custom.commandRegistry.commandRegistryState")
local manager = require("custom.commandRegistry.commandRegistryManager")

local highlightNs = vim.api.nvim_create_namespace("command_registry")
vim.api.nvim_set_hl(0, "CommandRegistryDelete", { link = "DiagnosticError" })
vim.api.nvim_set_hl(0, "CommandRegistryEdit", { link = "DiagnosticInfo" })


local function notify(message)
	vim.notify(message, vim.log.levels.INFO)
end


local function panelOpen()
	return state.panelWin ~= nil and vim.api.nvim_win_is_valid(state.panelWin)
end


local function closePanel()
	if panelOpen() then
		vim.api.nvim_win_close(state.panelWin, true)
	end

	state.panelWin = nil
	state.panelBuf = nil
	state.mode = "normal"
end


local function updateWindowConfig()
	if not panelOpen() then
		return
	end

	local width = 40
	for _, command in ipairs(state.commands) do
		width = math.max(width, #command + 12)
	end
	width = math.min(width, vim.o.columns - 4)

	local height = #state.commands + 4
	height = math.min(height, vim.o.lines - 4)

	local row = math.max(1, math.floor((vim.o.lines - height) / 2) - 1)
	local col = math.max(1, math.floor((vim.o.columns - width) / 2))

	vim.api.nvim_win_set_config(state.panelWin, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Command Registry ",
		title_pos = "center",
		footer = " [s]ave  [e]dit  [1-9]run  [d]elete  [q]uit   mode: " .. state.mode .. " ",
		footer_pos = "center",
	})
end


local function render()
	if not panelOpen() then
		return
	end

	local lines = {}

	if #state.commands == 0 then
		table.insert(lines, "  (empty - press s to add a command)")
	else
		for i, command in ipairs(state.commands) do
			table.insert(lines, string.format("  %2d  %s", i, command))
		end
	end

	local buf = state.panelBuf
	vim.bo[buf].modifiable = true
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false

	vim.api.nvim_buf_clear_namespace(buf, highlightNs, 0, -1)
	if state.mode == "delete" then
		for i = 1, #state.commands do
			vim.api.nvim_buf_add_highlight(buf, highlightNs, "CommandRegistryDelete", i - 1, 6, -1)
		end
	elseif state.mode == "edit" then
		for i = 1, #state.commands do
			vim.api.nvim_buf_add_highlight(buf, highlightNs, "CommandRegistryEdit", i - 1, 6, -1)
		end
	end

	updateWindowConfig()
end


local function addCommand()
	vim.ui.input({ prompt = "Command: " }, function(input)
		if input == nil or input == "" then
			return
		end

		table.insert(state.commands, input)
		manager.saveRegistry(state.project, state.commands)
		state.mode = "normal"
		render()
	end)
end


local function focusSourceTerminal(buf)
	local win = state.sourceWin
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_set_current_win(win)
		if vim.api.nvim_win_get_buf(win) ~= buf and vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_win_set_buf(win, buf)
		end
		vim.cmd("startinsert")
	end
end


local function runCommand(index)
	local command = state.commands[index]
	if not command then
		return
	end

	local buf = state.sourceBuf
	local ok, err = manager.runInTerminal(buf, command)
	if not ok then
		notify(err)
		return
	end

	closePanel()
	focusSourceTerminal(buf)
end


local function deleteCommand(index)
	if not state.commands[index] then
		return
	end

	table.remove(state.commands, index)
	manager.saveRegistry(state.project, state.commands)
	render()
end


local function editCommand(index)
	local command = state.commands[index]
	if not command then
		return
	end

	vim.ui.input({ prompt = "Command: ", default = command }, function(input)
		if input == nil or input == "" then
			return
		end

		state.commands[index] = input
		manager.saveRegistry(state.project, state.commands)
		state.mode = "normal"
		render()
	end)
end


local function handleNumber(key)
	local index = tonumber(key)
	if not index then
		return
	end

	if state.mode == "delete" then
		deleteCommand(index)
	elseif state.mode == "edit" then
		editCommand(index)
	else
		runCommand(index)
	end
end


local function setMode(mode)
	state.mode = mode
	render()
end


local function setKeymaps(buf)
	local opts = { buffer = buf, nowait = true, silent = true }

	vim.keymap.set("n", "s", addCommand, opts)
	vim.keymap.set("n", "q", closePanel, opts)
	vim.keymap.set("n", "<Esc>", closePanel, opts)
	vim.keymap.set("n", "d", function()
		setMode(state.mode == "delete" and "normal" or "delete")
	end, opts)
	vim.keymap.set("n", "e", function()
		setMode(state.mode == "edit" and "normal" or "edit")
	end, opts)

	for i = 1, 9 do
		vim.keymap.set("n", tostring(i), function() handleNumber(tostring(i)) end, opts)
	end
end


local function openPanel()
	state.sourceWin = vim.api.nvim_get_current_win()
	state.sourceBuf = vim.api.nvim_get_current_buf()
	state.project = manager.projectKey(state.sourceBuf)
	state.commands = manager.loadRegistry(state.project)
	state.mode = "normal"

	local buf = vim.api.nvim_create_buf(false, true)
	state.panelBuf = buf

	state.panelWin = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = 40,
		height = 5,
		row = 2,
		col = 2,
		style = "minimal",
		border = "rounded",
		title = " Command Registry ",
		title_pos = "center",
	})

	setKeymaps(buf)
	render()
end


local function togglePanel()
	if panelOpen() then
		closePanel()
	else
		openPanel()
	end
end


vim.keymap.set("n", "<C-g>", togglePanel, { noremap = true, silent = true, desc = "Command registry" })
vim.keymap.set("t", "<C-g>", togglePanel, { noremap = true, silent = true, desc = "Command registry" })


vim.api.nvim_create_autocmd("WinClosed", {
	callback = function(args)
		if state.panelWin and tonumber(args.match) == state.panelWin then
			state.panelWin = nil
			state.panelBuf = nil
			state.mode = "normal"
		end
	end,
})
