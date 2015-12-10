#!/bin/sh

xrdb .Xresources
xhost +
urxvt -ls

if [[ -f .xinitrc-local ]]; then
    source .xinitrc-local
fi
