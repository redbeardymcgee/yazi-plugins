# git-status.yazi
git message prompt plugin for Yazi,

Asynchronous task loading without blocking the rendering of other components

![image](https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/3a95e25a-cf0e-4f03-8d92-e7c9cc0767bb)




https://github.com/DreamMaoMao/git-status.yazi/assets/30348075/f827dd33-8e51-4f8a-9069-0affc2f7aab8



# Install 

### Linux

```bash
git clone https://github.com/DreamMaoMao/git-status.yazi.git ~/.config/yazi/plugins/git-status.yazi
```

# Dependcy
- git

# Usage 

Add this to ~/.config/yazi/init.lua

```
require("git-status"):setup{
    style = "beside" -- beside or linemode
}
```
if you want listen for file changes to automatically update the status.
Add this to ~/.config/yazi/yazi.toml, `below the exists [plugin] modules`, like this
```
[plugin]

fetchers = [
	{ id = "git-status", name = "*", run = "git-status", prio = "normal" },
]
```
