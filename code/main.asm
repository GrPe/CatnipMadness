INCLUDE "hardware.inc"

include "utils/constants.asm"
include "utils/utils.asm"
include "utils/input.asm"
include "utils/vblanks-utils.asm"
include "utils/oam-utils.asm"

include "gameplay/init.asm"

include "gameplay/player/player.asm"
include "gameplay/player/player-stats.asm"

include "gameplay/cats/cat.asm"
include "gameplay/cats/cat-spawner.asm"

include "gameplay/pigeon/pigeon-missile-spawner.asm"
include "gameplay/pigeon/pigeon-missile.asm"
include "gameplay/pigeon/pigeon.asm"

include "gameplay/somsiad/somsiad.asm"

include "libs/gb-sprobj.asm"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ; Shut down audio circuitry
    ld a, 0
    ld [rNR52], a

	call WaitForOneVBlank

	call InitSprObjLib
    call ClearHardwareOam

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld a, 0
	ldh [rSTAT], a
	di

	call InitGameState
	
	; Turn the LCD on
	ld a, LCDCF_BGON | LCDCF_OBJON | LCDCF_OBJ16 | LCDCF_ON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

	ld a, %11100100
    ld [rOBP0], a


Main:
	; clean up, vblanks
	call WaitForOneVBlank

	; background
	call DrawScore
	call DrawHp

	; input
	call UpdateKeys

	; gb-sprobj-lib
	call ResetShadowOAM

	; game loop
	call UpdatePlayer
	call UpdatePigeon
	call UpdateCats
	call UpdateMissile
	call UpdateSomsiad
	
	;vblanks
	call WaitForOneVBlank	

	ld a, HIGH(wShadowOAM)
	call hOAMDMA

	call WaitForOneVBlank

	jp Main