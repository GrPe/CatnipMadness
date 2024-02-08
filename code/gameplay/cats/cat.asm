section "Cat variables", wram0
wCatsCurrentCatY: db
wCatsCurrentCatX: db

wCatsSpawnCounter: db
wCatsNextCatXPosition: db ; spawn new enemy when x != 0
wCatsActiveCatCounter: db ; number of active cats
wCatsUpdateCatCounter: db ; how many cat's already updated

wCats: ds CATS_MAX_COUNT * CAT_BYTES_COUNT

section "Cat", rom0

InitCats:

	ld a, 0
	ld [wCatsSpawnCounter], a
	ld [wCatsNextCatXPosition], a
	ld [wCatsActiveCatCounter], a
	ld [wCatsUpdateCatCounter], a
	ld b, 0
	ld hl, wCats

.initCats_loop:

	; Set as inactive
	ld a, 0
	ld [hl], a

	; Increase the address
	ld a, l
	add a, CAT_BYTES_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

	; Increase counter
	ld a, b
	inc a
	ld b, a

	cp a, CATS_MAX_COUNT
	ret z

	jp .initCats_loop
	ret

UpdateCats:

	call TryToSpawnCat

	; check if we have active cats
	ld a, [wCatsNextCatXPosition]
	ld b, a
	ld a, [wCatsActiveCatCounter]
	or a, b
	cp a, 0
	ret z

	; reset cat's update counter
	ld a, 0
	ld [wCatsUpdateCatCounter], a

	ld a, LOW(wCats)
	ld l, a
	ld a, HIGH(wCats)
	ld h, a
	jp .updateCat_begin

.updateCats_loop:

	; if all cats updates = ret
	ld a, [wCatsUpdateCatCounter]
	inc a
	ld [wCatsUpdateCatCounter], a

	ld a, [wCatsUpdateCatCounter]
	cp a, CATS_MAX_COUNT
	ret nc

	; go to next cat
	ld a, l
	add a, CAT_BYTES_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

.updateCat_begin:

	ld a, [hl]
	cp 0 ; cat is not active
	jp nz, .updateCat_movement

.updateCat_spawnNewCat:

	; check if cat need to be spawn
	ld a, [wCatsNextCatXPosition]
	cp 0

	; if no, skip spawn section
	jp z, .updateCats_loop

	push hl

	;activate cat
	ld a, 1
	ld [hli], a

	; set x position to random one
	ld a, [wCatsNextCatXPosition]
	ld [hli], a

	; set y to 0
	ld a, 0
	ld [hli], a

	; clear variable - do not create next cat
	ld a, 0
	ld [wCatsNextCatXPosition], a

	pop hl

	; increase active cat counter
	ld a, [wCatsActiveCatCounter]
	inc a
	ld [wCatsActiveCatCounter], a

.updateCat_movement:
	push hl

	; get x pos
	inc hl
	ld a, [hli]
	ld b, a
	ld [wCatsCurrentCatX], a

	; get and increase y pos by speed
	ld a, [hl]
	add a, CATS_BASE_SPEED
	ld [hl], a
	ld d, a

	pop hl
	ld a, d
	ld [wCatsCurrentCatY], a	

;todo: extract function
.updateCat_PlayerCollision:
	push hl
	ld a, [wPlayerPositionY]
	ld d, a
	ld a, [wCatsCurrentCatY]
	add a, 8
	cp a, d
	jp c, .updateCat_GroundCollision
	; x coordinates
	ld a, [wPlayerPositionX]
	ld h, a
	ld a, [wCatsCurrentCatX]
	sub a, 8
	cp a, h
	jp nc, .updateCat_GroundCollision; (a - 8 < h)
	add a, 8 + 8
	cp a, h
	jp c, .updateCat_GroundCollision; (a + 8 > h)

.updateCat_PlayerCollision_score:
	pop hl
	ld a, [wPlayerScore]
	inc a
	ld [wPlayerScore], a
	jp .updateCat_remove

.updateCat_GroundCollision:
	pop hl
	ld a, [wCatsCurrentCatY]
	cp GROUND_LEVEL
	jp z, .updateCat_remove
	
; no collision
.updatCat_draw:
	push hl

	inc hl
	ld a, [wCatsCurrentCatX]
	ld [hli], a
	ld a, [wCatsCurrentCatY]
	ld [hli], a

.updateCat_draw_animation
    ld d, CAT_SPRITE_TILE
    ld a, [wCatsCurrentCatY]
    and a, %11110000
    rrca
    rrca
    rrca 
    rrca 
    rrca

    jp c, .updateCat_draw_animation_end
    ld d, CAT_SPRITE_TILE2
	
.updateCat_draw_animation_end:
	; render sprite
	ld a, [wCatsCurrentCatY]
	ld b, a
	ld a, [wCatsCurrentCatX]
	ld c, a
	ld e, 0
	call RenderSimpleSprite

	pop hl

	jp .updateCats_loop

.updateCat_remove:

	;set inactive and clear x pos
	ld a, 0
	ld [hl], a

	; decreate cat counter
	ld a, [wCatsActiveCatCounter]
	dec a
	ld [wCatsActiveCatCounter], a

	jp .updateCats_loop
