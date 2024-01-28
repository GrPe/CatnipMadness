section "ScoreVariables", wram0
wPlayerScore:: dw
wPlayerHp: dw

section "Score", rom0

DrawScore:
    ld a, [wPlayerScore]
    ld c, a
    ld hl, $980C
    ld b, 8

.draw:
    rlc c
    jp c, .draw1
    ld a, $00
    ld [hli], a
    jp .next
.draw1:
    ld a, $01
    ld [hli], a
.next:
    dec b
    ld a, b
    cp a, 0
    jp nz, .draw

    ret

DrawHp:
    ld a, [wPlayerHp]
    ld c, a
    ld a, PLAYER_START_HP
    sub a, c ; how many heads to hide
    ld c, a
    cp a, 0
    jp z, .drawHpEnd

    ld hl, $9804 ; 5th head
.drawhp1:
    ld a, BACKGROUND_TILE
    ld [hld], a
    dec c
    ld a, c
    cp a, 0
    jp nz, .drawhp1
.drawHpEnd:
    ret