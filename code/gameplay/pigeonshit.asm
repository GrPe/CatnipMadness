section "PigeonShitVariable", wram0
wCurrentShitY: db
wCurrentShitX: db

wPigeonSpawnCounter: db
wActivePigeonCounter: db
wUpdatePigeonCounter: db
wNextShitXPosition: db

wPigeons: ds PIGEON_SHIT_MAX_COUNT * PER_CAT_BYTES_COUNT

section "PigeonShit", rom0

SetupShit:
    ld a, 0
    ld [wPigeonSpawnCounter], a
    ld [wActivePigeonCounter], a
    ld [wUpdatePigeonCounter], a
    ld [wNextShitXPosition], a
    ld b, 0
    ld hl, wPigeons

SetupShit_Loop:
	; Set as inactive
	ld a, 0
	ld [hl], a

	; Increase the address
	ld a, l
	add a, PER_SHIT_BYTES_COUNT
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

    call TryToMakeShit

    ; check if we have active shit
	ld a, [wNextShitXPosition]
	ld b, a
	ld a, [wActivePigeonCounter]
	or a, b
	cp a, 0
	ret z

	; reset shit's update counter
	ld a, 0
	ld [wUpdatePigeonCounter], a

	ld a, LOW(wPigeons)
	ld l, a
	ld a, HIGH(wPigeons)
	ld h, a
	jp UpdateShit_PerShit

UpdateShit_Loop:

	; if all cats updates = ret
	ld a, [wUpdatePigeonCounter]
	inc a
	ld [wUpdatePigeonCounter], a

	ld a, [wUpdatePigeonCounter]
	cp a, PIGEON_SHIT_MAX_COUNT
	ret nc

	; go to next cat
	ld a, l
	add a, PER_SHIT_BYTES_COUNT
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
	ld a, [wNextShitXPosition]
	cp 0

	; if no, skip spawn section
	jp z, UpdateShit_Loop

	push hl

	;activate shit
	ld a, 1
	ld [hli], a

	; set x position to random one
	ld a, [wNextShitXPosition]
	ld [hli], a

	; set y to 0
	ld a, 0
	ld [hli], a

	; clear variable - do not create next cat
	ld a, 0
	ld [wNextShitXPosition], a

	pop hl

	; increase active cat counter
	ld a, [wActivePigeonCounter]
	inc a
	ld [wActivePigeonCounter], a


UpdateShit_PerShit_Update:
    push hl
	; get x pos
	inc hl
	ld a, [hli]
	ld b, a
	ld [wCurrentShitX], a

	; get and increase y pos by speed
	ld a, [hl]
	add a, PIGEON_SHIT_MAX_SPEED
	ld [hl], a
	ld d, a

	pop hl
	ld a, d
	ld [wCurrentShitY], a	


UpdateSHit_PerShit_CheckPlayerCollision:
	push hl
	ld a, [wPlayerPositionY]
	ld d, a
	ld a, [wCurrentShitY]
	add a, 8
	cp a, d
	jp c, .splayCollisionCheck
	; x coordinates
	ld a, [wPlayerPositionX]
	ld h, a
	ld a, [wCurrentShitX]
	sub a, 8
	cp a, h
	jp nc, .splayCollisionCheck; (a - 8 < h)
	add a, 8 + 8
	cp a, h
	jp c, .splayCollisionCheck; (a + 8 > h)

	; check if player got a shit
	pop hl
	ld a, [wPlayerHp]
	dec a
    cp a, 0
    jp z, UpdateShit_PerShit_RemoveShit
	ld [wPlayerHp], a
	jp UpdateShit_PerShit_RemoveShit

.splayCollisionCheck: ; no collision
	pop hl

UpdateShit_PerShit_CheckGroundCollision:
	ld a, [wCurrentShitY]
	cp GROUND_LEVEL
	jp z, UpdateShit_PerShit_RemoveShit
	
UpdateShit_PerShit_NoCollision:
	push hl

	inc hl
	ld a, [wCurrentShitX]
	ld [hli], a
	ld a, [wCurrentShitY]
	ld [hli], a

	; render sprite
	ld a, [wCurrentShitY]
	ld b, a
	ld a, [wCurrentShitX]
	ld c, a
	ld d, SHIT_TILE
	ld e, 0
	call RenderSimpleSprite

	pop hl

	jp UpdateEnemy_Loop

UpdateShit_PerShit_RemoveShit:

	;set inactive and clear x pos
	ld a, 0
	ld [hl], a

	; decreate cat counter
	ld a, [wActivePigeonCounter]
	dec a
	ld [wActivePigeonCounter], a

	jp UpdateShit_Loop

