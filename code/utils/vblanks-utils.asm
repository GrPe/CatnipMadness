section "VBlank Utils Variables", wram0
wVBlankCount: db

section "VBlank Utils", rom0

;Wait for first full VBlank!
WaitForOneVBlank:
    ld a, 1
    ld [wVBlankCount], a

WaitForVBlank:

.waitForOneVBlank_Loop: ; wait for start of the drawing 
    ld a, [rLY] ;Copy the vertical line to a
    cp 144
    jp c, .waitForOneVBlank_Loop

    ld a, [wVBlankCount]
    sub a, 1
    ld [wVBlankCount], a
    ret z ; if a == 0 ret

.waitForOneVBlank_Loop2:
    ld a, [rLY]
    cp 144
    jp nc, .waitForOneVBlank_Loop2

    jp .waitForOneVBlank_Loop
