# install-signal

Install **Signal Desktop on Raspberry Pi OS** using an unofficial ARM64 build.

Signal is a privacy-focused messaging app and a popular alternative to WhatsApp.
Signal Desktop is normally not available for ARM devices like the Raspberry Pi, but an unofficial ARM64 build exists.

This script installs that build automatically.





## Install (quick)

Run:

```bash
wget https://raw.githubusercontent.com/wobbo/install-signal/main/install-signal.sh
chmod +x install-signal.sh
./install-signal.sh
```





## Install (specific version)

If you want to install a specific Signal version, you can use a versioned script [install-signal_8.1.0.sh](https://wobbo.org/install/2026-03-10/install-signal_8.1.0.sh):

```bash
wget -O install-signal.sh 'https://wobbo.org/install/2026-03-10/install-signal_8.1.0.sh'
chmod +x install-signal.sh
./install-signal.sh
```

The wobbo.org server checks whether the corresponding Signal release exists before serving the script.





## Requirements

* Raspberry Pi OS **64-bit**
* Signal installed on your **phone**

Signal Desktop links to your phone using a QR code.

---



## Updates

The unofficial ARM build does **not update automatically**.

Check for new releases here:

[https://github.com/dennisameling/Signal-Desktop/releases](https://github.com/dennisameling/Signal-Desktop/releases)

---



## Credits

Unofficial Signal Desktop ARM64 build
[https://github.com/dennisameling/Signal-Desktop](https://github.com/dennisameling/Signal-Desktop)

Install script
[https://github.com/wobbo/install-signal](https://github.com/wobbo/install-signal)

---



## More information

Full explanation and discussion:

[https://forums.raspberrypi.com/viewtopic.php?p=2313410#p2313410](https://forums.raspberrypi.com/viewtopic.php?p=2313410#p2313410)

---



## License

MIT

---



