section "Utils Variables",wram0
randstate: ds 4

section "Utils", rom0

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

;; From: https://github.com/pinobatch/libbet/blob/master/src/rand.z80#L34-L54
; Generates a pseudorandom 16-bit integer in BC
; using the LCG formula from cc65 rand():
; x[i + 1] = x[i] * 0x01010101 + 0xB3B3B3B3
; @return A=B=state bits 31-24 (which have the best entropy),
; C=state bits 23-16, HL trashed
rand:
    ; Add 0xB3 then multiply by 0x01010101
    ld hl, randstate+0
    ld a, [hl]
    add a, $B3
    ld [hl+], a
    adc a, [hl]
    ld [hl+], a
    adc a, [hl]
    ld [hl+], a
    ld c, a
    adc a, [hl]
    ld [hl], a
    ld b, a
    ret
