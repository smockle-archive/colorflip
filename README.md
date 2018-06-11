# colorflip

Change UI appearance based on ambient light.

## Install

```Bash
$ sudo cp com.smockle.colorflip.plist /Library/LaunchAgents
$ sudo launchctl load -w /Library/LaunchAgents/com.smockle.colorflip.plist
```

## Uninstall

```Bash
$ sudo launchctl unload -w /Library/LaunchAgents/com.smockle.colorflip.plist
$ sudo rm /Library/LaunchAgents/com.smockle.colorflip.plist
```

## Sources

- https://matthewbilyeu.com/blog/2018-04-09/setting-emacs-theme-based-on-ambient-light
