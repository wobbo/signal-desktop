# install-signal

Install **Signal Desktop on Raspberry Pi OS** using the unofficial ARM64 build.

Signal is a privacy-focused messaging app and a popular alternative to WhatsApp.
Signal Desktop is normally not available for ARM devices like the Raspberry Pi, but an unofficial ARM64 build exists.

This script installs that build automatically.

## Credits

Unofficial Signal Desktop ARM64 build
https://github.com/dennisameling/Signal-Desktop

Install script
https://github.com/wobbo/install-signal

## Install

Run:

```
wget https://raw.githubusercontent.com/wobbo/install-signal/main/install-signal.sh
chmod +x install-signal.sh
./install-signal.sh
```

## Requirements

* Raspberry Pi OS **64-bit**
* Signal installed on your **phone**

Signal Desktop will link to your phone using a QR code.

## Updates

The unofficial build does not update automatically.
Check for new releases here:

https://github.com/dennisameling/Signal-Desktop/releases

## More information

Full explanation and instructions:

https://forums.raspberrypi.com/viewtopic.php?p=2313410#p2313410

## License

MIT
