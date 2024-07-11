# git-status.yazi

An asynchronous git message prompt plugin for Yazi.

![image1](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/3a95e25a-cf0e-4f03-8d92-e7c9cc0767bb)

![image2](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/f827dd33-8e51-4f8a-9069-0affc2f7aab8)

## Install

```bash
ya pack -a redbeardymcgee/yazi-plugins#git-status
```

This plugin depends on the `git` binary. Please ensure it is available in your
`$PATH`. For example with `bash`:

```bash
> type -P git
/usr/bin/git
```

### Usage

Add this to ~/.config/yazi/init.lua

```lua
require("git-status"):setup{
  style = "beside" -- beside or linemode
}
```

If you want to watch for file changes to automatically update the status, add
this to ~/.config/yazi/yazi.toml below the existing [plugin] modules, like this

```toml
[plugin]

fetchers = [
  id = "git-status", name = "*", run = "git-status", prio = "normal" },
]
```
