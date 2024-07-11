# keyjump.yazi

A Yazi plugin that allows jumping to a line by typing a hint character, much
like hop.nvim

> [!NOTE]
> The plug-in has been converted to asynchronous plug-in, so if you
> configured the `--sync` parameter before, please remove this parameter

## Global mode

In global mode, you can jump to everywhere; not only the current pane.
You also can use "Space" key to toggle item selection.

![Global Mode Example](https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/0a7a44cd-a91b-4377-9787-f4babb0303bf)

## Keep mode

In keep mode, when selecting a directory, it will auto enter and remain in
keyjump mode.

[Keep Mode Example](https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/dd998a34-49b0-481d-b032-d9849a89ba48)

## Normal mode

In normal mode, when selecting an item, it will leave keyjump mode.

[Normal Mode Example](https://github.com/DreamMaoMao/keyjump/assets/30348075/6ba722ce-8b55-4c80-ac81-b6b7ade74491)

## Select mode

In select mode, you can use the `Space` key to select/unselect item.

[Select Mode Example](https://github.com/DreamMaoMao/keyjump.yazi/assets/30348075/84faf1b5-7466-49d5-9598-fe9ef9098acc)

## Keybinds

```text
h: leave to parent folder (global)
l: enter folder (global)
k: arrow up 1 entry (global)
j: arrow down 1 entry (global)

Esc: exit keyjump (global,select,keep,normal)
z: exit keyjump (global,select,keep,normal)

Enter: open (global,select,keep,normal)
Space: toggle select (global,select,keep,normal)
Left: leave to parent folder (global,select,keep,normal)
Right: enter folder (global,select,keep,normal)
Up: arrow up 1 entry (global,select,keep,normal)
Down: arrow down 1 entry (global,select,keep,normal)
alt+k: seek up 5 entry (global,select,keep,normal)
alt+j: seek down 5 entry (global,select,keep,normal)
ctrl+k: prev page (global,select,keep,normal)
ctrl+j: next page entry (global,select,keep,normal)
K: arrow up 5 entry (global,select,keep,normal)
J: arrow down 5 entry (global,select,keep,normal)
```

## Install

```bash
ya pack -a redbeardymcgee/yazi-plugins#keyjump
```

## Usage

Set a shortcut key to toggle keyjump mode in `~/.config/yazi/keymap.toml`. For
example, to set `i` to toggle keyjump mode:

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin keyjump --args=keep"
desc = "Keyjump (Keep mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin keyjump"
desc = "Keyjump (Normal mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin keyjump --args=select"
desc = "Keyjump (Select mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin keyjump --args=global"
desc = "Keyjump (Global mode)"
```

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run  = "plugin keyjump --args='global once'"
desc = "Keyjump (once Global mode)"
```

## Configuration (~/.config/yazi/init.lua)

```lua
require("keyjump"):setup {
  icon_fg = "#fda1a1",
}
```
