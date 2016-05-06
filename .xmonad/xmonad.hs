-- -*- mode: Haskell; coding: utf-8 -*-

import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders(smartBorders)
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig
import System.IO

import qualified XMonad.StackSet as W


-- use Win key as mod
myModMask = XMonad.mod4Mask
myTerminal = "urxvt"

-- borders
myBorderWidth        = 2
myNormalBorderColor  = "#030"
myFocusedBorderColor = "#0f0"

-- use default bindings with the following changes
myKeys = [ -- the "lock" key is permanently set to Win-l, so use that for locking
           ("M-l", spawn "xscreensaver-command -lock")
           -- rebind Shrink/Expand since M-l is taken
         , ("M-S-h", sendMessage Shrink)
         , ("M-S-l", sendMessage Expand)
           -- screenshots
         , ("M-S-p", spawn "scrot")
           -- use Mod-s to switch windows, like M-s in Emacs
         , ("M-s",   windows W.focusDown)
         , ("M-S-s", windows W.focusUp)
           -- customize dmenu usage
         , ("M-p", spawn "rofi -show run")
           -- sound controls (Fn-F1/F2/F3/F4)
         , ("<XF86AudioMute>",        spawn "pulseaudio-ctl mute")
         , ("<XF86AudioLowerVolume>", spawn "pulseaudio-ctl down 10")
         , ("<XF86AudioRaiseVolume>", spawn "pulseaudio-ctl up 10")
           -- change LCD brightness (Fn-F5/F6)
         , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10 -time 0")
         , ("<XF86MonBrightnessUp>",   spawn "xbacklight -inc 10 -time 0")
           -- XF86Display (Fn-F7)
           -- XF86Tools (Fn-F9)
           -- XF86Search (Fn-F10)
           -- XF86LaunchA (Fn-F11)
           -- XF86MyComputer (Fn-F12)
           -- calc key
         , ("<XF86Calculator>", spawn "gnome-calculator")
           -- web key
         , ("<XF86HomePage>",   spawn "chromium")
         , ("S-<XF86HomePage>", spawn "chromium --incognito")
           -- file key
         , ("<XF86MyComputer>", spawn (myTerminal ++ " -e mc"))
         ]

-- until https://github.com/xmonad/xmonad-contrib/issues/27 is resolved
myRawKeys = [ -- XF86AudioMicMute
              ((0, 0x1008ffb2), spawn "pulseaudio-ctl mute-input")
            ]

myLayoutHook = renamed [CutWordsLeft 2] $ smartSpacing 2 $ smartBorders $ avoidStruts layouts
  where
    layouts = tall ||| wide ||| Grid ||| Full
    tall    = Tall nmaster delta ratio
    wide    = renamed [Replace "Wide"] $ Mirror tall
    nmaster = 1
    ratio   = 1/2
    delta   = 5/100

-- xmobar configuration
myXmobarPP xmproc = xmobarPP
  { ppOutput          = hPutStrLn xmproc
  , ppTitle           = xmobarColor "white"  "" . shorten 100
  , ppCurrent         = xmobarColor "yellow" ""
  , ppVisible         = xmobarColor "cyan"   ""
  , ppHidden          = xmobarColor "grey80" ""
  , ppHiddenNoWindows = xmobarColor "grey30" ""
  , ppLayout          = xmobarColor "green" ""
  , ppSep = " · "
  }

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ ewmh defaultConfig
    { modMask = myModMask
      -- leave room for xmobar
    , manageHook = manageDocks <+> manageHook defaultConfig
      -- let windows go fullscreen; also needed by rofi for window switching
    , handleEventHook = handleEventHook defaultConfig <+> fullscreenEventHook
      -- send status info to xmobar for display
    , logHook = dynamicLogWithPP $ myXmobarPP xmproc
    , layoutHook = myLayoutHook
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , terminal = myTerminal
    } `additionalKeysP` myKeys `additionalKeys` myRawKeys
