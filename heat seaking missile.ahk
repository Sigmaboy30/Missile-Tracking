#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

CoordMode, Pixel, Screen  ; Ensure we search using screen coordinates
CoordMode, Mouse, Screen  ; Ensure mouse movement is in screen coordinates

targetColor := 0xC52E30 ; Replace with the actual color of the engine
tolerance := 10         ; Adjust if needed (higher = detects similar colors)

esc::exitapp
k::

Loop {
    PixelSearch, Px, Py, 513, 25, 800, 469 A_ScreenWidth, A_ScreenHeight, targetColor, tolerance, Fast
    if !ErrorLevel {
        MouseMove, %Px%, %Py%, 5  ; Move mouse smoothly to the detected color
    }
    Sleep, 10  ; Adjust speed of tracking (lower = faster)
}
