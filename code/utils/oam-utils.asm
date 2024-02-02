; section "OAM Variables", wram0
; wSpritesUsed:: db

section "OAM Utils", rom0

; Clear hardware OAMRAM
ClearHardwareOam:
    ld a, 0
    ld b, 160
    ld hl, _OAMRAM
.clearOam:
    ld [hli], a
    dec b
    jp nz, .clearOam
    ret

ClearSoftwareOam:
    ld a, 0
    ld b, 160
    ld hl, wShadowOAM

.clearSoftwareOam_loop:
    ld [hli], a
    dec b
    jp nz, .clearSoftwareOam_loop
    ; xor a
    ; ld [wSpritesUsed], a

    ; git branch-sprobj-lib
    ld a, HIGH(wShadowOAM)
    call hOAMDMA
    
    ret
