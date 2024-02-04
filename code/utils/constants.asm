
DEF GROUND_LEVEL EQU 160

; Score
DEF SCORE_LAST_POSITION EQU $980C
DEF SCORE_SIZE EQU 8

; HP
DEF HP_LAST_POSITION EQU $9804

;OAM
DEF PLAYER_OAM EQU _OAMRAM ; todo: CHECK

; Sprites
DEF PLAYER_SPRITE_TILE EQU $00
DEF CAT_SPRITE_TILE EQU $02
DEF PIGEON_TILE EQU $04
DEF SHIT_TILE EQU $06

; Tiles
DEF TILE_FONT_0 EQU $00
DEF TILE_FONT_1 EQU $01
DEF TILE_BACKGROUND EQU $0A
DEF TILE_HEAD EQU $13 ; todo: not used

; Player
DEF PLAYER_MAX_LEFT EQU 8
DEF PLAYER_MAX_RIGHT EQU 144
DEF PLAYER_START_HP EQU 5

; Cat
DEF CATS_MAX_LEFT EQU 16 + 8
DEF CATS_MAX_RIGHT EQU 136 + 8
DEF CATS_BASE_SPEED EQU 1
DEF CATS_MAX_COUNT EQU 5
DEF CATS_SPAWN_DELAY EQU 50

; Cat struct
rsreset
DEF cat_active          RB 1
DEF cat_x_pos           RB 1
DEF cat_y_pos           RB 1
DEF CAT_BYTES_COUNT     RB 0

; Pigeon
DEF PIGEON_CURRENT_Y EQU 0
DEF PIGEON_SHIT_MAX_COUNT EQU 2
DEF PIGEON_SHIT_SPAWN_DELEY EQU 55
DEF PIGEON_SHIT_MAX_SPEED EQU 1

; Pigeon missile struct
rsreset
DEF active                          RB 1
DEF pos_x                           RB 1
DEF pos_y                           RB 1
DEF PER_PIGEON_MISSILE_BYTE_COUNT   RB 0
