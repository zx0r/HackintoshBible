#!/bin/bash

# First, let's set the language preferences
defaults write .GlobalPreferences AppleLanguages -array en-US

# Then refresh the language cache
sudo languagesetup

# Clear App Store cache
defaults delete com.apple.appstore
killall App Store

echo "Language settings have been configured correctly. App Store will now show available languages for downloads."

# Continue with your download...
