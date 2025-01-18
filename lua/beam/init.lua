local M = {}

local function can_open(str, pattern)
  return vim.fn.match(str, pattern) == 0 and true or false
end

local function can_open_url(url)
  local website_x =
  [[\v^((https?|ftp)://)?(www\.)?[a-zA-Z0-9_-]+\.[a-zA-Z]{2,}([:/][0-9]+)?(\/[a-zA-Z0-9_\/#.-]*)*(\?[a-zA-Z0-9_=&%+-]*)?$]]
  return can_open(url, website_x)
end

function M.open_url(url)
  local os_type = package.config:sub(1, 1)

  local is_windows = os_type == '\\'

  local is_mac = os_type == '/' and vim.fn.has("mac") == 1

  if is_windows then
    os.execute('start ' .. url)
  elseif is_mac then
    os.execute('open ' .. url)
  else
    os.execute('xdg-open ' .. url)
  end
end

local function can_open_file(path)
  local file_x = "^(%a%:?.-)\\?(.+)$"
  return can_open(path, file_x)
end

function M.open_file(path)
  vim.cmd('e ' .. path)
end

function M.open(str)
  if can_open_url(str) then
    M.open_url(str)
  elseif can_open_file(str) then
    M.open_file(str)
  else
    vim.print("Failed to beam" .. str)
  end
end

function M.scan_then_open()
  local url = vim.fn.expand('<cWORD>')
  M.open(url)
end

local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")

  local line_start, col_start = start_pos[2], start_pos[3]
  local line_end, col_end = end_pos[2], end_pos[3]

  local lines = vim.fn.getline(line_start, line_end)

  if #lines > 0 then
    lines[1] = lines[1]:sub(col_start)
    lines[#lines] = lines[#lines]:sub(1, col_end)
  end

  return table.concat(lines, "\n")
end

function M.open_visual_selection()
  local selected_text = get_visual_selection()
  M.open(selected_text)
end

return M
