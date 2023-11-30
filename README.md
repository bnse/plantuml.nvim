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
  'https://gitlab.com/itaranto/plantuml.nvim',
  version = '*',
  config = function() require('plantuml').setup() end,
}
```

Install with [packer](https://github.com/wbthomason/packer.nvim):

```lua
use {
  'https://gitlab.com/itaranto/plantuml.nvim',
  tag = '*',
  config = function() require('plantuml').setup() end
}
```

## Dependencies

To use this plugin, you'll need PlantUML installed. If using any of the external renderers, you'll
need to have them installed as well.

You should be able to install any of these with your system's package manager, for example, on Arch
Linux:

```sh
sudo pacman -S plantuml imv feh
```

## Configuration

To use the default configuration, do:

```lua
require('plantuml').setup()
```

The default values are:

```lua
{
  renderer = {
    type = 'text',
    options = {
      split_cmd = 'vsplit', -- Allowed values: `split`, `vsplit`.
    }
  },
  render_on_write = true, -- Set to false to disable auto-rendering.
}
```

To use other renderers, change the `type` property.

Defaults for the *image* renderer:

```lua
{
  renderer = {
    type = 'image',
    options = {
      prog = 'feh',
      dark_mode = true,
    }
  },
  render_on_write = true,
}
```

Defaults for the *imv* renderer:

```lua
{
  renderer = {
    type = 'imv',
    options = {
      dark_mode = true,
    }
  },
  render_on_write = true,
}
```

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

## Contributing

*"If your commit message sucks, I'm not going to accept your pull request."*
