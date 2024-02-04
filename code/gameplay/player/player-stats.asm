section "Player stats variables", wram0
wPlayerScore: db
wPlayerHp: db

section "Player stats", rom0

DrawScore:
    ld a, [wPlayerScore]
    ld c, a
    ld hl, SCORE_LAST_POSITION
    ld b, SCORE_SIZE

.score_draw:
    rlc c
    jp c, .score_draw_1
.score_draw_0:
    ld a, TILE_FONT_0
    ld [hli], a
    jp .score_draw_nextDigit
.score_draw_1:
    ld a, TILE_FONT_1
    ld [hli], a
.score_draw_nextDigit:
    dec b
    ld a, b
    cp a, 0
    jp nz, .score_draw

    ret

DrawHp:
    ld a, [wPlayerHp]
    ld c, a
    ld a, PLAYER_START_HP
    sub a, c ; how many heads to hide
    ld c, a
    cp a, 0
    jp z, .drawHp_end

    ld hl, HP_LAST_POSITION
.drawHp_loop:
    ld a, TILE_BACKGROUND
    ld [hld], a
    dec c
    ld a, c
    cp a, 0
    jp nz, .drawHp_loop
.drawHp_end:
    ret