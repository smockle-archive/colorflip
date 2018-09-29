#!/usr/bin/env bash
today=$(date +%j)
distanceFromJune21st=$(echo "scale=4; ${today}-172.25" | bc | sed 's/-//g')

sunriseOnJune21st="5:48"
sunsetOnJune21st="20:34"
sunriseDelta=0.5092
sunsetDelta=1.2046

sunriseOffset=$(echo "scale=4; ${distanceFromJune21st}*${sunriseDelta}" | bc | awk '{print int($1+0.5)}')
sunsetOffset=$(echo "scale=4; ${distanceFromJune21st}*${sunsetDelta}" | bc | awk '{print int($1+0.5)}')

now=$(date +%s)
sunriseToday=$(date -j -f %H:%M -v+${sunriseOffset}M ${sunriseOnJune21st} +%s)
sunsetToday=$(date -j -f %H:%M -v-${sunsetOffset}M ${sunsetOnJune21st} +%s)

# Read appearance setting
appearance=$(defaults read NSGlobalDomain AppleInterfaceStyle 2>/dev/null 1>/dev/null && echo "Dark" || echo "Light")

if ([ "${appearance}" == "Light" ] && [ ${now} -le ${sunriseToday} ]) || ([ "${appearance}" == "Light" ] && [ ${now} -ge ${sunsetToday} ]); then
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  defaults write -app Visual\ Studio\ Code NSRequiresAquaSystemAppearance -bool No
  sed -i "" 's#"workbench.colorTheme": "Xcode Default (Light)"#"workbench.colorTheme": "Xcode Default (Dark)"#g' ${HOME}/Library/Application\ Support/Code/User/settings.json
elif [ "${appearance}" == "Dark" ] && [ ${now} -gt ${sunriseToday} ] && [ ${now} -lt ${sunsetToday} ]; then
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
  defaults write -app Visual\ Studio\ Code NSRequiresAquaSystemAppearance -bool Yes
  sed -i "" 's#"workbench.colorTheme": "Xcode Default (Dark)"#"workbench.colorTheme": "Xcode Default (Light)"#g' ${HOME}/Library/Application\ Support/Code/User/settings.json
fi
