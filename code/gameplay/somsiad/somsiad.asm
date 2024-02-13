section "Somsiad variables", wram0
wSomsiadAnimationCounter: db
wSomsiadDirection: db

section "Somsiad", rom0

InitSomsiad:
    ld a, 0
    ld [wSomsiadAnimationCounter], a
    ld [wSomsiadDirection], a
    ret

UpdateSomsiad:
    ld a, [wSomsiadAnimationCounter]
    inc a
    ld [wSomsiadAnimationCounter], a

    ; check if rotate somsiad
    cp a, SOMSIAD_ANIMATION_DELEY
    jp c, .drawStart
    
    ld a, 0
    ld [wSomsiadAnimationCounter], a
    
    ld a, [wSomsiadDirection]
    xor a, 1
    and a, 1
    ld [wSomsiadDirection], a

.drawStart:
    ld a, [wSomsiadDirection]
    cp a, 0
    jp z, .drawSomsiad
    jp .drawReversedSomsiad

.drawReversedSomsiad:
    ld b, SOMSIAD_Y_POS
    ld c, SOMSIAD_X_POS
    ld d, SOMSIAD_SPRITE
    ld e, %00100000
    call RenderSimpleSprite
    ret

.drawSomsiad:

    ld b, SOMSIAD_Y_POS
    ld c, SOMSIAD_X_POS
    ld d, SOMSIAD_SPRITE
    ld e, 0
    call RenderSimpleSprite
    ret
