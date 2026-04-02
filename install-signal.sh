#!/usr/bin/env bash
set -e

# Install Signal Desktop (unofficial build) on Raspberry Pi OS GNOME (Wayland)
#
# Script: Ernst Lanser
# https://wobbo.org/install/2026-03-10/install-signal_8.5.0.sh
#
# Signal Desktop unofficial ARM build:
# Dennis Ameling
# https://github.com/dennisameling/Signal-Desktop
# https://github.com/dennisameling/Signal-Desktop/releases/download/v8.5.0/signal-desktop-unofficial_8.5.0_arm64.deb
#
# Install:
# wget -O install-signal.sh 'https://wobbo.org/install/2026-03-10/install-signal_8.5.0.sh'
# chmod +x install-signal.sh
# ./install-signal.sh

SIGNAL_VERSION='8.5.0'
DEB="/tmp/signal-desktop-unofficial_${SIGNAL_VERSION}_arm64.deb"
URL="https://github.com/dennisameling/Signal-Desktop/releases/download/v${SIGNAL_VERSION}/signal-desktop-unofficial_${SIGNAL_VERSION}_arm64.deb"

# 0) Stop all running Signal processes
pkill -f 'signal-desktop(-unofficial)?' 2>/dev/null || true

# 1) Download and install package
wget -O "$DEB" "$URL"
sudo apt install -y "$DEB"

# 2) HARD CLEANUP – remove old user-level autostart entries for all existing users
sudo find /home -maxdepth 3 -type f -path '*/.config/autostart/*.desktop' \
  \( -iname '*signal*.desktop' -o -iname '*Signal*Autostart*.desktop' -o -iname '*unofficial*.desktop' \) \
  -exec rm -f {} \; 2>/dev/null || true

# Also remove any Signal launchers from user local applications (optional but keeps it clean)
sudo find /home -maxdepth 4 -type f -path '*/.local/share/applications/*.desktop' \
  -iname '*signal*.desktop' -exec rm -f {} \; 2>/dev/null || true

# 3) Create wrapper to force X11 and auto-detect correct binary
sudo tee /usr/local/bin/signal-desktop-x11 >/dev/null <<'EOF'
#!/bin/sh
unset WAYLAND_DISPLAY

if command -v signal-desktop >/dev/null 2>&1; then
  BIN="signal-desktop"
elif command -v signal-desktop-unofficial >/dev/null 2>&1; then
  BIN="signal-desktop-unofficial"
else
  echo "No Signal binary found." >&2
  exit 127
fi

exec "$BIN" --enable-features=UseOzonePlatform --ozone-platform=x11 "$@"
EOF
sudo chmod +x /usr/local/bin/signal-desktop-x11

# 4) System-wide launcher override (admin location, update-proof)
sudo mkdir -p /usr/local/share/applications
sudo tee /usr/local/share/applications/signal-desktop.desktop >/dev/null <<'EOF'
[Desktop Entry]
Type=Application
Name=Signal
Comment=Private messenger
Exec=signal-desktop-x11 %U
Icon=signal-desktop
Terminal=false
Categories=Network;InstantMessaging;Chat;
StartupNotify=false
StartupWMClass=signal unofficial
EOF

# 5) Create autostart .desktop (single source)
cat > /tmp/signal-hidden.desktop <<'EOF'
[Desktop Entry]
Type=Application
Name=Signal (hidden)
Exec=signal-desktop-x11 --start-in-tray
Icon=signal-desktop${SIGNAL_VERSION}
X-GNOME-Autostart-enabled=true
StartupNotify=false
StartupWMClass=signal unofficial
EOF

# 6) Install autostart for new users (skel)
sudo mkdir -p /etc/skel/.config/autostart
sudo install -m 644 /tmp/signal-hidden.desktop /etc/skel/.config/autostart/signal-hidden.desktop

# 7) Install autostart for all existing users
for d in /home/*; do
  [ -d "$d" ] || continue
  u="$(basename "$d")"

  case "$u" in
    root|nobody|systemd-*|_*) continue ;;
  esac

  sudo install -d -m 700 "$d/.config/autostart"
  sudo install -m 644 /tmp/signal-hidden.desktop "$d/.config/autostart/signal-hidden.desktop"
  sudo chown "$u:$u" "$d/.config/autostart" "$d/.config/autostart/signal-desktop.desktop" 2>/dev/null || true
done

# 8) Refresh desktop databases (optional but tidy)
sudo update-desktop-database /usr/local/share/applications 2>/dev/null || true
sudo update-desktop-database /usr/share/applications 2>/dev/null || true

# 9) Cleanup temp files and apt cache
rm -f /tmp/signal-hidden.desktop
rm -f "$DEB"
sudo apt clean

# 10) Remove this script itself (best-effort)
SELF="$(readlink -f -- "${BASH_SOURCE[0]}" 2>/dev/null || printf '%s\n' "${BASH_SOURCE[0]}")"
rm -f -- "$SELF" 2>/dev/null || true
