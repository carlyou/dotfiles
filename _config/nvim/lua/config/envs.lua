-- Set up Python environment for plugins that require it
-- Use XDG-compliant path for the venv
local venv_path = vim.fn.stdpath 'data' .. '/venv'
local python_path

python_path = venv_path .. '/bin/python'
vim.notify('Neovim Python environment:' .. python_path, vim.log.levels.WARN)

-- Check if venv exists
if vim.fn.executable(python_path) == 1 then
  vim.g.python3_venv_path = venv_path
  vim.g.python3_host_prog = python_path
else
  vim.notify('Neovim Python environment not found. Run init.sh', vim.log.levels.WARN)
end
