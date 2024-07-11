# searchjump.yazi

A Yazi plugin with behavior similar to flash.nvim in Neovim, allowing a search
string to generate label to jump. Supports Chinese pinyin search, and regular
expression search.

## English search

![English Example](https://github.com/DreamMaoMao/searchjump.yazi/assets/30348075/eec237c9-91be-4b6e-9db8-a84eb419cae5)

## Chinese pinyin search (first character of a word pinyin)

![Pinyin Example](https://github.com/DreamMaoMao/searchjump.yazi/assets/30348075/8acf8316-c8d4-497d-af5a-7d85924c57a2)

## Regular expression search (set patterns in option `search_patterns`)

For example:

```lua
search_patterns = {"%.e%d+","s%d+e%d+","%d+.1080p","第%d+集"}
```

![Regex Example](https://github.com/DreamMaoMao/searchjump.yazi/assets/30348075/a68bd599-04c6-467a-a987-53a6684529af)

## Install

> [!NOTE]
> Yazi 0.3.0 or newer is required!

```bash
ya pack -a redbeardymcgee/yazi-plugins#fg
```

## Usage

Set a shortcut key to toggle searchjump mode in `~/.config/yazi/keymap.toml`.
For example set `i` to toggle searchjump mode:

```toml
[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin searchjump"
desc = "searchjump mode"


[[manager.prepend_keymap]]
on   = [ "i" ]
run = "plugin searchjump --args='autocd'"
desc = "searchjump mode(auto cd select folder)"
```

When you press the shortcut followed by the character to search, you will see
a label to the right of every match of the searched character. Press the key of
the label to jump to the corresponding entry. If you want to search
Chinese, for example, search `你好`, you can press `n` or `nh` to search.

## Configuration (~/.config/yazi/init.lua)

```lua
require("searchjump"):setup {
  unmatch_fg = "#928374",
  match_str_fg = "#000000",
  match_str_bg = "#73AC3A",
  lable_fg = "#EADFC8",
  lable_bg = "#BA603D",
  only_current = false, -- only search the current window
  show_search_in_statusbar = true,
  auto_exit_when_unmatch = true,
  search_patterns = {}  -- demo:{"%.e%d+","s%d+e%d+"}
}
```

## It is worth noting

- The `<Space>` key is a special key when you are in searchjump mode. It will
  toggle searchjump to use the regular expressions set in search_patterns.
- The regex match is case insensitive
- The `<Enter>` key will jump to the first match result or only result
- The `<Backspace>` key will rubout the last key you input
