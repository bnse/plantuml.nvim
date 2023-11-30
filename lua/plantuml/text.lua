local plantuml = require('plantuml.plantuml')
local utils = require('plantuml.utils')

local M = {}

---@class text.RendererOptions
---@field split_cmd? string

-- A text renderer.
---@class text.Renderer
---@field buf number
---@field win number
---@field split_cmd string
M.Renderer = {}

-- Creates a new instance with the provided options.
---@param options? text.RendererOptions
---@return text.Renderer
function M.Renderer:new(options)
  options = utils.merge_tables({ split_cmd = 'vsplit' }, options)

  local buf = vim.api.nvim_create_buf(false, true)
  assert(buf ~= 0, string.format('create buffer'))

  self.__index = self
  return setmetatable({ buf = buf, win = nil, split_cmd = options.split_cmd }, self)
end

-- Renders a PlantUML file as text using a Neovim buffer.
---@param file string
---@return nil
function M.Renderer:render(file)
  plantuml.create_text_runner(file):run(function(output)
    self:write_output(output)
    self:create_split()
  end)
end

--- Writes the output to the buffer.
---@private
---@param output string[]
---@return nil
function M.Renderer:write_output(output)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, true, output)
end

--- Creates a split for displaying the output.
---@private
---@return nil
function M.Renderer:create_split()
  -- Only create the window if it wasn't already created.
  if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
    vim.api.nvim_command(self.split_cmd)
    self.win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(self.win, self.buf)
  end
end

return M
