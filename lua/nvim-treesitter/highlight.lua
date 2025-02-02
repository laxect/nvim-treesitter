local api = vim.api
local ts = vim.treesitter

local parsers = require "nvim-treesitter.parsers"
local configs = require "nvim-treesitter.configs"

local M = {}

local function should_enable_vim_regex(config, lang)
  local additional_hl = config.additional_vim_regex_highlighting
  local is_table = type(additional_hl) == "table"

  return additional_hl and (not is_table or vim.tbl_contains(additional_hl, lang))
end

local function enable_syntax(bufnr)
  api.nvim_buf_set_option(bufnr, "syntax", "ON")
end

function M.stop(bufnr)
  if ts.highlighter.active[bufnr] then
    ts.highlighter.active[bufnr]:destroy()
  end
end

function M.start(bufnr, lang)
  local parser = parsers.get_parser(bufnr, lang)
  ts.highlighter.new(parser, {})
end

function M.attach(bufnr, lang)
  local config = configs.get_module "highlight"
  M.start(bufnr, lang)
  if should_enable_vim_regex(config, lang) then
    enable_syntax(bufnr)
  end
end

function M.detach(bufnr)
  M.stop(bufnr)
  enable_syntax(bufnr)
end

return M
