section "Pigeon missile spawner", rom0

TryToSpawnMissile:
    ; increase spawn counter
    ld a, [wPigeonMissileSpawnCounter]
    inc a
    ld [wPigeonMissileSpawnCounter], a

    ; if it's no time, ret
    ld a, [wPigeonMissileSpawnCounter]
    cp a, PIGEON_SHIT_SPAWN_DELEY
    ret c

    ; 
    ld a, [wPigeonNextMissileXPosition]
    cp a, 0
    ret nz

    ; check if we hit cat limit
    ld a, [wPigeonActiveMissileCounter]
    cp a, PIGEON_SHIT_MAX_COUNT
    ret nc

    ; reset spawn counter
    ld a, 0
    ld [wPigeonMissileSpawnCounter], a

    ld a, [wPigeonCurrentX]
    ld [wPigeonNextMissileXPosition], a

    ret


