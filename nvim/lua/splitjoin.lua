local M = {}

M.max_join_length = 260

local LANG_NODE_TYPES = {
  lua = {
    table_constructor = { arglist = false },
    arguments = { arglist = true },
  },
  javascript = {
    array = { arglist = false },
    object = { arglist = false },
    array_pattern = { arglist = false },
    object_pattern = { arglist = false },
    arguments = { arglist = true },
  },
  typescript = {
    array = { arglist = false },
    object = { arglist = false },
    array_pattern = { arglist = false },
    object_pattern = { arglist = false },
    arguments = { arglist = true },
  },
  json = {
    object = { arglist = false },
    array = { arglist = false },
  },
  python = {
    list = { arglist = false },
    dictionary = { arglist = false },
    argument_list = { arglist = true },
  },
  go = {
    composite_literal = { arglist = false },
    argument_list = { arglist = true },
  },
  rust = {
    array = { arglist = false },
    tuple_expression = { arglist = false },
    struct_expression = { arglist = false },
    arguments = { arglist = true },
  },
}

local function is_target_node(ft, node)
  local m = LANG_NODE_TYPES[ft]
  if not m then return false end
  return m[node:type()] ~= nil
end

local function is_arglist_node(ft, node)
  local m = LANG_NODE_TYPES[ft]
  if not m then return false end
  local node_cfg = m[node:type()]
  return node_cfg and node_cfg.arglist or false
end

local function get_enclosing_node()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if not LANG_NODE_TYPES[ft] then return nil end

  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, ft)
  if not ok or not parser then return nil end

  local tree = parser:parse()[1]
  if not tree then return nil end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local node = tree:root():descendant_for_range(row, col, row, col)
  while node do
    if is_target_node(ft, node) then
      return node
    end
    node = node:parent()
  end

  return nil
end

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function get_text(bufnr, node)
  local sr, sc, er, ec = node:range()
  return table.concat(vim.api.nvim_buf_get_text(bufnr, sr, sc, er, ec, {}), "\n")
end

local function get_line(bufnr, row)
  return vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""
end

local function has_comment_child(node)
  for child in node:iter_children() do
    if child:type() == "comment" then
      return true
    end
  end
  return false
end

local function last_index_of(s, ch)
  local i, last = 1, nil
  while true do
    local j = s:find(ch, i, true)
    if not j then break end
    last = j
    i = j + 1
  end
  return last
end

---------------------------------------------------------------------
-- Item container vs range container
--
-- For containers: items_node == range_node == node
-- For arglists:   items_node == node, range_node == parent (function_call)
---------------------------------------------------------------------

local function get_nodes_for_edit(ft, node)
  if is_arglist_node(ft, node) then
    local parent = node:parent()
    -- parent is function_call / call_expression in all our targets
    if parent then
      return node, parent, true
    else
      return node, node, true
    end
  else
    return node, node, false
  end
end

local function detect_brackets(bufnr, range_node, is_args, items_node)
  local sr, sc, er, ec

  if is_args then
    sr, sc, er, ec = items_node:range()
  else
    sr, sc, er, ec = range_node:range()
  end

  local first = get_line(bufnr, sr)
  local last = get_line(bufnr, er)

  local open_char, close_char
  local map = { ["["] = "]", ["{"] = "}", ["("] = ")" }

  if is_args then
    open_char, close_char = "(", ")"
  else
    local idx = sc + 1
    open_char = first:sub(idx, idx)
    close_char = map[open_char]
    if not close_char then
      -- Fallback: find first bracket character
      open_char = first:match("[%[%{%(%)]")
      close_char = open_char and map[open_char] or nil
    end
  end

  if not open_char or not close_char then
    return nil, nil, nil, nil, true
  end

  -- Find opening bracket position on first line, starting from node start
  local open_pos = first:find(open_char, sc + 1, true) or first:find(open_char, 1, true)
  -- Find last closing bracket position on last line
  local close_pos = last_index_of(last, close_char)

  if not open_pos or not close_pos then
    return nil, nil, nil, nil, true
  end

  local prefix = first:sub(1, open_pos - 1)
  local suffix = last:sub(close_pos + 1)

  return prefix, suffix, open_char, close_char, false
end

