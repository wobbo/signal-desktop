# install-signal.sh

Install script for Signal Desktop on ARM64 GNOME systems. This script installs the *unofficial* Signal Desktop ARM64 build maintained by Dennis Ameling: [https://github.com/dennisameling/signal-desktop](https://github.com/dennisameling/Signal-Desktop/releases)

This repository only provides the installation script. Tested on Raspberry Pi OS GNOME, but it should also work on other ARM64 GNOME Debian-based systems. Updates: https://github.com/wobbo/signal-desktop/releases

```bash
wget -O install-signal.sh 'https://wobbo.org/install/2026-03-10/install-signal_8.8.0.sh'
chmod +x install-signal.sh
./install-signal.sh
```

---

## Example

The screenshot below shows the GNOME launcher icon issue with the unofficial Signal Desktop ARM64 build. On the right, Signal appears as a separate launcher entry with a generic settings icon instead of the proper Signal icon. This is a GNOME integration issue with the unofficial build. This installation script fixes that problem so Signal appears with the correct application icon in the GNOME dock. ![Signal Desktop ARM64](https://wobbo.org/screenshots/20260307_Signal-8.1.0.webp)

---

## Install (specific version)

If you want to install a specific Signal version, use the corresponding script
*install-signal_\<version\>.sh*, for example:
[install-signal_8.8.0.sh](https://wobbo.org/install/2026-03-10/install-signal_8.8.0.sh)

```bash
wget -O install-signal.sh 'https://wobbo.org/install/2026-03-10/install-signal_8.8.0.sh'
chmod +x install-signal.sh
./install-signal.sh
```

The wobbo.org server checks whether the corresponding Signal release exists before serving the script.

---

## Requirements

* ARM64 Debian-based Linux
* GNOME desktop environment
* Signal installed on your phone

---

## Credits

* *Unofficial* Signal Desktop ARM64 build
  [https://github.com/dennisameling/Signal-Desktop](https://github.com/dennisameling/Signal-Desktop/releases)
* Install script
  https://github.com/wobbo/signal-desktop

---

## More information

Full explanation and discussion:

* [https://forums.raspberrypi.com/viewtopic.php?p=2313410](https://forums.raspberrypi.com/viewtopic.php?p=2313410#p2313410)
* https://wobbo.org/install/2026-03-10/install-signal_8.6.0.sh

---

## License

MIT
