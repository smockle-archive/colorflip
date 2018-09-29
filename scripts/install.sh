#!/usr/bin/env bash
cp -f com.smockle.colorflip.plist ~/Library/LaunchAgents
launchctl load -w ~/Library/LaunchAgents/com.smockle.colorflip.plist