#!/system/bin/sh
# Android (GammaOS beta) boot script for RG405V fan control
# Author: Sam McLeod @sammcj
# Version: 1.0

# Install:
# adb root
# adb remount
# adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
# adb shell chmod 755 /data/adb/service.d/fancontrol.sh
# adb reboot

FAN_POWER=/sys/devices/platform/singleadc-joypad/fan_power
FAN_ENABLE=/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm_en
FAN_SPEED=/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1
CPU_TEMP=/sys/class/thermal/thermal_zone0/temp
SPEED_MULTIPLIER=1
SLEEP=5

# continue on error
set +e

echo "Starting fan control script"

# Check for any previous instances of this script and kill them
for pid in $(ps | grep fancontrol.sh | grep -v grep | awk '{print $1}'); do
  if [ "$pid" != "$$" ]; then
    kill -9 "$pid"
  fi
done

# Enable fan
echo 1 >$FAN_POWER
echo 1 >$FAN_ENABLE

# Cool down during boot
echo 150 >$FAN_SPEED
sleep 5

# Then set fan speed to 50% which tells the fan to automatically adjust speed (apparently)
echo 50 >$FAN_SPEED

# Now we run a background loop to check the temperature and adjust the fan speed, if it crashes it will be restarted
while true; do
  # Get CPU temperature
  temp=$(echo "$(cat ${CPU_TEMP}) / 1000" | bc)

  # Enable the power/pwm if it's not already enabled
  echo 1 >$FAN_POWER
  echo 1 >$FAN_ENABLE

  # Set the pwm speed for the fan based on the temperature (0 at below 50C, 90 at 70C, 140 at 75C, 250 at or above 85C)
  if [ "$temp" -lt 50 ]; then
    speed=0
  elif [ "$temp" -lt 60 ]; then
    speed=50
  elif [ "$temp" -lt 65 ]; then
    speed=90
  elif [ "$temp" -lt 70 ]; then
    speed=150
  elif [ "$temp" -lt 75 ]; then
    speed=200
  elif [ "$temp" -lt 120 ]; then
    speed=250
  else
    speed=50
  fi

  # Multiply the speed by the optional multiplier
  speed=$((speed * SPEED_MULTIPLIER))

  if $DEBUG; then
    echo "CPU temp: ${temp} C, fan speed: ${speed}"
  fi

  # Set the fan speed
  echo $speed >$FAN_SPEED

  # Wait 5 seconds
  sleep $SLEEP
done

# If the script exits, set the fan to speed 50
echo 50 >$FAN_SPEED
