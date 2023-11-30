local assert = require('luassert.assert')

local M = {}

-- A callback tracker user for testing.
---@class utils.CallbackTracker
---@field calls function[]
---@field total_calls number
---@field err string
M.CallbackTracker = {}

-- Creates a new instance.
---@param total_calls? number
---@param err? string
---@return utils.CallbackTracker
function M.CallbackTracker:new(total_calls, err)
  self.__index = self
  return setmetatable({
    calls = {},
    total_calls = total_calls,
    err = err,
  }, self)
end

-- Tracks a new callback.
-- Defers the callback's execution by inserting it into `calls`.
-- It will insert an error call if `call_nr` is greater than `total_calls`.
-- It's ideal for using inside luassert's `invokes`.
---@param call_nr number
---@param func function
---@return nil
function M.CallbackTracker:track(call_nr, func)
  if self.err and call_nr > self.total_calls then
    table.insert(self.calls, function()
      error(self.err)
    end)
  else
    table.insert(self.calls, func)
  end
end

-- Invokes all the stored callbacks.
---@return nil
function M.CallbackTracker:invoke_calls()
  for _, call in ipairs(self.calls) do
    call()
  end
end

-- Asserts exactly one error is thrown from invoking the callbacks.
---@return nil
function M.CallbackTracker:assert_calls()
  assert.has_error(function()
    for _, call in ipairs(self.calls) do
      call()
    end
  end, self.err)
end

-- Asserts every callback throws an error.
---@return nil
function M.CallbackTracker:assert_each_call()
  for _, call in ipairs(self.calls) do
    assert.has_error(function()
      call()
    end, self.err)
  end
end

return M
