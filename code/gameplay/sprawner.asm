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

TryToMakeShit:
    ; increase spawn counter
    ld a, [wPigeonSpawnCounter]
    inc a
    ld [wPigeonSpawnCounter], a

    ; if it's no time, ret
    ld a, [wPigeonSpawnCounter]
    cp a, PIGEON_SHIT_SPAWN_DELEY
    ret c

    ; 
    ld a, [wNextShitXPosition]
    cp a, 0
    ret nz

    ; check if we hit cat limit
    ld a, [wActivePigeonCounter]
    cp a, PIGEON_SHIT_MAX_COUNT
    ret nc

    ; reset spawn counter
    ld a, 0
    ld [wPigeonSpawnCounter], a

    ld a, [wPigeonCurrentX]
    ld [wNextShitXPosition], a

    ret


