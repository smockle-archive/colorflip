#!/usr/bin/env bash

sunrise() {
  dayNumber=$1
  distanceFromJune21st=$(echo "scale=4; ${dayNumber}-172.25" | bc | sed 's/-//g')
  sunriseOnJune21st="5:48"
  sunriseDelta=0.5092
  sunriseOffset=$(echo "scale=4; ${distanceFromJune21st}*${sunriseDelta}" | bc | awk '{print int($1+0.5)}')
  sunriseTime=$(date -j -f %H:%M -v+${sunriseOffset}M ${sunriseOnJune21st} +%s)
  echo $sunriseTime
}

sunset() {
  dayNumber=$1
  distanceFromJune21st=$(echo "scale=4; ${dayNumber}-172.25" | bc | sed 's/-//g')
  sunsetOnJune21st="20:34"
  sunsetDelta=1.2046
  sunsetOffset=$(echo "scale=4; ${distanceFromJune21st}*${sunsetDelta}" | bc | awk '{print int($1+0.5)}')
  sunsetTime=$(date -j -f %H:%M -v-${sunsetOffset}M ${sunsetOnJune21st} +%s)
  echo $sunsetTime
}

ambience() {
  echo $(./lmutracker)
}

set_dark() {
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  defaults write -app Visual\ Studio\ Code NSRequiresAquaSystemAppearance -bool No
  sed -i "" 's#"workbench.colorTheme": "Xcode Default (Light)"#"workbench.colorTheme": "Xcode Default (Dark)"#g' ${HOME}/Library/Application\ Support/Code/User/settings.json
}

set_light() {
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
  defaults write -app Visual\ Studio\ Code NSRequiresAquaSystemAppearance -bool Yes
  sed -i "" 's#"workbench.colorTheme": "Xcode Default (Dark)"#"workbench.colorTheme": "Xcode Default (Light)"#g' ${HOME}/Library/Application\ Support/Code/User/settings.json
}

colorflip() {
  # Get sunrise, sunset and current time (in seconds)
  sunrise_today=$(sunrise $(date +%j))
  sunset_today=$(sunset $(date +%j))
  now=$(date +%s)

  # Get ambient light
  ambient_light=$(ambience)

  # Get appearance setting
  appearance=$(defaults read NSGlobalDomain AppleInterfaceStyle 2>/dev/null 1>/dev/null && echo "Dark" || echo "Light")

  # Always use the light theme in very bright conditions
  if [ "${appearance}" == "Light" ] && [ ${ambient_light} -gt 600000 ]; then
    :
  elif [ "${appearance}" == "Dark" ] && [ ${ambient_light} -gt 600000 ]; then
    set_light

  # Always use the dark theme in very dark conditions
  elif [ "${appearance}" == "Dark" ] && [ ${ambient_light} -lt 600000 ]; then
    :
  elif [ "${appearance}" == "Light" ] && [ ${ambient_light} -lt 600000 ]; then
    set_dark

  # Otherwise, flip themes at dawn and dusk
  elif [ "${appearance}" == "Light" ] && ([ ${now} -le ${sunrise_today} ] || [ ${now} -ge ${sunset_today} ]); then
    set_dark
  elif [ "${appearance}" == "Dark" ] && [ ${now} -gt ${sunrise_today} ] && [ ${now} -lt ${sunset_today} ]; then
    set_light
  fi
}
colorflip
unset set_dark
unset set_light
