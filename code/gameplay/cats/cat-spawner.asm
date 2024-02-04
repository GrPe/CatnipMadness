section "Cat spawner", rom0

TryToSpawnCat:

    ; increase spawn counter
    ld a, [wCatsSpawnCounter]
    inc a
    ld [wCatsSpawnCounter], a

    ; if it's no time, ret
    ld a, [wCatsSpawnCounter]
    cp a, CATS_SPAWN_DELAY
    ret c

    ; 
    ld a, [wCatsNextCatXPosition]
    cp a, 0
    ret nz

    ; check if we hit cat limit
    ld a, [wCatsActiveCatCounter]
    cp a, CATS_MAX_COUNT
    ret nc

.getSpawnPosition:
    
    call rand

    ; too much right
    ld a, b
    cp CATS_MAX_RIGHT
    ret nc

    ; too much left
    ld a, b
    cp a, CATS_MAX_LEFT
    ret c

    ; reset spawn counter
    ld a, 0
    ld [wCatsSpawnCounter], a

    ld a, b
    ld [wCatsNextCatXPosition], a

    ret