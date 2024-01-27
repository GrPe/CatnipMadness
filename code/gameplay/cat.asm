section "Cat", rom0

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

	;Collision cat vs ground
.cat0Momevent:
	ld a, [ENEMY_OAM_0]
	cp GROUND_LEVEL
	jp z, .cat1Movement

	; falling cat
	ld a, [ENEMY_OAM_0]
	inc a
	ld [ENEMY_OAM_0], a

.cat1Movement:
	ld a, [ENEMY_OAM_1]
	cp GROUND_LEVEL
	jp z, .catsEnd 
	
	; falling cat 2
	ld a, [ENEMY_OAM_1]
	inc a
	ld [ENEMY_OAM_1], a

.catsEnd:
	ret