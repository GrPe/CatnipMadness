section "Utils", rom0

; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank
    ret

;Clear OAMRAM
ClearOam:
    ld a, 0
    ld b, 160
    ld hl, _OAMRAM
.clearOam:
    ld [hli], a
    dec b
    jp nz, .clearOam
    ret

; Copy the tile data
; @param de: Source
; @param hl: Destination
; @param bc: Length
MemCopy:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, MemCopy
    ret;

; Check collision between 2 objects
; @param bc: 1st OAM
; @param de: 2st OAM
; returns h: 0 = no collision, 1 = collision
CheckCollision:
    ; y coordinates
    ld a, [bc]
    ld h, a
    ld a, [de]
    cp a, h
    jp nz, .noCollision
    ; x coordinates
    inc bc
    ld a, [bc]
    ld h, a
    inc de
    ld a, [de]
    sub a, 8
    cp a, h
    jp nc, .noCollision ; (a - 8 < h)
    add a, 8 + 8
    cp a, h
    jp c, .noCollision ; (a + 8 > h)
    ld a, 1
    ld h, a
    ret

.noCollision:
    ld a, 0
    ld h, a
    ret