#!/usr/bin/env bash
set -e

# Install Signal Desktop (unofficial build) on Raspberry Pi OS GNOME (Wayland)
#
# Script: Ernst Lanser
# https://wobbo.org/install/2026-06-12/install-signal_8.14.0.sh
# Last updated: 11-06-2026 08:05
#
# Signal Desktop unofficial ARM build:
# Dennis Ameling
# https://github.com/dennisameling/Signal-Desktop
# https://github.com/dennisameling/Signal-Desktop/releases/download/v8.14.0/signal-desktop-unofficial_8.14.0_arm64.deb
#
# Install:
# wget -O install-signal.sh 'https://wobbo.org/install/2026-06-12/install-signal_8.14.0.sh'
# chmod +x install-signal.sh
# ./install-signal.sh

SIGNAL_VERSION='8.14.0'
SIGNAL_WMCLASS='signal.desktop.unofficial'
SIGNAL_ICON='signal-desktop'

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

# Also remove any Signal launchers from user local applications
sudo find /home -maxdepth 4 -type f -path '*/.local/share/applications/*.desktop' \
  \( -iname '*signal*.desktop' -o -iname '*unofficial*.desktop' \) \
  -exec rm -f {} \; 2>/dev/null || true

# Remove old custom Signal launchers from /usr/local before writing the new override
sudo mkdir -p /usr/local/share/applications
sudo rm -f \
  /usr/local/share/applications/signal.desktop \
  /usr/local/share/applications/signal-desktop.desktop \
  /usr/local/share/applications/signal-desktop-unofficial.desktop \
  /usr/local/share/applications/signal.desktop.unofficial.desktop \
  2>/dev/null || true

# Remove package-provided Signal launchers after install to avoid GNOME matching the wrong one
# The custom launcher below in /usr/local/share/applications is the single source of truth.
sudo rm -f \
  /usr/share/applications/signal.desktop \
  /usr/share/applications/signal-desktop.desktop \
  /usr/share/applications/signal-desktop-unofficial.desktop \
  /usr/share/applications/signal.desktop.unofficial.desktop \
  2>/dev/null || true

# 3) Create wrapper to force X11 and auto-detect correct binary
# Do NOT force --class here. Some Electron/Signal versions ignore it or behave inconsistently.
# Instead, this generated script chooses the correct StartupWMClass for this Signal version.
sudo tee /usr/local/bin/signal-desktop-x11 >/dev/null <<'EOF'
#!/bin/sh
unset WAYLAND_DISPLAY

if command -v signal-desktop >/dev/null 2>&1; then
  BIN="signal-desktop"
elif command -v signal-desktop-unofficial >/dev/null 2>&1; then
  BIN="signal-desktop-unofficial"
else
  echo "No Signal binary found (signal-desktop or signal-desktop-unofficial)." >&2
  exit 127
fi

exec "$BIN" --enable-features=UseOzonePlatform --ozone-platform=x11 "$@"
EOF
sudo chmod +x /usr/local/bin/signal-desktop-x11

# 4) System-wide launcher override (admin location, update-proof)
sudo tee /usr/local/share/applications/signal-desktop.desktop >/dev/null <<EOF
[Desktop Entry]
Type=Application
Name=Signal
Comment=Private messenger
Exec=signal-desktop-x11 %U
Icon=${SIGNAL_ICON}
Terminal=false
Categories=Network;InstantMessaging;Chat;
StartupNotify=false
StartupWMClass=${SIGNAL_WMCLASS}
EOF

# 5) Create autostart .desktop (single source)
cat > /tmp/signal-hidden.desktop <<EOF
[Desktop Entry]
Type=Application
Name=Signal (hidden)
Exec=signal-desktop-x11 --start-in-tray
Icon=${SIGNAL_ICON}
X-GNOME-Autostart-enabled=true
StartupNotify=false
StartupWMClass=${SIGNAL_WMCLASS}
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
  sudo chown "$u:$u" "$d/.config/autostart" "$d/.config/autostart/signal-hidden.desktop" 2>/dev/null || true
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
