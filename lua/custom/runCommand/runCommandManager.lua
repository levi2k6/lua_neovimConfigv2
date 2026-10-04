local dataDir = vim.fn.stdpath("data") .. "/my_projects"
vim.fn.mkdir(dataDir, "p")
local dataPath = dataDir .. "/commands.lua"

local rootMarkers = {
	".git",
	".hg",
	"package.json",
	"Cargo.toml",
	"go.mod",
	"pyproject.toml",
	"Makefile",
	"CMakeLists.txt",
}

local function projectKey()
	local root = vim.fs.root(0, rootMarkers)
	return root or vim.fn.getcwd()
end


local function saveCommands(tbl)
	local lines = {"return {"}
	for project, command in pairs(tbl) do
		table.insert(lines, string.format(" [%q] = %q,", project, command))
	end
	table.insert(lines, "}")
	vim.fn.writefile(lines, dataPath)
end


local function loadCommands()
	local ok, loaded = pcall(dofile, dataPath)
	if ok and type(loaded) == "table" then
		return loaded
	end

	return nil
end


local function terminalAlive(term)
	if not term then
		return false
	end
	if not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
		return false
	end

	local ok, result = pcall(vim.fn.jobwait, { term.job }, 0)
	if not ok or type(result) ~= "table" then
		return false
	end

	return result[1] == -1
end


local function showTerminal(term)
	if not term or not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
		return nil
	end

	if term.win and vim.api.nvim_win_is_valid(term.win) then
		if vim.api.nvim_win_get_buf(term.win) ~= term.buf then
			vim.api.nvim_win_set_buf(term.win, term.buf)
		end
	else
		vim.cmd("botright split")
		term.win = vim.api.nvim_get_current_win()
		vim.api.nvim_win_set_buf(term.win, term.buf)
	end

	return term
end


local function spawnTerminal()
	vim.cmd("botright split")
	vim.cmd("terminal")

	local buf = vim.api.nvim_get_current_buf()
	local win = vim.api.nvim_get_current_win()
	local job = vim.b.terminal_job_id

	if not job or job == 0 then
		return nil
	end

	return { buf = buf, win = win, job = job }
end


local function sendCommand(term, command, interrupt)
	if not showTerminal(term) then
		return false
	end

	vim.api.nvim_set_current_win(term.win)

	if interrupt then
		local ok = pcall(vim.fn.chansend, term.job, "\x03")
		if not ok then
			return false
		end

		vim.defer_fn(function()
			if not term.buf or not vim.api.nvim_buf_is_valid(term.buf) then
				return
			end

			pcall(vim.fn.chansend, term.job, command .. "\n")

			if term.win and vim.api.nvim_win_is_valid(term.win) then
				vim.api.nvim_set_current_win(term.win)
				vim.cmd("startinsert")
			end
		end, 100)

		return true
	end

	local ok, sent = pcall(vim.fn.chansend, term.job, command .. "\n")
	if not ok or sent == 0 then
		return false
	end

	vim.cmd("startinsert")
	return true
end


local function destroyTerminal(term)
	if not term then
		return
	end

	if term.win and vim.api.nvim_win_is_valid(term.win)
		and vim.api.nvim_win_get_buf(term.win) == term.buf then
		vim.api.nvim_win_close(term.win, true)
	end

	if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
		vim.api.nvim_buf_delete(term.buf, { force = true })
	end
end


return{
	projectKey = projectKey,
	saveCommands = saveCommands,
	loadCommands = loadCommands,
	terminalAlive = terminalAlive,
	spawnTerminal = spawnTerminal,
	sendCommand = sendCommand,
	destroyTerminal = destroyTerminal
}
