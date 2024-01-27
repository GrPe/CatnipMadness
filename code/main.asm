INCLUDE "hardware.inc"
include "assets/tiles.asm"
include "utils/constants.asm"
include "utils/utils.asm"
include "utils/input.asm"
include "gameplay/gameplay.asm"
include "gameplay/player.asm"
include "gameplay/cat.asm"
include "gameplay/sprawner.asm"
include "libs/gb-sprobj.asm"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ; Shut down audio circuitry
    ld a, 0
    ld [rNR52], a

	call WaitVBlank

	call InitSprObjLib
    call ClearOam	
	call ResetShadowOAM

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld a, 0
	ldh [rSTAT], a
	di

	call InitGameState
	
	; Turn the LCD on
	ld a, LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ8 | LCDCF_ON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %00000000
	ld [rBGP], a

	ld a, %11100100
    ld [rOBP0], a


Main:
    ; Wait until it's *not* VBlank
    ld a, [rLY]
    cp 144
    jp nc, Main
WaitVBlank2:
    ld a, [rLY]
    cp 144
    jp c, WaitVBlank2

	;call DrawEnemies
	call UpdateKeys

	call ResetShadowOAM

	call UpdatePlayer
	call UpdateEnemy

	call ClearRemainingSprites

	call WaitVBlank	

	ld a, HIGH(wShadowOAM)
	call hOAMDMA

	call WaitVBlank

	jp Main