local function get_items_text(bufnr, items_node)
  local items = {}
  local skip_types = { comment = true, [","] = true, [";"] = true }

  for child in items_node:iter_children() do
    local child_type = child:type()
    if child:named() and not skip_types[child_type] then
      local t = get_text(bufnr, child)
      t = trim(t:gsub(",$", ""):gsub(";$", ""))
      if t ~= "" then
        table.insert(items, t)
      end
    end
  end
  return items
end

local function normalize_container_item(x)
  -- Normalize spacing around operators
  x = x:gsub("%s*=%s*", " = ")
  x = x:gsub("%s*:%s*", ": ")
  x = x:gsub("%s*,%s*", ", ")
  -- Collapse multiple spaces to single space
  x = x:gsub("%s+", " ")
  return trim(x)
end

local function normalize_arg_item(x)
  -- Normalize spacing in nested structures
  x = x:gsub("%s*,%s*", ", ")
  x = x:gsub("%s*:%s*", ": ")
  -- Collapse multiple spaces to single space
  x = x:gsub("%s+", " ")
  return trim(x)
end

local function is_multiline_node(node)
  local sr, _, er, _ = node:range()
  return er > sr
end

local function do_join(bufnr, node, ft)
  local items_node, range_node, is_args = get_nodes_for_edit(ft, node)
  if has_comment_child(items_node) then return end

  local prefix, suffix, open_char, close_char, fail =
      detect_brackets(bufnr, range_node, is_args, items_node)
  if fail then return end

  local items = get_items_text(bufnr, items_node)

  local body = {}
  for _, it in ipairs(items) do
    if is_args then
      table.insert(body, normalize_arg_item(it))
    else
      table.insert(body, normalize_container_item(it))
    end
  end

  local inside = table.concat(body, ", ")

  local joined
  if inside == "" then
    joined = prefix .. open_char .. close_char .. suffix
  else
    if is_args then
      -- No spaces for argument lists
      joined = prefix .. open_char .. inside .. close_char .. suffix
    else
      -- Spaces for containers
      joined = prefix .. open_char .. " " .. inside .. " " .. close_char .. suffix
    end
  end

  if #joined > M.max_join_length then
    return
  end

  local sr, _, er, _ = range_node:range()
  vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, { joined })
end

local function do_split(bufnr, node, ft)
  local items_node, range_node, is_args = get_nodes_for_edit(ft, node)
  if has_comment_child(items_node) then return end

  local prefix, suffix, open_char, close_char, fail =
      detect_brackets(bufnr, range_node, is_args, items_node)
  if fail then return end

  local sr, _, er, _ = range_node:range()
  local indent = prefix:match("^%s*") or ""

  local shift = vim.o.shiftwidth
  if shift == 0 then shift = 4 end
  local inner_indent = indent .. string.rep(" ", shift)

  local items = get_items_text(bufnr, items_node)
  local out = {}

  table.insert(out, prefix .. open_char)

  if is_args then
    -- argument lists: NO trailing commas
    for i, it in ipairs(items) do
      local norm = normalize_arg_item(it)
      table.insert(out, inner_indent .. norm .. (i < #items and "," or ""))
    end
  else
    -- containers: trailing comma (style C)
    for _, it in ipairs(items) do
      local norm = normalize_container_item(it)
      table.insert(out, inner_indent .. norm .. ",")
    end
  end

  table.insert(out, indent .. close_char .. suffix)

  vim.api.nvim_buf_set_lines(bufnr, sr, er + 1, false, out)

  -- Position cursor at the first item (start of second line content)
  if #out > 1 then
    local cursor_line = sr + 2
    local cursor_col = #out[2] - #trim(out[2])
    vim.api.nvim_win_set_cursor(0, { cursor_line, cursor_col })
  end
end

function M.toggle(opts)
  opts = opts or {}
  if opts.max_join_length then
    M.max_join_length = opts.max_join_length
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local node = get_enclosing_node()
  if not node then return end

  local target_node = node
  local _, range_node = get_nodes_for_edit(ft, node)

  if is_multiline_node(range_node) then
    do_join(bufnr, target_node, ft)
  else
    do_split(bufnr, target_node, ft)
  end
end

function M.join(opts)
  opts = opts or {}
  if opts.max_join_length then
    M.max_join_length = opts.max_join_length
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local node = get_enclosing_node()
  if not node then return end

  do_join(bufnr, node, ft)
end

function M.split(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype
  local node = get_enclosing_node()
  if not node then return end

  do_split(bufnr, node, ft)
end

return M
