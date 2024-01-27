section "CatVariable", wram0
wCurrentCatY: db
wCurrentCatX: db

wSpawnCounter: db
wNextCatXPosition: db ; spawn new enemy when x != 0
wActiveCatCounter: db ; number of active enemies
wUpdateCatCounter: db; how many cat's already updated

wCats: ds MAX_CAT_COUNT * PER_CAT_BYTES_COUNT

section "Cat", rom0

SetupEnemies:

	ld a, 0
	ld [wSpawnCounter], a
	ld [wNextCatXPosition], a
	ld [wActiveCatCounter], a
	ld b, 0
	ld hl, wCats

SetupEnemies_Loop:

	; Set as inactive
	ld a, 0
	ld [hl], a

	push hl
	ld de, cat_speed
	add hl, de
	ld a, CAT_BASE_SPEED
	ld [hl], a
	pop hl

	; Increase the address
	ld a, l
	add a, PER_CAT_BYTES_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

	; Increase counter
	ld a, b
	inc a
	ld b, a

	cp a, MAX_CAT_COUNT
	ret z

	jp SetupEnemies_Loop

UpdateEnemy:

	call TryToSpawnCat

	; check if we have active cats
	ld a, [wNextCatXPosition]
	ld b, a
	ld a, [wActiveCatCounter]
	or a, b
	cp a, 0
	ret z

	; reset cat's update counter
	ld a, 0
	ld [wUpdateCatCounter], a

	ld a, LOW(wCats)
	ld l, a
	ld a, HIGH(wCats)
	ld h, a
	jp UpdateEnemy_PerCat

UpdateEnemy_Loop:

	; if all cats updates = ret
	ld a, [wUpdateCatCounter]
	inc a
	ld [wUpdateCatCounter], a

	ld a, [wUpdateCatCounter]
	cp a, MAX_CAT_COUNT
	ret nc

	; go to next cat
	ld a, l
	add a, PER_CAT_BYTES_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

UpdateEnemy_PerCat:

	ld a, [hl]
	cp 0 ; cat is not active
	jp nz, UpdateEnemy_PerCat_Update

UpdateEnemy_SpawnNewEnemy:

	; check if cat need to be spawn
	ld a, [wNextCatXPosition]
	cp 0

	; if no, skip spawn section
	jp z, UpdateEnemy_Loop

	push hl

	;activate cat
	ld a, 1
	ld [hli], a

	; set x position to random one
	ld a, [wNextCatXPosition]
	ld [hli], a

	; set y to 0
	ld a, 0
	ld [hli], a

	; clear variable - do not create next cat
	ld a, 0
	ld [wNextCatXPosition], a

	pop hl

	; increase active cat counter
	ld a, [wActiveCatCounter]
	inc a
	ld [wActiveCatCounter], a

UpdateEnemy_PerCat_Update:

	; save cat speed in e registry
	push hl
	ld bc, cat_speed
	add hl, bc
	ld a, [hl]
	ld e, a
	pop hl
	push hl

	; get x pos
	inc hl
	ld a, [hli]
	ld b, a
	ld [wCurrentCatX], a

	; get and increase y pos by speed
	ld a, [hl]
	add a, e
	ld [hl], a
	ld d, a

	pop hl
	ld a, d
	ld [wCurrentCatY], a	


UpdateEnemy_PerCat_CheckPlayerCollision:
	push hl
	ld bc, PLAYER_OAM
	ld a, [wCurrentCatY]
	ld d, a
	ld a, [wCurrentCatX]
	ld e, a
	call CheckCollision
	pop hl
	ld a, [wResult]
	cp a, 0
	jp z, UpdateEnemy_PerCat_CheckGroundCollision ; no collision with player

	;!!! call damaga
	;!!! update hp etc

UpdateEnemy_PerCat_CheckGroundCollision:
	ld a, [wCurrentCatY]
	cp GROUND_LEVEL
	jp z, UpdateEnemy_PerCat_RemoveCat

	
UpdateEnemy_PerCat_NoCollision:
	push hl
	; get cat's OAM pos
	ld hl, ENEMY_OAM
	ld a, [wUpdateCatCounter]
	rlca 
	rlca ; current cat * 4 (size of OAM)
	ld c, a
	ld a, 0
	ld b, a
	add hl, bc

	; set pos and tile
	ld a, [wCurrentCatY]
	ld [hli], a
	ld a, [wCurrentCatX]
	ld [hli], a
	ld a, ENEMY_TILE
	ld [hl], a

	pop hl
	jp UpdateEnemy_Loop

UpdateEnemy_PerCat_RemoveCat:

	;set inactive and clear x pos
	ld a, 0
	ld [hli], a
	ld [hl], a

	; decreate cat counter
	ld a, [wActiveCatCounter]
	dec a
	ld [wActiveCatCounter], a

	jp UpdateEnemy_Loop


