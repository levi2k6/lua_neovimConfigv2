local dataDir = vim.fn.stdpath("data") .. "/my_projects"
vim.fn.mkdir(dataDir, "p")
local dataPath = dataDir .. "/command_registry.lua"


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


local function resolveDir(buf)
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return vim.fn.getcwd()
	end

	local name = vim.api.nvim_buf_get_name(buf)

	if vim.bo[buf].buftype == "terminal" then
		local path = name:match("^term://(.+)//%d+:")
		if path and path ~= "" then
			return vim.fn.fnamemodify(path, ":p")
		end
	elseif name ~= "" then
		return vim.fn.fnamemodify(name, ":p:h")
	end

	return vim.fn.getcwd()
end


local function projectKey(buf)
	local dir = resolveDir(buf)
	return vim.fs.root(dir, rootMarkers) or vim.fn.getcwd()
end


local function loadRegistries()
	local ok, loaded = pcall(dofile, dataPath)
	if ok and type(loaded) == "table" then
		return loaded
	end

	return {}
end


local function isLegacyRegistry(tbl)
	if type(tbl) ~= "table" or next(tbl) == nil then
		return false
	end

	for key, value in pairs(tbl) do
		if type(key) ~= "number" or type(value) ~= "string" then
			return false
		end
	end

	return true
end


local function saveRegistries(registries)
	local lines = {"return {"}
	for project, commands in pairs(registries) do
		if type(project) == "string" and type(commands) == "table" then
			table.insert(lines, string.format(" [%q] = {", project))
			for _, command in ipairs(commands) do
				table.insert(lines, string.format("  %q,", command))
			end
			table.insert(lines, " },")
		end
	end
	table.insert(lines, "}")
	vim.fn.writefile(lines, dataPath)
end


local function saveRegistry(project, commands)
	local registries = loadRegistries()

	if isLegacyRegistry(registries) then
		registries = {}
	end

	registries[project] = commands
	saveRegistries(registries)
end


local function loadRegistry(project)
	local registries = loadRegistries()

	if isLegacyRegistry(registries) then
		local migrated = {}
		for _, command in ipairs(registries) do
			table.insert(migrated, command)
		end

		saveRegistry(project, migrated)
		return migrated
	end

	local commands = registries[project]
	if type(commands) == "table" then
		return commands
	end

	return {}
end


local function isTerminal(buf)
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		return false
	end

	return vim.bo[buf].buftype == "terminal"
end


local function terminalBusy(buf)
	if not isTerminal(buf) then
		return true
	end

	local job = vim.b[buf].terminal_job_id
	if not job or job == 0 then
		return true
	end

	local pid = vim.fn.jobpid(job)
	if pid <= 0 then
		return true
	end

	local f = io.open("/proc/" .. pid .. "/task/" .. pid .. "/children", "r")
	if not f then
		return false
	end

	local children = f:read("*a")
	f:close()

	return children ~= nil and children:match("%d") ~= nil
end


local function runInTerminal(buf, command)
	if not isTerminal(buf) then
		return false, "Not a terminal buffer"
	end

	local job = vim.b[buf].terminal_job_id
	if not job or job == 0 then
		return false, "Terminal is not running"
	end

	if terminalBusy(buf) then
		return false, "Terminal is busy"
	end

	local ok, sent = pcall(vim.fn.chansend, job, command .. "\n")
	if not ok or sent == 0 then
		return false, "Failed to send command"
	end

	return true
end


return{
	projectKey = projectKey,
	loadRegistry = loadRegistry,
	saveRegistry = saveRegistry,
	isTerminal = isTerminal,
	terminalBusy = terminalBusy,
	runInTerminal = runInTerminal
}
