# Debian desktop troubleshooting

## TODO

- can't sleep/suspend
  - "suspend" still responds to keyboard/mouse input
  - "hibernate"/"hybrid sleep" end immediately, and mouse doesn't work afterwards
- screen stays blank after auto-off
  - current workaround: switch to virtual terminal and back with Ctrl-Alt-F1/F7
- no HD Amazon Prime video
  - tried <https://github.com/nxjosephofficial/primevideo-linux> initially, but
    Chrome 104 doesn't work anymore

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
- IBus popup-menu appears in the upper left corner of the screen, instead of by
  the taskbar icon
  - acceptable workaround: `(sleep 1; ibus restart) &` in `xsessionrc`
