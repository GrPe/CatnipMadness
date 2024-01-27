section "spawner", rom0

TryToSpawnCat:

    ; increase spawn counter
    ld a, [wSpawnCounter]
    inc a
    ld [wSpawnCounter], a

    ; if it's no time, ret
    ld a, [wSpawnCounter]
    cp a, MAX_CAT_SPAWN_DELAY
    ret c

    ; 
    ld a, [wNextCatXPosition]
    cp a, 0
    ret nz

    ; check if we hit cat limit
    ld a, [wActiveCatCounter]
    cp a, MAX_CAT_COUNT
    ret nc

GetSpawnPosition:
    
    call rand

    ; too much right
    ld a, b
    cp CAT_MAX_RIGHT
    ret nc

    ; too much left
    ld a, b
    cp a, CAT_MAX_LEFT
    ret c

    ; reset spawn counter
    ld a, 0
    ld [wSpawnCounter], a

    ld a, b
    ld [wNextCatXPosition], a

    ret


