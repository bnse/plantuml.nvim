local M = {}

--- Merges two or more map-like tables.
---@param dst table
---@param src? table
---@return table
function M.merge_tables(dst, src)
  return vim.tbl_extend('force', dst, src or {})
end

-- A command runner.
---@class utils.Runner
---@field cmd string
---@field codes { [number]: boolean }
M.Runner = {}

--- Creates a new instance with the command and allowed exit codes.
---@param cmd string
---@param codes? { [number]: boolean }
---@return utils.Runner
function M.Runner:new(cmd, codes)
  self.__index = self
  return setmetatable({ cmd = cmd, codes = codes or { [0] = true } }, self)
end

--- Runs the command optionally calling on_success with stdout.
---@param on_success? fun(stdout: string[]): nil
---@return number
function M.Runner:run(on_success)
  local stderr
  local stdout

  local id = vim.fn.jobstart(self.cmd, {
    detach = true,
    on_exit = function(_, code, _)
      if next(self.codes) ~= nil and not self.codes[code] then
        local msg = table.concat(stderr)
        error(string.format('exit job for command "%s"\n%s\ncode: %d', self.cmd, msg, code))
      end

      if on_success then
        on_success(stdout)
      end
    end,
    on_stderr = function(_, data, _)
      stderr = data
    end,
    on_stdout = function(_, data, _)
      stdout = data
    end,
    stderr_buffered = true,
    stdout_buffered = true,
  })
  assert(id > 0, string.format('start job for command "%s"', self.cmd))

  return vim.fn.jobpid(id)
end

return M
