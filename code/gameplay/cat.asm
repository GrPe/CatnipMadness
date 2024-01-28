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
	ld [wUpdateCatCounter], a
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
	ret

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
	add a, CAT_BASE_SPEED
	ld [hl], a
	ld d, a

	pop hl
	ld a, d
	ld [wCurrentCatY], a	


UpdateEnemy_PerCat_CheckPlayerCollision:
	push hl
	ld a, [wPlayerPositionY]
	ld d, a
	ld a, [wCurrentCatY]
	add a, 8
	cp a, d
	jp c, .playCollisionCheck
	; x coordinates
	ld a, [wPlayerPositionX]
	ld h, a
	ld a, [wCurrentCatX]
	sub a, 8
	cp a, h
	jp nc, .playCollisionCheck; (a - 8 < h)
	add a, 8 + 8
	cp a, h
	jp c, .playCollisionCheck; (a + 8 > h)

	; check if player catch the cat
	ld a, [wCurrentKeys]
	and a, PADF_A
	jp nz, HandlePlayerCatch

.playCollisionCheck:
	pop hl
	jp UpdateEnemy_PerCat_CheckGroundCollision ; no collision with player

HandlePlayerCatch:
	pop hl
	ld a, [wPlayerScore]
	inc a
	ld [wPlayerScore], a
	jp UpdateEnemy_PerCat_RemoveCat

UpdateEnemy_PerCat_CheckGroundCollision:
	ld a, [wCurrentCatY]
	cp GROUND_LEVEL
	jp z, UpdateEnemy_PerCat_RemoveCat
	
UpdateEnemy_PerCat_NoCollision:
	push hl

	inc hl
	ld a, [wCurrentCatX]
	ld [hli], a
	ld a, [wCurrentCatY]
	ld [hli], a

    ;animation ^ ^
    ld e, 0
    ld a, [wCurrentCatY]
    and a, %11110000
    rrca
    rrca
    rrca 
    rrca 
    rrca
    jp c, .drawShit

    ld a, 0
    set 5, a
    ld e, a
.drawShit:
	; render sprite
	ld a, [wCurrentCatY]
	ld b, a
	ld a, [wCurrentCatX]
	ld c, a
	ld d, ENEMY_TILE
	call RenderSimpleSprite

	pop hl

	jp UpdateEnemy_Loop

UpdateEnemy_PerCat_RemoveCat:

	;set inactive and clear x pos
	ld a, 0
	ld [hl], a

	; decreate cat counter
	ld a, [wActiveCatCounter]
	dec a
	ld [wActiveCatCounter], a

	jp UpdateEnemy_Loop
