
;GAME
DEF PLAYER_MAX_LEFT EQU 7
DEF PLAYER_MAX_RIGHT EQU 160
DEF CAT_MAX_LEFT EQU 16 + 8
DEF CAT_MAX_RIGHT EQU 136 + 8
DEF CAT_BASE_SPEED EQU 1
DEF GROUND_LEVEL EQU 144
DEF MAX_CAT_COUNT EQU 10
DEF MAX_CAT_SPAWN_DELAY EQU 30


;SPRITE TILES
DEF PLAYER_TILE EQU $00
DEF ENEMY_TILE EQU $01

;OAM
DEF PLAYER_OAM EQU _OAMRAM
DEF ENEMY_OAM EQU _OAMRAM + (4 * 10)


;Cat
rsreset
DEF cat_active          RB 1
DEF cat_x_pos           RB 1
DEF cat_y_pos           RB 1
DEF cat_speed           RB 1
DEF cat_state           RB 1
DEF PER_CAT_BYTES_COUNT RB 0
