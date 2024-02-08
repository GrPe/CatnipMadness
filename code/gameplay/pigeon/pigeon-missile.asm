section "Pigeon missiles variables", wram0
wPigeonCurrentMissileY: db
wPigeonCurrentMissileX: db

wPigeonMissileSpawnCounter: db
wPigeonActiveMissileCounter: db
wPigeonUpdateMissileCounter: db
wPigeonNextMissileXPosition: db

wPigeons: ds PIGEON_SHIT_MAX_COUNT * PER_PIGEON_MISSILE_BYTE_COUNT

section "Pigeon missiles", rom0

SetupShit:
    ld a, 0
    ld [wPigeonMissileSpawnCounter], a
    ld [wPigeonActiveMissileCounter], a
    ld [wPigeonUpdateMissileCounter], a
    ld [wPigeonNextMissileXPosition], a
    ld b, 0
    ld hl, wPigeons

SetupShit_Loop:
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

	jp SetupShit_Loop
	ret

UpdateShit:

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
	jp UpdateShit_PerShit

UpdateShit_Loop:

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

UpdateShit_PerShit:

	ld a, [hl]
	cp 0 ; cat is not active
	jp nz, UpdateShit_PerShit_Update

UpdateShit_MakeNewShit:

	; check if shit need to be spawn
	ld a, [wPigeonNextMissileXPosition]
	cp 0

	; if no, skip spawn section
	jp z, UpdateShit_Loop

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


UpdateShit_PerShit_Update:
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


UpdateSHit_PerShit_CheckPlayerCollision:
	push hl
	ld a, [wPlayerPositionY]
	ld d, a
	ld a, [wPigeonCurrentMissileY]
	add a, 8
	cp a, d
	jp c, .splayCollisionCheck
	; x coordinates
	ld a, [wPlayerPositionX]
	ld h, a
	ld a, [wPigeonCurrentMissileX]
	sub a, 8
	cp a, h
	jp nc, .splayCollisionCheck; (a - 8 < h)
	add a, 8 + 8
	cp a, h
	jp c, .splayCollisionCheck; (a + 8 > h)

	; check if player got a shit
	pop hl
	ld a, [wPlayerHp]
    cp a, 0
    jp z, UpdateShit_PerShit_RemoveShit
	dec a
	ld [wPlayerHp], a
	jp UpdateShit_PerShit_RemoveShit

.splayCollisionCheck: ; no collision
	pop hl

UpdateShit_PerShit_CheckGroundCollision:
	ld a, [wPigeonCurrentMissileY]
	cp GROUND_LEVEL
	jp z, UpdateShit_PerShit_RemoveShit
	
UpdateShit_PerShit_NoCollision:
	push hl

	inc hl
	ld a, [wPigeonCurrentMissileX]
	ld [hli], a
	ld a, [wPigeonCurrentMissileY]
	ld [hli], a

    ;animation ^ ^
    ld d, SHIT_TILE
    ld a, [wPigeonCurrentMissileY]
    and a, %11110000
    rrca
    rrca
    rrca 
    rrca 
    rrca
    jp c, .drawShit

    ld d, SHIT_TILE2
.drawShit:
	; render sprite
	ld a, [wPigeonCurrentMissileY]
	ld b, a
	ld a, [wPigeonCurrentMissileX]
	ld c, a	
	ld e, 0
	call RenderSimpleSprite

	pop hl

	jp UpdateShit_Loop

UpdateShit_PerShit_RemoveShit:

	;set inactive and clear x pos
	ld a, 0
	ld [hl], a

	; decreate cat counter
	ld a, [wPigeonActiveMissileCounter]
	dec a
	ld [wPigeonActiveMissileCounter], a

	jp UpdateShit_Loop

