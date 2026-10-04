local state = require("custom.runCommand.runCommandState")
local manager = require("custom.runCommand.runCommandManager")

local loaded = manager.loadCommands()
if loaded then
	state.commands = loaded
end


local function saveCommand()
	local project = manager.projectKey()

	vim.ui.input({
		prompt = "Save command for " .. vim.fn.fnamemodify(project, ":t") .. ": ",
		default = state.commands[project] or "",
	}, function(input)
		if input == nil then
			return
		end

		if input == "" then
			print("Command not saved: empty input")
			return
		end

		state.commands[project] = input
		manager.saveCommands(state.commands)
		print("Saved command for " .. project)
	end)
end


local function runCommand()
	local project = manager.projectKey()
	local command = state.commands[project]

	if not command or command == "" then
		print("No command is saved")
		return
	end

	if manager.terminalAlive(state.term) and manager.sendCommand(state.term, command, true) then
		return
	end

	manager.destroyTerminal(state.term)
	state.term = manager.spawnTerminal()

	if not state.term then
		print("Failed to open terminal")
		return
	end

	manager.sendCommand(state.term, command, false)
end


vim.keymap.set("n", "<C-c>", saveCommand, { noremap = true, silent = true, desc = "Save project command" })
vim.keymap.set("n", "<F5>", runCommand, { noremap = true, silent = true, desc = "Run project command" })
vim.keymap.set("t", "<F5>", runCommand, { noremap = true, silent = true, desc = "Run project command" })
