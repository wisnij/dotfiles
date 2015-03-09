#!/bin/sh

xrdb .Xresources
xhost +
xterm -ls

# keep X server from exiting
exec sleep infinity
