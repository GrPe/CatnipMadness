section "rand_ram",wram0
randstate: ds 4

section "UtilsVariables", wram0
wResult: db
wLastOAMAddress:: dw
wSpritesUsed:: db

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


; from https://github.com/gbdev/gb-asm-tutorial/tree/master
ClearRemainingSprites::


    ;Get our offset address in hl
    ld a, _OAMRAM + 4 + 4 * MAX_CAT_COUNT
    ld l, a

ClearRemainingSprites_Loop::
    ld a, HIGH(wShadowOAM)
    ld h, a

    ld a, l
    cp a, 160
    ret nc
    ret nc

    ; Set the y and x to be 0
    ld a, 0
    ld [hli], a
    ld [hld], a

    ; Move up 4 bytes
    ld a, l
    add a, 4
    ld l, a

    jp ClearRemainingSprites_Loop