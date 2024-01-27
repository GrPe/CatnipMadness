INCLUDE "hardware.inc"
include "assets/tiles.asm"
include "utils/constants.asm"
include "utils/utils.asm"
include "utils/input.asm"
include "gameplay/gameplay.asm"
include "gameplay/player.asm"
include "gameplay/cat.asm"
include "gameplay/sprawner.asm"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ; Shut down audio circuitry
    ld a, 0
    ld [rNR52], a

	call WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	call InitGameState
	
	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON | LCDCF_OBJON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %00000000
	ld [rBGP], a

	ld a, %11100100
    ld [rOBP0], a


Main:
    ; Wait until it's *not* VBlank
    ld a, [rLY] ; just burn the rest of cpu time
    cp 144
    jp nc, Main

	call WaitVBlank
	call UpdateKeys

	call UpdatePlayer
	call UpdateEnemy

	jp Main