section "Pigeon missiles variables", wram0
wPigeonCurrentMissileY: db
wPigeonCurrentMissileX: db

wPigeonMissileSpawnCounter: db
wPigeonActiveMissileCounter: db
wPigeonUpdateMissileCounter: db
wPigeonNextMissileXPosition: db

wPigeons: ds PIGEON_SHIT_MAX_COUNT * PER_PIGEON_MISSILE_BYTE_COUNT

section "Pigeon missiles", rom0

SetupPigeonMissile:
    ld a, 0
    ld [wPigeonMissileSpawnCounter], a
    ld [wPigeonActiveMissileCounter], a
    ld [wPigeonUpdateMissileCounter], a
    ld [wPigeonNextMissileXPosition], a
    ld b, 0
    ld hl, wPigeons

.setupPigeonMissile_loop:

	; Set as inactive
	ld a, 0
	ld [hl], a

	; Increase the address
	ld a, l
	add a, PER_PIGEON_MISSILE_BYTE_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

	; Increase counter
	ld a, b
	inc a
	ld b, a

	cp a, PIGEON_SHIT_MAX_COUNT
	ret z

	jp .setupPigeonMissile_loop
	ret

UpdateMissile:

    call TryToSpawnMissile

    ; check if we have active shit
	ld a, [wPigeonNextMissileXPosition]
	ld b, a
	ld a, [wPigeonActiveMissileCounter]
	or a, b
	cp a, 0
	ret z

	; reset shit's update counter
	ld a, 0
	ld [wPigeonUpdateMissileCounter], a

	ld a, LOW(wPigeons)
	ld l, a
	ld a, HIGH(wPigeons)
	ld h, a
	jp .updateMissile_begin

.updateMissile_loop:

	; if all cats updates = ret
	ld a, [wPigeonUpdateMissileCounter]
	inc a
	ld [wPigeonUpdateMissileCounter], a

	ld a, [wPigeonUpdateMissileCounter]
	cp a, PIGEON_SHIT_MAX_COUNT
	ret nc

	; go to next cat
	ld a, l
	add a, PER_PIGEON_MISSILE_BYTE_COUNT
	ld l, a
	ld a, h
	adc a, 0
	ld h, a

.updateMissile_begin:

	ld a, [hl]
	cp 0 ; cat is not active
	jp nz, .updateMissile_movement

.updateMissile_spawnNewMissile:

	; check if shit need to be spawn
	ld a, [wPigeonNextMissileXPosition]
	cp 0

	; if no, skip spawn section
	jp z, .updateMissile_loop

	push hl

	;activate shit
	ld a, 1
	ld [hli], a

	; set x position to random one
	ld a, [wPigeonNextMissileXPosition]
	ld [hli], a

	; set y to 0
	ld a, PIGEON_CURRENT_Y
	ld [hl], a

	; clear variable - do not create next cat
	ld a, 0
	ld [wPigeonNextMissileXPosition], a

	pop hl

	; increase active cat counter
	ld a, [wPigeonActiveMissileCounter]
	inc a
	ld [wPigeonActiveMissileCounter], a


.updateMissile_movement:
    push hl
	; get x pos
	inc hl
	ld a, [hli]
	ld b, a
	ld [wPigeonCurrentMissileX], a

	; get and increase y pos by speed
	ld a, [hl]
	add a, PIGEON_SHIT_MAX_SPEED
	ld [hl], a
	ld d, a

	pop hl
	ld a, d
	ld [wPigeonCurrentMissileY], a	


.updateMissile_PlayerCollision:
	push hl
	ld a, [wPlayerPositionY]
	ld d, a
	ld a, [wPigeonCurrentMissileY]
	add a, 8
	cp a, d
	jp c, .updateMissile_GroundCollision
	; x coordinates
	ld a, [wPlayerPositionX]
	ld h, a
	ld a, [wPigeonCurrentMissileX]
	sub a, 8
	cp a, h
	jp nc, .updateMissile_GroundCollision; (a - 8 < h)
	add a, 8 + 8
	cp a, h
	jp c, .updateMissile_GroundCollision; (a + 8 > h)

.updateMissile_PlayerCollision_hp:
	pop hl
	ld a, [wPlayerHp]
    cp a, 0
    jp z, .updateMissile_remove
	dec a
	ld [wPlayerHp], a
	jp .updateMissile_remove

.updateMissile_GroundCollision:	
	pop hl
	ld a, [wPigeonCurrentMissileY]
	cp GROUND_LEVEL
	jp z, .updateMissile_remove
	
; no collision
.updateMissile_draw:
	push hl

	inc hl
	ld a, [wPigeonCurrentMissileX]
	ld [hli], a
	ld a, [wPigeonCurrentMissileY]
	ld [hli], a

.updateMissile_draw_animation:
    ld d, SHIT_TILE
    ld a, [wPigeonCurrentMissileY]
    and a, %11110000
    rrca
    rrca
    rrca 
    rrca 
    rrca

    jp c, .updateMissile_draw_animation_end
    ld d, SHIT_TILE2

.updateMissile_draw_animation_end:
	; render sprite
	ld a, [wPigeonCurrentMissileY]
	ld b, a
	ld a, [wPigeonCurrentMissileX]
	ld c, a	
	ld e, 0
	call RenderSimpleSprite

	pop hl

	jp .updateMissile_loop

.updateMissile_remove:

	;set inactive and clear x pos
	ld a, 0
	ld [hl], a

	; decreate cat counter
	ld a, [wPigeonActiveMissileCounter]
	dec a
	ld [wPigeonActiveMissileCounter], a

	jp .updateMissile_loop

