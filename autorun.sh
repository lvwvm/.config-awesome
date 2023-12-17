#!/usr/bin/env bash

## run (only once) processes which spawn with the same name
function run() {
  if (command -v "$1" && ! pgrep "$1"); then
    "$@" &
  fi
}

## run (only once) processes which spawn with different name
# if (command -v gnome-keyring-daemon && ! pgrep gnome-keyring-d); then
#   gnome-keyring-daemon --daemonize --login &
# fi

# Deprecated in favor of pipewire-pulse.
# if (command -v start-pulseaudio-x11 && ! pgrep pulseaudio); then
#   start-pulseaudio-x11 &
# fi

if (command -v /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 && ! pgrep polkit-mate-aut); then
  /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
fi

# System-config-printer-applet is not installed in minimal edition
if (command -v system-config-printer-applet && ! pgrep applet.py); then
  system-config-printer-applet &
fi

# screen locker
run light-locker --lock-after-screensaver=$((60 * 45)) --lock-on-suspend --lock-on-lid --no-idle-hint

# screen savers
run xscreensaver

# define super_L
run xcape -e 'Super_L=Super_L|Control_L|Escape'

# manjaro system (kernel updates)
run msm_notifier

# package manager
run pamac-tray

# pulse audio
run pasystray

# blueman-applet and msm_notifier are not installed in minimal edition
run blueman-applet

# power manager
run powerkit

# compositor
run picom
