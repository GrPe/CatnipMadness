section "Utils", rom0

;Clear OAMRAM
ClearOamFunc:
    ld a, 0
    ld b, 160
    ld hl, _OAMRAM
ClearOam:
    ld [hli], a
    dec b
    jp nz, ClearOam
    ret