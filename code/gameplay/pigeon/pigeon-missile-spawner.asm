section "Pigeon missile spawner", rom0

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


