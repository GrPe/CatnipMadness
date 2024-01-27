section "Player", rom0

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


UpdatePlayer:

	;Collision Player vs Enemy
	ld bc, PLAYER_OAM
	ld de, ENEMY_OAM_0
	call CheckCollision
	ld a, h
	ld [wTestColl], a

; Handle player movement
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

section "VAR PLAYER TEST", wram0
wTestColl: db