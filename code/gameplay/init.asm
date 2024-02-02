section "Init", rom0

InitGameState:
    ;;;;;;;;;;;;;;;;;;;;; COPY TILES

	ld de, Font
	ld hl, $9000
	ld bc, FontEnd - Font
	call MemCopy

	; Copy the tile data
	ld de, Tiles
	ld hl, $90A0
	ld bc, TilesEnd - Tiles
	call MemCopy

	; Copy walls
	ld de, WallLeft
	ld hl, $90B0
	ld bc, WallLeftEnd - WallLeft
	call MemCopy

	; Copy walls
	ld de, WallRight
	ld hl, $90D0
	ld bc, WallRightEnd - WallRight
	call MemCopy

	; Copy roof
	ld de, Roof
	ld hl, $90F0
	ld bc, RoofEnd - Roof
	call MemCopy

	; Copy ground
	ld de, Ground
	ld hl, $9120
	ld bc, GroundEnd - Ground
	call MemCopy

	; Copy head
	ld de, Head
	ld hl, $9130
	ld bc, HeadEnd - Head
	call MemCopy

	; Copy Window
	ld de, Window
	ld hl, $9140
	ld bc, WindowEnd - Window
	call MemCopy

	; Copy Brick
	ld de, Bricks
	ld hl, $9180
	ld bc, BricksEnd - Bricks
	call MemCopy

	; Copy Brick
	ld de, Somsiad
	ld hl, $91C0
	ld bc, SomsiadEnd - Somsiad
	call MemCopy

	;;;;;;;;;;;;;;;;;;;;;; COPY TILES END
	;;;;;;;;;;;;;;;;;;;;;; COPY TILEMAP

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
	call MemCopy
	
	;;;;;;;;;;;;;;;;;;;;;; COPY TILEMAP END
	;;;;;;;;;;;;;;;;;;;;;; COPY SPRITES

	; Copy the tile data
	ld de, Player
	ld hl, $8000
	ld bc, PlayerEnd - Player
	call MemCopy

	; Copy the cat tiles
	ld de, Cat
	ld hl, $8020
	ld bc, CatEnd - Cat
	call MemCopy

	; Copy pigeon tiles
	ld de, Pigeon
	ld hl, $8040
	ld bc, PigeonEnd - Pigeon
	call MemCopy

	; Copy pigeon tiles
	ld de, Shit
	ld hl, $8060
	ld bc, ShitEnd - Shit
	call MemCopy
	
	;;;;;;;;;;;;;;;;;;;;;; COPY SPRITES END

	; some init setup

	call ClearSoftwareOam
    call SetupPlayer
	call SetupEnemies
	call InitPigeon
	call SetupShit

    ret
