# install-signal

Install script for Signal Desktop on ARM64 GNOME systems.

This script installs the *unofficial* Signal Desktop ARM64 build maintained by
Dennis Ameling:
https://github.com/dennisameling/Signal-Desktop

This repository only provides the installation script.

Tested on Raspberry Pi OS GNOME, but it should also work on other ARM64 GNOME Debian-based systems.

---

## Install (quick)

Run:

```bash
wget https://raw.githubusercontent.com/wobbo/install-signal/main/install-signal.sh
chmod +x install-signal.sh
./install-signal.sh
```

---

## Example

The screenshot below shows the GNOME launcher icon issue with the unofficial Signal Desktop ARM64 build.

On the right, Signal appears as a separate launcher entry with a generic settings icon instead of the proper Signal icon. This is a GNOME integration issue with the unofficial build.

This installation script fixes that problem so Signal appears with the correct application icon in the GNOME dock.

![Signal Desktop ARM64](https://wobbo.org/screenshots/20260307_Signal-8.1.0.webp)

---

## Install (specific version)

If you want to install a specific Signal version, use the corresponding script
*install-signal_<version>.sh*, for example:

[install-signal_8.2.0.sh](https://wobbo.org/install/2026-03-10/install-signal_8.2.0.sh)

```bash
wget -O install-signal.sh 'https://wobbo.org/install/2026-03-10/install-signal_8.2.0.sh'
chmod +x install-signal.sh
./install-signal.sh
```

The wobbo.org server checks whether the corresponding Signal release exists before serving the script.

---

## Requirements

* ARM64 Debian-based Linux
* GNOME desktop environment
* Signal installed on your phone

Signal Desktop links to your phone using a QR code.

---

## Updates

The *unofficial* ARM build does **not update automatically**.

Check for new releases here:

https://github.com/dennisameling/Signal-Desktop/releases

---

## Credits

* *Unofficial* Signal Desktop ARM64 build
  https://github.com/dennisameling/Signal-Desktop

* Install script
  https://github.com/wobbo/install-signal

---

## More information

Full explanation and discussion:

* https://forums.raspberrypi.com/viewtopic.php?p=2313410#p2313410
* https://wobbo.org/install/2026-03-10/install-signal_8.2.0.sh

---

## License

MIT
