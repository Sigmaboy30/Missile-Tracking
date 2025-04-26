#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

targetColor := 0xFF55FF  ; Bright pink color
tolerance := 40
tracking := false
lockedOn := false

; Exit script with Esc
esc::ExitApp

; Toggle tracking with K
k::
    tracking := !tracking
    SetTimer, Track, % (tracking ? 5 : "Off")
    if (!tracking) {
        lockedOn := false
    }
return

Track:
PixelSearch, Px, Py, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, targetColor, tolerance, Fast RGB
if (!ErrorLevel) {
    MouseGetPos, mx, my

    dx := Px - mx
    dy := Py - my
    dist := Sqrt(dx*dx + dy*dy)

    ; Move the mouse towards the target
    MouseMove, % (mx + dx), % (my + dy), 0

    ; Lock on when aligned
    if (Abs(dx) < 3) {
        Send, {LShift down}
        SetTimer, ReleaseShift, -50
    }

    lockedOn := true
} else {
    lockedOn := false
}
return

ReleaseShift:
Send, {LShift up}
return
