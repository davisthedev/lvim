local M = {}

M.logVariable = function()
  -- Determine the file extension of the current buffer
  local fileExtension = vim.fn.expand("%:e")
  -- Get the name of the current file
  local fileName = vim.fn.expand("%:t")
  -- Get the current cursor position to extract the line number
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- Define log formats for various programming languages
  local logFormats = {
    lua = 'print("%s:%d: %%s = ", %%s)',
    go = 'log.Printf("%%s:%d: %%s = %%#v\\n", "%s", %%s)',
    js = 'console.log("%s:%d: %%s =", %%s);',
    ts = 'console.log("%s:%d: %%s =", %%s);',
    vue = 'console.log("%s:%d: %%s =", %%s);',
    svelte = 'console.log("%s:%d: %%s =", %%s);',
    rust = 'println!("%s:%d: %%s = {:?}", %%s);',
    cpp = 'std::cout << "%s:%d: %%s = " << %%s << std::endl;',
    c = 'printf("%s:%d: %%s = %%s\\n", %%s);',
    py = 'print(f"%s:%d: %%s =", %%s)',
    java = 'System.out.println("%s:%d: %%s = " + %%s);',
    php = 'echo "%s:%d: %%s = " . %%s . PHP_EOL;',
    swift = 'print("%s:%d: %%s = \\(%%s)")',
    kotlin = 'println("%s:%d: %%s = $%%s")',
    rb = 'puts "%s:%d: %%s = #{%%s}"',
  }

  -- Choose the format based on the file extension or default to console.log
  local format = logFormats[fileExtension] or 'console.log("%s:%d: %%s =", %%s);'

  -- Get the text of the current line
  local line = vim.api.nvim_get_current_line()

  -- Extract leading whitespace from the line for indentation
  local indentation = line:match("^(%s*)")

  -- Initialize the start and end positions for the variable name at the cursor position
  local s, e = col + 1, col + 1

  -- Expand the start position backwards to find the beginning of the variable name
  while s > 1 do
    if line:sub(s - 1, s - 1):match("[%.%w_]") then
      s = s - 1
    else
      break
    end
  end

  -- Expand the end position forwards to find the end of the variable name
  while e <= #line do
    if line:sub(e, e):match("[%.%w_]") then
      e = e + 1
    else
      break
    end
  end

  -- Extract the variable name from the line
  local fullVariable = line:sub(s, e - 1)

  -- Format the log statement with the file name, line number, and the variable name
  local logStatement = string.format(format, fileName, row, fullVariable, fullVariable)
  -- Add indentation to the log statement for proper alignment
  logStatement = indentation .. logStatement

  -- Insert the log statement into the buffer below the current line
  vim.api.nvim_buf_set_lines(0, row, row, false, { logStatement })
end

return M
