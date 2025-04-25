#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

targetColor := 0xFF55FF  ; RGB(255, 85, 255)
tolerance := 40
maxTurn := 50  ; Increased this for faster turning
tracking := false
lockedOn := false
automatic := false  ; Start in manual mode

; Exit script with Esc
esc::ExitApp

; Toggle tracking with K
k::
    if (!automatic) {
        ; Switch to automatic mode after 1 second
        automatic := true
        SetTimer, SwitchToAutomatic, -1000  ; Wait for 1 second
    } else {
        ; Switch back to manual mode immediately
        automatic := false
        SwitchShiftKey()  ; Send Left Shift to switch back to manual mode
    }
return

SwitchToAutomatic:
    ; When automatic mode is activated, simulate pressing Left Shift
    SwitchShiftKey()  ; Simulate pressing Left Shift to enable automatic mode
    tracking := true
    SetTimer, Track, % (tracking ? 10 : "Off")
return

SwitchShiftKey() {
    ; Send the Shift key (with slight delay) to simulate Left Shift
    Send, {Shift down}  ; Hold Shift down
    Sleep, 100  ; Keep Shift pressed for 100ms to ensure it registers
    Send, {Shift up}  ; Release Shift
    ; Optionally, you can also try Send, + (shorthand for Shift)
}

Track:
PixelSearch, Px, Py, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, targetColor, tolerance, Fast RGB
if (!ErrorLevel) {
    MouseGetPos, mx, my

    dx := Px - mx  ; horizontal distance (left/right)
    dy := Py - my  ; vertical distance (up/down)
    dist := Sqrt(dx*dx + dy*dy)

    smoothing := 0.7  ; Increased smoothing factor for faster movement

    ; Apply smoothing for both horizontal and vertical movement
    dx := dx * smoothing
    dy := dy * smoothing

    ; If the target is lost or missed, the missile should adjust direction
    if (dist > 100) {
        ; Target is too far, missile needs to realign
        if (dx > 0) {
            ; Turn right
            dx := dx * 0.5  ; Faster adjustment
        } else {
            ; Turn left
            dx := dx * -0.5  ; Faster adjustment
        }
        if (dy > 0) {
            ; Pull up
            dy := dy * 0.5  ; Faster upward correction
        } else {
            ; Push down
            dy := dy * -0.5  ; Faster downward correction
        }
    }

    ; Limit max turning speed (increase for faster turning)
    turn := Sqrt(dx*dx + dy*dy)
    if (turn > maxTurn) {
        dx := dx * (maxTurn / turn)
        dy := dy * (maxTurn / turn)
    }

    ; Move missile (no camera movement, just missile re-alignment)
    ; The mouse move here simulates the missile's flight path, adjusting direction
    MouseMove, % (mx + dx), % (my + dy), 0
    lockedOn := true
} else {
    lockedOn := false
}
return
