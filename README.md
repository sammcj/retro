# Sam's Retro Devices Repository

## Anbernic RG405V

### Scripts

[RG405V/gammaOS/fancontrol.sh](RG405V/gammaOS/fancontrol.sh)

A little script to control the fan speed on the RG405V and stops it from randomly spinning up while in standby.

It's just a basic shell script that launches (non-blocking) on boot via [Magisk's `service.d` directory](https://github.com/topjohnwu/Magisk/blob/master/docs/guides.md#boot-scripts). It checks the CPU temperature every 5 seconds and sets the fan speed accordingly. It's a bit of a hack, but it works.

Uninstall any other fan-control software such as GOSTools, then install with:

```shell
adb root
adb push fancontrol.sh /data/adb/service.d/fancontrol.sh
adb shell chmod 755 /data/adb/service.d/fancontrol.sh
adb reboot
```

---

[RG405V/gammaOS/setup.sh](RG405V/gammaOS/setup.sh)

A script to install the fancontrol.sh script and set some sensible defaults for the RG405V with GammaOS such as setting the wifi sleep policy, disabling stats etc...

### 3D Model

My 3D model is a bit of a work in progress, I want to make a case and possibly stand for it.

It's very much alpha quality at the moment but the model and Fusion 360 source files are here: [RG405V/3d](RG405V/3d)

![](RG405V/3d/rg405v-body%20v11.png)
