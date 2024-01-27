section "Cat", rom0

UpdateEnemy:

	; falling cat
	ld a, [_OAMRAM + 4]
	inc a
	ld [_OAMRAM + 4], a

	; falling cat 2
	ld a, [_OAMRAM + 8]
	inc a
	ld [_OAMRAM + 8], a