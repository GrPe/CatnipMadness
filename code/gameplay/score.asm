section "ScoreVariables", wram0
wPlayerScore:: dw

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

