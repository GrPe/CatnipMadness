section "Pigeon variables", wram0
wPigeonCurrentX: db
wPigeonDirection: db ; 0 => left, 1 => right

section "Pigeon", rom0

InitPigeon:
    ld a, 0
    ld [wPigeonDirection], a
    ld a, 16
    ld [wPigeonCurrentX], a
    ret

UpdatePigeon:
    ld a, [wPigeonDirection]
    cp a, 0
    jp z, .moveLeft
.moveRight:
    ld a, [wPigeonCurrentX]
    inc a
    cp a, PLAYER_MAX_RIGHT
    jp z, .changeToLeft
    ld [wPigeonCurrentX], a
    jp .pEnd

.moveLeft:
    ld a, [wPigeonCurrentX]
    dec a
    cp a, PLAYER_MAX_LEFT
    jp z, .changeToRight
    ld [wPigeonCurrentX], a
    jp .pEnd

.changeToLeft:
    ld a, 0
    ld [wPigeonDirection], a
    jp .pEnd

.changeToRight:
    ld a, 1
    ld [wPigeonDirection], a

.pEnd:
    ld a, [wPigeonCurrentX]
    ld b, PIGEON_CURRENT_Y
    ld c, a
    ld d, PIGEON_SPRITE_TILE

    ld a, [wPigeonDirection]
    cp a, 0
    jp z, .pEndDraw
    ld a, 0
    set 5, a
.pEndDraw:
    ld e, a
    call RenderSimpleSprite
    ret

