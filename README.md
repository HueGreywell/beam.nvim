```text
██████╗ ███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔════╝██╔══██╗████╗ ████║
██████╔╝█████╗  ███████║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
 ```

# Opening Links and Files from String Outputs

## Available Functions:

**`scan_then_open()`**  
Retrieves the word under the cursor.  
Checks if it is a URL or a file path, and opens it.

**`open_visual_selection()`**  
Retrieves the visually selected text.  
Checks if it is a URL or a file path, and opens it.

**`save_path(path)`**  
Saves the given path so it can be opened later.

**`save_visual_path()`**  
Saves the currently selected text as a path for later use.

**`open_saved_path()`**  
Opens the saved path, if available, and deletes it after opening.

**`open(str)`**  
Checks if the input `str` is a URL or a file path and opens it.

**`open_url(url)`**  
Directly opens a specified URL.

**`can_open_file(path)`**  
Returns `true` if the given path is a valid and accessible file.

**`can_open_url(url)`**  
Returns `true` if the given URL is valid and accessible.

**`open_file(str)`**  
Do you need this?

## Allowed File Patterns:

The following file pattern will move the cursor as well:  
`/file/path/example:2:2`


Installation Example Using Lazy

```lua
 return {
  "HueGreywell/beam.nvim",
  config = function()
    local beam = require("beam")

    vim.keymap.set("n", ?, beam.scan_then_open)

    vim.keymap.set("v", ?, beam.open_visual_selection)
  end
}
```
