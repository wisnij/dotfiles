#!/bin/sh

xrdb .Xresources
xhost +
urxvt -ls

# keep X server from exiting
exec sleep infinity
