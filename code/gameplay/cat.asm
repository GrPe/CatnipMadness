section "Cat", rom0

DEF ENEMY_TILE EQU $01
DEF ENEMY_OAM_0 EQU _OAMRAM + 4
DEF ENEMY_OAM_1 EQU _OAMRAM + 8

SetupEnemies:
	; Set cat sprite
	ld hl, ENEMY_OAM_0
	ld a, 8 + 16
	ld [hli], a
	ld a, 16 + 8
	ld [hli], a
	ld a, ENEMY_TILE
	ld [hli], a
	ld a, 0
	ld [hl], a

	; Set cat 2 sprite
	ld hl, ENEMY_OAM_1
	ld a, 48 + 16
	ld [hli], a
	ld a, 136 + 8
	ld [hli], a
	ld a, ENEMY_TILE
	ld [hli], a
	ld a, 0
	ld [hl], a

	ret

UpdateEnemy:

	; falling cat
	ld a, [ENEMY_OAM_0]
	inc a
	ld [ENEMY_OAM_0], a

	; falling cat 2
	ld a, [ENEMY_OAM_1]
	inc a
	ld [ENEMY_OAM_1], a

	ret