<!-- # plantuml.nvim -->
Fork from https://gitlab.com/itaranto/plantuml.nvim
remove the webp git-lfs file.

This Neovim plugin allows using [PlantUML](https://plantuml.com/) to render diagrams in real time.


This plugin supports different renderers to display PlantUML's output. Currently,
the following renderers are implemented:
- **text**: An ASCII art renderer using PlantUML's text output.
- **image**: A generic image render.  
  It runs the provided image viewer program with the generated image as an argument.  
  Best suited for viewers that support auto-reloading like: *feh*, *nsxiv*, *sxiv*, etc.
- **imv**: Uses the [imv](https://sr.ht/~exec64/imv/) image viewer.  
  This needs its separate renderer to work around an [issue](https://todo.sr.ht/~exec64/imv/45) with
  auto-reloading.

## Installation

Install with [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "bnse/plantuml.nvim",
    version = "*",
    config = function()
        require("lvim.lsp.manager").setup("plantuml", {
            renderer = {
                type = "text",
                options = {
                    split_cmd = "split", -- Allowed values: `split`, `vsplit`.
                },
            },
            render_on_write = false, -- Set to false to disable auto-rendering.
        })
    end,
},
```

## Dependencies

```sh
brew install plantuml
```

Install the SVG viewer `Gapplin` from the APP STORE.


Use `reflex` to observe file changes.

```bash
puml () 
{ 
    if [[ "$#" -ne 1 ]]; then
        printf "Usage: puml  %s\n" "demo.plantuml";
        return 1;
    fi;
    reflex -d none -r '\.plantuml$' -s -- sh -c "plantuml -tsvg ${1}"
}
```

Use Gapplin to view SVG files.

## Usage

Open a file with a supported extension and then write it. A new window will be opened
with the resulting diagram.

Alternatively, the `PlantUML` command can be run. It will only render files with a supported
extension.

The supported file extensions are:

- `.iuml`
- `.plantuml`
- `.pu`
- `.puml`
- `.wsd`

