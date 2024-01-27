SECTION "PlayerVariables", WRAM0
wPlayerPositionX:: dw
wPlayerPositionY:: dw
wPlayerScore:: dw

section "Player", rom0

SetupPlayer:
	ld a, 24 ;32
	ld [wPlayerPositionX], a
	ld a, 128 ;144
	ld [wPlayerPositionY], a
	ld a, 0
	ld [wPlayerScore], a
	ret

UpdatePlayer:
	call HandlePlayerInput

	ld b, 128 ;144
	ld a, [wPlayerPositionX]
	ld c, a
	ld d, PLAYER_TILE
	ld e, 0
	call RenderSimpleSprite
	ret

HandlePlayerInput:
; Handle player movement
.checkLeft:
	ld a, [wCurrentKeys]
	and a, PADF_LEFT
	jp z, .checkRight
.left:
	ld a, [wPlayerPositionX]
	dec a
	cp a, PLAYER_MAX_LEFT
	ret z
	ld [wPlayerPositionX], a
	ret
.checkRight:
	ld a, [wCurrentKeys]
	and a, PADF_RIGHT
	ret z
.right:
	ld a, [wPlayerPositionX]
	inc a
	cp a, PLAYER_MAX_RIGHT
	ret z
	ld [wPlayerPositionX], a
	ret