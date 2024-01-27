section "Player", rom0

; Handle player movement
UpdatePlayer:

.checkLeft:
	ld a, [wCurrentKeys]
	and a, PADF_LEFT
	jp z, .checkRight
.left:
	ld a, [_OAMRAM + 1]
	dec a
	cp a, 7
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
	cp a, 160
	ret z
	ld [_OAMRAM + 1], a
	ret