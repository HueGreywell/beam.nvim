```text
██████╗ ███████╗ █████╗ ███╗   ███╗
██╔══██╗██╔════╝██╔══██╗████╗ ████║
██████╔╝█████╗  ███████║██╔████╔██║
██╔══██╗██╔══╝  ██╔══██║██║╚██╔╝██║
██████╔╝███████╗██║  ██║██║ ╚═╝ ██║
╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
 ```

Opening Links and Files from String Outputs

• `scan_then_open()` gets the word under the cursor, checks if it's a URL or file path, and opens it.  

• `open_visual_selection` command retrieves the visual selection, checks if it's a URL or file path, and opens it.

• `beam.open(str)` checks if `str` is a URL or file path and opens it.

• `beam.open_url(url)` opens url 

• `beam.open_file(str)` do you even need this?

Install with lazy

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
