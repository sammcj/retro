#!/system/bin/sh
# Android (GammaOS beta) boot script for RG405V fan control
# Author: Sam McLeod @sammcj
# Version: 1.1

# Install:
# - adb root
# - adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
# - adb shell chmod 755 /data/adb/service.d/fancontrol.sh
# - adb reboot

FAN_POWER=/sys/devices/platform/singleadc-joypad/fan_power
FAN_ENABLE=/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm_en
FAN_SPEED=/sys/devices/platform/pwm-fan/hwmon/hwmon0/pwm1
CPU_TEMP=/sys/class/thermal/thermal_zone0/temp
SPEED_MULTIPLIER=1
EXIT_SPEED=0
SLEEP=5
DEBUG=${DEBUG:-false}

# continue on error
set +e

if $DEBUG; then
  echo "Starting fan control script"
fi

# Check for any previous instances of this script and kill them
for pid in $(ps | grep fancontrol.sh | grep -v grep | awk '{print $1}'); do
  if [ "$pid" != "$$" ]; then
    echo "Killing previous instance of fancontrol.sh with PID ${pid}"
    kill -9 "$pid"
  fi
done

# Now we run a background loop to check the temperature and adjust the fan speed, if it crashes it will be restarted
while true; do
  # If Android is sleeping, set the fan speed to 0 and wait for it to wake up
  STATE=$(dumpsys power | grep mWakefulness= | awk '{print $1}')
  if [ "$STATE" != "mWakefulness=Awake" ] && [ "$STATE" != "mWakefulness=Dozing" ]; then
    echo 0 >$FAN_SPEED
    sleep 30
    continue
  fi

  # Get CPU temperature
  temp=$(echo "$(cat ${CPU_TEMP}) / 1000" | bc)

  # Set the pwm speed for the fan based on the temperature (0 at below 50C, 90 at 70C, 140 at 75C, 250 at or above 85C)
  if [ "$temp" -lt 50 ]; then
    enable=0
    speed=0
  elif [ "$temp" -lt 60 ]; then
    enable=1
    speed=50
  elif [ "$temp" -lt 65 ]; then
    enable=1
    speed=90
  elif [ "$temp" -lt 70 ]; then
    enable=1
    speed=150
  elif [ "$temp" -lt 75 ]; then
    enable=1
    speed=200
  elif [ "$temp" -ge 80 ]; then
    enable=1
    speed=250
  else
    enable=0
    speed=0
  fi

  # Multiply the speed by the optional multiplier
  speed=$((speed * SPEED_MULTIPLIER))

  if $DEBUG; then
    echo "CPU temp: ${temp} C, Fan PWM: ${speed}, Fan enabled: ${enable}"
  fi

  # Set the fan speed
  echo $enable >$FAN_POWER
  echo $enable >$FAN_ENABLE
  echo $speed >$FAN_SPEED

  # Wait n seconds
  sleep $SLEEP

done

# If the script exits, set the fan to speed
if [ ${EXIT_SPEED} -gt 0 ]; then
  echo 1 >$FAN_POWER
  echo 1 >$FAN_ENABLE
else
  echo 0 >$FAN_POWER
  echo 0 >$FAN_ENABLE
fi
echo $EXIT_SPEED >$FAN_SPEED
