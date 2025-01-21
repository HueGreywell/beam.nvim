local M = {}

M.saved_file_path = nil

local function log(message)
  vim.notify(message, vim.log.levels.INFO)
end

function M.can_open_url(url)
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

--- returns file_path, line, column
--- /path/example:2:5
local function extract_path_and_line(path)
  return path:match("^(.-):?(%d*):?(%d*)$")
end

function M.can_open_file(path)
  local file_path, _, _ = extract_path_and_line(path)

  local file = io.open(file_path, "r")

  if file then
    io.close(file)
    return true
  else
    return false
  end
end

function M.open_file(path)
  local file_path, line, _ = extract_path_and_line(path)

  vim.cmd('e ' .. file_path)

  if (line ~= nil and #line > 0) then
    vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
  end
end

function M.open(str)
  if M.can_open_url(str) then
    M.open_url(str)
  elseif M.can_open_file(str) then
    M.open_file(str)
  else
    log("Failed to beam " .. str)
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

function M.open_()
  local selected_text = get_visual_selection()
  M.open(selected_text)
end

function M.open_saved_path()
  if M.saved_file_path == nil then
    log("There is no saved path")
    return
  end

  M.open(M.saved_file_path)
  M.saved_file_path = nil
end

function M.save_visual_path()
  local path = get_visual_selection()
  if M.can_open_file(path) then
    M.saved_file_path = path
    return
  end

  log("Can't save: " .. path)
end

function M.save_path()
  local path = vim.fn.expand('<cWORD>')
  if M.can_open_file(path) then
    M.saved_file_path = path
    return
  end

  log("Can't save: " .. path)
end

return M
