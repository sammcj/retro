#!/system_ext/bin/bash

# add my fancontrol.sh script
adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
adb shell chmod 755 /data/adb/service.d/fancontrol.sh

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
