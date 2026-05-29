local function find_godot_root()
  local cwd = vim.fn.getcwd()
  for _, path in ipairs({ cwd, cwd .. "/.." }) do
    if vim.uv.fs_stat(path .. "/project.godot") then
      return path
    end
  end
  return nil
end

local godot_root = find_godot_root()
if godot_root then
  local pipe = godot_root .. "/server.pipe"
  if not vim.uv.fs_stat(pipe) then
    vim.fn.serverstart(pipe)
  end
end

