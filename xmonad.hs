import System.Exit
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.WithAll
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing
import XMonad.Layout.WindowArranger
import XMonad.Util.SpawnOnce
import qualified Data.Map as M
import qualified XMonad.Layout.MultiToggle as MT
import qualified XMonad.StackSet as W
import qualified XMonad.Util.EZConfig as EZ

_terminal :: String
_terminal = "alacritty"

_browser :: String
_browser = "google-chrome-stable"

_workspaces :: [String]
_workspaces = ["1","2","3","4","5","6","7","8","9","0"]

_layout = avoidStruts
  $ windowArrange
  $ spacingWithEdge 4
  $ MT.mkToggle1 NOBORDERS
  $ _layoutHook

_layoutHook = tiled ||| Mirror tiled
  where
    tiled = reflectHoriz $ ResizableTall 1 (3/100) (1/2) []

_startupHook :: X ()
_startupHook = do
  spawnOnce "nitrogen --restore"
  spawnOnce "picom"
  spawnOnce "emacs --daemon"
  spawnOnce "volnoti"

_toggleSpacing :: X ()
_toggleSpacing = toggleScreenSpacingEnabled
              >> toggleWindowSpacingEnabled

_keys conf = EZ.mkKeymap conf $
  [ ("M-S-q"      , io exitSuccess)
  , ("M-S-<Esc>"  , spawn "shutdown now")
  , ("M-S-r"      , spawn "xmonad --recompile; xmonad --restart")
  , ("M-r"        , spawn "xmonad --restart")
  , ("M-w"        , kill)
  , ("M-S-w"      , killAll)

  -- Program
  , ("M-<Return>" , spawn _terminal)
  , ("M-p"        , spawn "dmenu_run")
  , ("M-n"        , spawn _browser)
  , ("M-e"        , spawn "emacsclient -c -a emacs")

  -- Focus
  , ("M-j"        , windows W.focusDown)
  , ("M-k"        , windows W.focusUp)
  , ("M-S-m"      , windows W.focusMaster)

  , ("M-<Tab>"    , windows W.focusDown)
  , ("M-S-<Tab>"  , windows W.focusUp)
  , ("M-S-a"      , windows W.focusMaster)

  , ("M-<Down>"   , windows W.focusDown)
  , ("M-<Up>"     , windows W.focusUp)

  -- Swap
  , ("M-S-j"      , windows W.swapDown)
  , ("M-S-k"      , windows W.swapUp)
  , ("M-m"        , windows W.swapMaster)

  , ("M-q"        , windows W.swapMaster)
  , ("M-a"        , rotAllDown)

  , ("M-S-<Down>" , windows W.swapDown)
  , ("M-S-<Up>"   , windows W.swapUp)

  -- Workspace
  , ("M-s"        , toggleWS)
  , ("M-<Left>"   , prevWS)
  , ("M-<Right>"  , nextWS)
  , ("M-S-<Left>" , shiftToPrev >> prevWS)
  , ("M-S-<Right>", shiftToNext >> nextWS)

  -- Resize
  , ("M-h"        , sendMessage Expand)
  , ("M-l"        , sendMessage Shrink)
  , ("M-C-h"      , sendMessage Expand)
  , ("M-C-l"      , sendMessage Shrink)
  , ("M-C-j"      , sendMessage MirrorShrink)
  , ("M-C-k"      , sendMessage MirrorExpand)
  , ("M-S-h"      , incScreenWindowSpacing 1)
  , ("M-S-l"      , decScreenWindowSpacing 1)

  -- Layout
  , ("M-<Space>"  , sendMessage NextLayout)
  , ("M-S-<Space>", setLayout (XMonad.layoutHook conf)
                 >> sinkAll)
  , ("M-."        , sendMessage (IncMasterN 1))
  , ("M-,"        , sendMessage (IncMasterN (-1)))
  , ("M-t"        , sinkAll)
  , ("M-f"        , _toggleSpacing)
  , ("M-S-f"      , _toggleSpacing
                 >> sendMessage ToggleStruts
                 >> sendMessage (MT.Toggle NOBORDERS))
  , ("M-g"        , sendMessage ToggleStruts)
  , ("M-S-g"      , killAllStatusBars) -- Refresh to restore
  , ("M-b"        , sendMessage (MT.Toggle NOBORDERS))

  -- Volume
  , ("<XF86AudioMute>"        , spawn "pulsemixer --toggle-mute; if pulsemixer --get-mute | grep -Fq 1; then volnoti-show -m; else volnoti-show $(pulsemixer --get-volume | cut -d' ' -f1); fi")
  , ("<XF86AudioLowerVolume>" , spawn "pulsemixer --change-volume -5; volnoti-show $(pulsemixer --get-volume | cut -d' ' -f1)")
  , ("<XF86AudioRaiseVolume>" , spawn "pulsemixer --change-volume +5; pulsemixer --max-volume 100; volnoti-show $(pulsemixer --get-volume | cut -d' ' -f1)")

  -- Brightness
  , ("<XF86MonBrightnessUp>"  , spawn "xbacklight -inc 5")
  , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 5")
  ]
  ++
  -- Workspace Default
  [ (m ++ i, windows $ f w)
  | (m, f) <- [("M-", W.greedyView), ("M-S-", W.shift)]
  , (i, w) <- zip ["1","2","3","4","5","6","7","8","9","0"] _workspaces
  ]

_mouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList
  [ ((modm              , button1), \w -> focus w >>   mouseMoveWindow w >> windows W.shiftMaster)
  , ((modm .|. shiftMask, button1), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
  ]

_colorCurnt :: String
_colorCurnt = "#ffffff"

_colorExist :: String
_colorExist = "#555555"

_colorNoWin :: String
_colorNoWin = "#000000"

_colorTitle :: String
_colorTitle = "#ffffff"

_colorUrgnt :: String
_colorUrgnt = "#ff8080"

_colorVisib :: String
_colorVisib = "#8080ff"

_ppWS :: PP
_ppWS = def
  { ppOrder           = \(ws:_:_:_) -> [ws]
  , ppCurrent         = xmobarColor _colorCurnt ""
  , ppHidden          = xmobarColor _colorExist ""
  , ppHiddenNoWindows = xmobarColor _colorNoWin ""
  , ppUrgent          = xmobarColor _colorUrgnt ""
  , ppVisible         = xmobarColor _colorVisib ""
  }

_ppTitle :: PP
_ppTitle = def
  { ppOrder           = \(_:_:t:_) -> [t]
  , ppTitle           = xmobarColor _colorTitle "" . xmobarFont 1
  }

_xmobarTop :: StatusBarConfig
_xmobarTop = statusBarGeneric "xmobar -x 0 ~/.config/xmobar/xmobarrc"
  $ (xmonadPropLog' "_XMONAD_LOG_TITLE" =<< dynamicLogString =<< pure _ppTitle)
 >> (xmonadPropLog' "_XMONAD_LOG_WS" =<< dynamicLogString =<< pure _ppWS)

_barSpawner 0 = pure _xmobarTop
_barSpawner _ = mempty

main :: IO ()
main = do
  xmonad
    $ docks
    $ ewmh
    $ dynamicSBs _barSpawner
    $ def
      { borderWidth        = 2
      , focusFollowsMouse  = True
      , clickJustFocuses   = False
      , normalBorderColor  = "#000000"
      , focusedBorderColor = "#ffffff"
      , modMask            = mod4Mask
      , layoutHook         = _layout
      , mouseBindings      = _mouseBindings
      , startupHook        = _startupHook
      , terminal           = _terminal
      , workspaces         = _workspaces
      , keys               = _keys
      }
