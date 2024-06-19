# kickstart.nvim

## Introduction

Alikhan Bissakov's fork of the kickstart.nvim configuration. The original kickstart.nvim configuration can be found [here](https://github.com/nvim-lua/kickstart.nvim).

## Installation

### Install Neovim

[Install Neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md)

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, `gcc`, `make`, `rg`, `fd`, `fzf`, `jsregexp`, `wget`, `curl`, `gzip`, `tar`, `pwsh`, `7z`, `win32yank`
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- A [Nerd Font](https://www.nerdfonts.com/)
- Language Setup:
  - If want to write Typescript, you need `npm`
  - If want to write Golang, you will need `go`
  - etc.

### Install Kickstart

> **NOTE**
> [Backup](#FAQ) your previous configuration (if any exists)

Neovim's configurations are located under the following paths, depending on your OS:

| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%userprofile%\AppData\Local\nvim\` |
| Windows (powershell)| `$env:USERPROFILE\AppData\Local\nvim\` |

#### Recommended Step

[Fork](https://docs.github.com/en/get-started/quickstart/fork-a-repo) this repo
so that you have your own copy that you can modify, then install by cloning the
fork to your machine using one of the commands below, depending on your OS.

> **NOTE**
> Your fork's url will be something like this:
> `https://github.com/<your_github_username>/kickstart.nvim.git`

#### Clone kickstart.nvim
> **NOTE**
> If following the recommended step above (i.e., forking the repo), replace
> `nvim-lua` with `<your_github_username>` in the commands below

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/bissakov/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone https://github.com/nvim-lua/kickstart.nvim.git %userprofile%\AppData\Local\nvim\
```

If you're using `powershell.exe`

```
git clone https://github.com/nvim-lua/kickstart.nvim.git $env:USERPROFILE\AppData\Local\nvim\
```

</details>

### Post Installation

Start Neovim

```sh
nvim
```

That's it! Lazy will install all the plugins you have. Use `:Lazy` to view
current plugin status. Hit `q` to close the window.

Read through the `init.lua` file in your configuration folder for more
information about extending and exploring Neovim.


#### Examples of adding popularly requested plugins

NOTE: You'll need to uncomment the line in the init.lua that turns on loading custom plugins.

<details>
  <summary>Adding autopairs</summary>

This will automatically install [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
and enable it on startup. For more information, see documentation for
[lazy.nvim](https://github.com/folke/lazy.nvim).

In the file: `lua/custom/plugins/autopairs.lua`, add:

```lua
-- File: lua/custom/plugins/autopairs.lua

return {
  "windwp/nvim-autopairs",
  -- Optional dependency
  dependencies = { 'hrsh7th/nvim-cmp' },
  config = function()
    require("nvim-autopairs").setup {}
    -- If you want to automatically add `(` after selecting a function or method
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )
  end,
}
```

</details>

<details>
  <summary>Adding a file tree plugin</summary>

This will install the tree plugin and add the command `:Neotree` for you.
For more information, see the documentation at
[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim).

In the file: `lua/custom/plugins/filetree.lua`, add:

```lua
-- File: lua/custom/plugins/filetree.lua

return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "*",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
  },
  config = function ()
    require('neo-tree').setup {}
  end,
}
```

</details>
