-- Add nvm node binaries to PATH for claudecode.nvim
local nvm_node_path = vim.env.HOME .. '/.nvm/versions/node/v22.19.0/bin'
if vim.fn.isdirectory(nvm_node_path) == 1 then
  vim.env.PATH = nvm_node_path .. ':' .. vim.env.PATH
end

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
