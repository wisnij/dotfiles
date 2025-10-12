# Debian desktop troubleshooting

## TODO

- no HD Amazon Prime video
  - tried <https://github.com/nxjosephofficial/primevideo-linux> initially, but
    Chrome 104 doesn't work anymore

## Acceptable workaround

- IBus popup-menu appears in the upper left corner of the screen, instead of by
  the taskbar icon
  - acceptable workaround: `(sleep 1; ibus restart) &` in `xsessionrc`
- VLC displays no video picture in always-on-top mode
  - workaround: use WM always-on-top feature
- no X11 bell after starting to use pipewire(?)
  - installed `libcanberra-pulse`
  - need to run `systemctl --user restart pipewire` at session start
  - local sound themes in `~/.local/share/sounds` don't seem to work, updated
    `/usr/share/sounds/freedesktop/stereo/bell.oga` with my preferred sound
- screen stays blank after auto-off
  - current workaround: switch to virtual terminal and back with Ctrl-Alt-F1/F7
  - [2024-12-18] fixed? this hasn't recurred in a while, but not sure if it was
    due to any specific change
- tty console looks worse after installing Nvidia drivers
  - setting `GRUB_GFXMODE=1280x1024` in `/etc/default/grub` helps slightly
- [2025-09-05] krunner weird glitching in Xfce; first invocation does nothing,
  second switches me to virtual desktop 4, third pops up normally (but only when
  on vd4)
  - [2025-10-06] switched to KDE Plasma, it works normally there
- [2025-09-05] no Emacs bell after trixie upgrade
  - other sound seems to work normally
  - [2025-10-06] switched to KDE Plasma, it works normally there
- [2025-10-12] kwin often hangs during shutdown and has to wait 90s to be killed
  - [2025-10-12] set `TimeoutStopSec=10s` in
    `.config/systemd/user/plasma-kwin_x11.service.d/shorter_TimeoutStopSec.conf`

## Fixed issues

- 4k monitor scaling
  - env vars in `.xsessionrc`
  - custom DPI setting = 192 in Xfce settings
  - set `xft-dpi=192` in `/etc/lightdm/lightdm-gtk-greeter.conf`
- users not shown in lightdm greeter
  - set `greeter-hide-users=false` in `/etc/lightdm/lightdm.conf`
- pulseaudio config not reliably taking effect at login
  - related to systemd variables maybe? see <https://bugs.freedesktop.org/show_bug.cgi?id=93109>
    - `dbus-update-activation-environment` didn't help though. i dunno lol
  - added `display=:0.0` to `load-module module-x11-bell`
- `xkbcomp` settings not taking effect at login
  - set "Use system keyboard layout" in ibus config
- Japanese input method (via Mozc) doesn't work in Emacs
  - `apt install emacs-mozc`
- no boot entry for Windows
  - set `GRUB_DISABLE_OS_PROBER=false` in `/etc/default/grub`
  - run `sudo update-grub`
- audio not switching to wireless USB headphones automatically when turned on
  - added `load-module module-switch-on-connect` to `~/.config/pulse/default.pa`
- video tearing during VLC playback
  - installed `nvidia-detect` and then `nvidia-driver`
- "Recent" in Thunar's tree view
  - disable with:

        > ~/.local/share/recently-used.xbel
        sudo chattr +i ~/.local/share/recently-used.xbel
- can't sleep/suspend
  - "suspend" still responds to keyboard/mouse input
  - "hibernate"/"hybrid sleep" end immediately, and mouse doesn't work afterwards
  - [2024-01-18] hibernate appears to be working after increasing swap partition
    to size of physical memory
    - however still wakes upon keyboard input
      - fixed(?): add this to `/etc/tmpfiles.d/disable-usb-wake.conf` (see <https://unix.stackexchange.com/a/662778>)

            #Type  Path               Mode  UID  GID  Age  Argument
            w      /proc/acpi/wakeup  -     -    -    -    XHC

    - suspend/hybrid sleep still don't work at all - afterwards screen remains
      blank, no response to keyboard input
  - [2024-12-18] this works fine now but I forgot to record how I got it working :(
- [2025-09-07] no audio at all after trixie upgrade
  - analog audio does not appear at all in mixer
  - installed pipewire-alsa and pipewire-pulse (replaced pulseaudio)
  - [2025-10-06] switched to KDE Plasma, it works normally there
- [2025-10-06] different bell for Emacs and Konsole
  - sound setting locations in Plasma:
    - System Settings > Accessibility > System Bell > Custom sound – for basic
      system bell from e.g. xterm, Emacs
    - System Settings > Notifications > System Notifications > Beep – for most
      other GUI apps
    - Konsole > Settings > Configure Notifications > Bell in (Non-)Focused
      Session – for Konsole
- [2025-10-06] mouse cursor is tiny in Plasma
  - changing it in System Settings > Mouse doesn't do anything
  - presumably an X11 issue somewhere?
  - [2025-10-12] fix: setting `Xcursor.size` resource in `.config/X11/Xresources-linux`
