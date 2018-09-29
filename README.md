# colorflip

Change UI appearance based on time of day.

## Install

```Bash
$ cp com.smockle.colorflip.plist ~/Library/LaunchAgents
$ launchctl load -w /Library/LaunchAgents/com.smockle.colorflip.plist
```

## Uninstall

```Bash
$ launchctl unload -w /Library/LaunchAgents/com.smockle.colorflip.plist
$ rm /Library/LaunchAgents/com.smockle.colorflip.plist
```

## Sources

- https://matthewbilyeu.com/blog/2018-04-09/setting-emacs-theme-based-on-ambient-light
