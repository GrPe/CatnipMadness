section "Gameplay", rom0

InitGameState:
    ;;;;;;;;;;;;;;;;;;;;; COPY TILES

	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
	call MemCopy

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, TilemapEnd - Tilemap
	call MemCopy

	; Copy the tile data
	ld de, Paddle
	ld hl, $8000
	ld bc, PaddleEnd - Paddle
	call MemCopy

	; Copy the cat tiles
	ld de, Cat
	ld hl, $8010
	ld bc, CatEnd - Cat
	call MemCopy

	;;;;;;;;;;;;;;;;;;;;;; COPY TILES END

    call ClearOam	
    call SetupPlayer
	call SetupEnemies

    ret