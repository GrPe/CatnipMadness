SECTION "Player variables", WRAM0
wPlayerPositionX:: db
wPlayerPositionY:: db
wPlayerDirection:: db; 0 => right, 1 => left

section "Player", rom0

SetupPlayer:
	ld a, 24 ;32
	ld [wPlayerPositionX], a
	ld a, 128 ;144
	ld [wPlayerPositionY], a
	ld a, 0
	ld [wPlayerScore], a
	ld [wPlayerDirection], a
	ld a, PLAYER_START_HP
	ld [wPlayerHp], a
	ret

UpdatePlayer:
	call HandlePlayerInput

	ld e, 0
	ld a, [wPlayerDirection]
	cp a, 1
	jp nz, .updatePlayerDraw
	ld a, 0
	set 5, a
	ld e, a

.updatePlayerDraw:
	ld b, 128 ;144
	ld a, [wPlayerPositionX]
	ld c, a
	ld d, PLAYER_TILE
	call RenderSimpleSprite
	ret

HandlePlayerInput:
; Handle player movement
.checkLeft:
	ld a, [wCurrentKeys]
	and a, PADF_LEFT
	jp z, .checkRight
.left:
	ld a, 1
	ld [wPlayerDirection], a
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
	ld a, 0
	ld [wPlayerDirection], a
	ld a, [wPlayerPositionX]
	inc a
	cp a, PLAYER_MAX_RIGHT
	ret z
	ld [wPlayerPositionX], a
	ret