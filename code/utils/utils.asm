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