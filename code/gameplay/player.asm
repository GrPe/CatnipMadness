section "Player", rom0

DEF PLAYER_TILE EQU $0
DEF PLAYER_MAX_LEFT EQU 7
DEF PLAYER_MAX_RIGHT EQU 160
DEF PLAYER_OAM EQU _OAMRAM

SetupPlayer:
	;Set data of first dummy sprite
	ld hl, PLAYER_OAM
	ld a, 128 + 16
	ld [hli], a
	ld a, 16 + 8
	ld [hli], a
	ld a, PLAYER_TILE
	ld [hli], a
	ld [hl], a

; Handle player movement
UpdatePlayer:

.checkLeft:
	ld a, [wCurrentKeys]
	and a, PADF_LEFT
	jp z, .checkRight
.left:
	ld a, [_OAMRAM + 1]
	dec a
	cp a, PLAYER_MAX_LEFT
	ret z
	ld [_OAMRAM + 1], a
	ret
.checkRight:
	ld a, [wCurrentKeys]
	and a, PADF_RIGHT
	ret z
.right:
	ld a, [_OAMRAM + 1]
	inc a
	cp a, PLAYER_MAX_RIGHT
	ret z
	ld [_OAMRAM + 1], a
	ret