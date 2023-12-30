#!/system_ext/bin/bash

# add my fancontrol.sh script
adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
adb shell chmod 755 /data/adb/service.d/fancontrol.sh

# Backup settings
adb shell settings list global >"settings_global_$(date +%Y%m%d_%H%M%S).txt"
adb shell settings list secure >"settings_secure_$(date +%Y%m%d_%H%M%S).txt"
adb shell settings list system >"settings_system_$(date +%Y%m%d_%H%M%S).txt"

# Only keep wifi on when sleeping when plugged in
adb shell settings put global wifi_sleep_policy 1

# Disable wifi wake up
adb shell settings put global wifi_wakeup_enabled 0

# Disable mobile data always on
adb shell settings put global mobile_data_always_on 0

# Disable mobile data
adb shell settings put global mobile_data 0

# Disable location
adb shell settings put secure location_mode 0

# Disable stats collection
adb shell settings put secure stats_collection 0
adb shell settings put secure stats_collection 0 --lineage

# Disable netstats
adb shell settings put global netstats_enabled 0

# Disable animations
adb shell settings put global window_animation_scale 0.0
