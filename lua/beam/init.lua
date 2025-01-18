local M = {}

local function can_open_url(url)
  local pattern = "https?://(([%w_.~!*:@&+$/?%%#-]-)(%w[-.%w]*%.)(%w+)(:?)(%d*)(/?)([%w_.~!*:@&+$/?%%#=-]*))"
  return string.match(url, pattern) ~= nil
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
  local file = io.open(path, "r")
  if file then
    io.close(file)
    return true
  else
    return false
  end
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
  local s_start = vim.fn.getpos("v")
  local s_end = vim.fn.getpos(".")
  local n_lines = math.abs(s_end[2] - s_start[2]) + 1
  local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
  lines[1] = string.sub(lines[1], s_start[3], -1)

  if n_lines == 1 then
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
  else
    lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
  end

  return table.concat(lines, '\n')
end

function M.open_visual_selection()
  local selected_text = get_visual_selection()
  M.open(selected_text)
end

return M
