# Sam's Retro Devices Repository

## Anbernic RG405V

[android/gammaos/fancontrol.sh](android/gammaos/fancontrol.sh)

A little script to control the fan speed on the RG405V and stops it from randomly spinning up while in standby.

It's just a basic shell script that launches (non-blocking) on boot via [Magisk's `service.d` directory](https://github.com/topjohnwu/Magisk/blob/master/docs/guides.md#boot-scripts). It checks the CPU temperature every 5 seconds and sets the fan speed accordingly. It's a bit of a hack, but it works.

Uninstall any other fan-control software such as GOSTools, then install with:

```shell
adb root
adb remount
adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
adb shell chmod 755 /data/adb/service.d/fancontrol.sh
adb reboot
```

---
