INCLUDE "hardware.inc"
include "utils.asm"
include "input.asm"

SECTION "Header", ROM0[$100]

    jp EntryPoint

    ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ; Shut down audio circuitry
    ld a, 0
    ld [rNR52], a
	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
	call MemCopy

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
	call MemCopy

	; Copy the tile data
	ld de, Paddle
	ld hl, $8000
	ld bc, PaddleEnd - Paddle
	call MemCopy

	; Copy the cat tiles
	ld de, Cat
	ld hl, $8010
	ld bc, CatEnd - Cat
	call MemCopy

	call ClearOam

	;Set data of first dummy sprite
	ld hl, _OAMRAM
	ld a, 128 + 16
	ld [hli], a
	ld a, 16 + 8
	ld [hli], a
	ld a, 0
	ld [hli], a
	ld [hl], a

	; Set cat sprite
	ld hl, _OAMRAM + 4
	ld a, 8 + 16
	ld [hli], a
	ld a, 16 + 8
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, 0
	ld [hl], a

	; Set cat 2 sprite
	ld hl, _OAMRAM + 8
	ld a, 48 + 16
	ld [hli], a
	ld a, 136 + 8
	ld [hli], a
	ld a, 1
	ld [hli], a
	ld a, 0
	ld [hl], a
	
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
WaitVBlank2: ; skip 0 - 144
    ld a, [rLY]
    cp 144
    jp c, WaitVBlank2

	call UpdateKeys

	; falling cat
	ld a, [_OAMRAM + 4]
	inc a
	ld [_OAMRAM + 4], a

	; falling cat 2
	ld a, [_OAMRAM + 8]
	inc a
	ld [_OAMRAM + 8], a

	; the gracz
CheckLeft:
	ld a, [wCurrentKeys]
	and a, PADF_LEFT
	jp z, CheckRight
Left:
	ld a, [_OAMRAM + 1]
	dec a
	cp a, 7
	jp z, Main
	ld [_OAMRAM + 1], a
	jp Main
CheckRight:
	ld a, [wCurrentKeys]
	and a, PADF_RIGHT
	jp z, Main
Right:
	ld a, [_OAMRAM + 1]
	inc a
	cp a, 160
	jp z, Main
	ld [_OAMRAM + 1], a
	jp Main

	;przesuwanie sprite
	; ld a, [wFrameCounter]
	; inc a
	; ld [wFrameCounter], a
	; cp a, 15
	; jp nz, Main

	; ld a, 0
	; ld [wFrameCounter], a

	; ld a, [_OAMRAM + 1]
	; inc a
	; ld [_OAMRAM + 1], a

	jp Main


SECTION "Tile data", ROM0

Tiles:
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $01, $02, $03, $01, $04, $03, $01, $05, $00, $01, $05, $00, $06, $04, $07, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $08, $09, $0a, $0b, $0c, $0d, $0b, $0e, $0f, $08, $0e, $0f, $10, $11, $12, $13, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $14, $15, $16, $17, $18, $19, $1a, $1b, $0f, $14, $1b, $0f, $14, $1c, $16, $1d, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $1e, $1f, $20, $21, $22, $23, $24, $22, $25, $1e, $22, $25, $26, $22, $27, $1d, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $01, $28, $29, $2a, $2b, $2c, $2d, $2b, $2e, $2d, $2f, $30, $2d, $31, $32, $33, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $08, $34, $0a, $0b, $11, $0a, $0b, $35, $36, $0b, $0e, $0f, $08, $37, $0a, $38, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $14, $39, $16, $17, $1c, $16, $17, $3a, $3b, $17, $1b, $0f, $14, $3c, $16, $1d, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $1e, $3d, $3e, $3f, $22, $27, $21, $1f, $20, $21, $22, $25, $1e, $22, $40, $1d, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $41, $42, $43, $44, $30, $33, $41, $45, $43, $41, $30, $43, $41, $30, $33, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:

Paddle:
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
PaddleEnd:

Cat:
    dw `13333331
    dw `13333331
    dw `13333331
    dw `13333331
    dw `01333310
    dw `00133100
    dw `00111100
    dw `00011000
CatEnd:

section "Counter", wram0
wFrameCounter: db