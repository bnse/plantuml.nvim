local assert = require('luassert.assert')
local mock = require('luassert.mock')

local imv = require('plantuml.imv')
local test_utils = require('tests.plantuml.utils')
local utils = require('plantuml.utils')

describe('Test Renderer', function()
  local test_tmp_file = 'tmp-file'

  describe('new', function()
    local vim_fn

    before_each(function()
      -- Apparently, busted/luassert cannot patch vim.fn.
      vim_fn = vim.fn
      vim.fn = { tempname = function() return test_tmp_file end }
    end)

    after_each(function()
      vim.fn = vim_fn
    end)

    it('should create the instance with default settings', function()
      local renderer = imv.Renderer:new()

      assert.equals(true, renderer.dark_mode)
      assert.equals(test_tmp_file, renderer.tmp_file)
      assert.equals(0, renderer.pid)
    end)

    it('should create the instance with custom settings', function()
      local renderer = imv.Renderer:new({ dark_mode = false })

      assert.equals(false, renderer.dark_mode)
      assert.equals(test_tmp_file, renderer.tmp_file)
      assert.equals(0, renderer.pid)
    end)
  end)

  describe('render', function()
    local vim_fn
    local runner_mock
    local renderer

    before_each(function()
      -- Apparently, busted/luassert cannot patch vim.fn.
      vim_fn = vim.fn
      vim.fn = { tempname = function() return test_tmp_file end }

      runner_mock = mock(utils.Runner, true)
      runner_mock.new.returns(runner_mock)

      renderer = imv.Renderer:new()
    end)

    after_each(function()
      mock.revert(runner_mock)
      vim.fn = vim_fn
    end)

    ---@param cb_tracker utils.CallbackTracker
    ---@return nil
    local function mock_run_error(cb_tracker)
      runner_mock.run.invokes(function(rmock, on_success)
        cb_tracker:track(#rmock.run.calls, on_success)
        return 1
      end)
    end

    it('should forward server run error', function()
      local cb_tracker = test_utils.CallbackTracker:new(0, 'test error')
      mock_run_error(cb_tracker)

      renderer:render('filename')

      cb_tracker:assert_each_call()
      assert.equals(1, renderer.pid)
    end)

    it('should forward plantuml run error', function()
      local cb_tracker = test_utils.CallbackTracker:new(1, 'test error')
      mock_run_error(cb_tracker)

      renderer:render('filename')

      cb_tracker:assert_calls()
      assert.equals(0, renderer.pid)
    end)

    it('should forward close run error', function()
      local cb_tracker = test_utils.CallbackTracker:new(2, 'test error')
      mock_run_error(cb_tracker)

      renderer:render('filename')

      cb_tracker:assert_calls()
      assert.equals(0, renderer.pid)
    end)

    it('should forward open run error', function()
      local cb_tracker = test_utils.CallbackTracker:new(3, 'test error')
      mock_run_error(cb_tracker)

      renderer:render('filename')

      cb_tracker:assert_calls()
      assert.equals(0, renderer.pid)
    end)

    it('should render succesfully', function()
      local cb_tracker = test_utils.CallbackTracker:new()
      mock_run_error(cb_tracker)

      renderer:render('filename')

      cb_tracker:invoke_calls()
      assert.equals(0, renderer.pid)
    end)
  end)
end)
