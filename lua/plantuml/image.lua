local plantuml = require('plantuml.plantuml')
local utils = require('plantuml.utils')

local M = {}

---@class image.RendererOptions
---@field prog? string
---@field dark_mode? boolean

---@class image.Renderer
---@field prog string
---@field dark_mode boolean
---@field tmp_file string
---@field started boolean
M.Renderer = {}

---@param options? image.RendererOptions
---@return image.Renderer
function M.Renderer:new(options)
  options = utils.merge_tables({ prog = 'feh', dark_mode = true }, options)

  self.__index = self
  return setmetatable({
    prog = options.prog,
    dark_mode = options.dark_mode,
    tmp_file = vim.fn.tempname(),
    started = false,
  }, self)
end

---@param file string
---@return nil
function M.Renderer:render(file)
  plantuml.create_image_runner(file, self.tmp_file, self.dark_mode):run(function(_)
    self:start_viewer()
  end)
end

---@private
---@return nil
function M.Renderer:start_viewer()
  -- Only start the viewer if it wasn't already started.
  if not self.started then
    local cmd = string.format('%s %s', self.prog, self.tmp_file)
    utils.Runner:new(cmd, {}):run(function(_)
      self.started = false
    end)
    self.started = true
  end
end

return M
