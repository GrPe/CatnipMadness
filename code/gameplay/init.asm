SECTION "Gameplay sprites tiles", ROM0

Player: incbin "bin/sprites/son.2bpp"
PlayerEnd:

Cat: incbin "bin/sprites/cat.2bpp"
CatEnd:

CatFall: incbin "bin/sprites/catFall.2bpp"
CatFallEnd:

Shit: incbin "bin/sprites/shit.2bpp"
ShitEnd:

Pigeon: incbin "bin/sprites/pigeon.2bpp"
PigeonEnd:

Somsiad: incbin "bin/sprites/somsiad.2bpp"
SomsiadEnd:

SECTION "Font tiles", rom0

Font: incbin "bin/fonts/font.2bpp"
FontEnd:

SECTION "Gameplay background tiles", ROM0

BlockTilemap: incbin "bin/backgrounds/blokTiles.tilemap"
BlockTilemapEnd:
	
BlockTileData: incbin "bin/backgrounds/blokTiles.2bpp"
BlockTileDataEnd:

section "Init gameplay state", rom0

InitGameState:
    ;;;;;;;;;;;;;;;;;;;;; COPY TILEMAP

	ld de, BlockTileData
	ld hl, $9000
	ld bc, BlockTileDataEnd - BlockTileData
	call MemCopy

	; Copy the tilemap
	ld de, BlockTilemap
	ld hl, $9800
	ld bc, BlockTilemapEnd - BlockTilemap
	call MemCopy
	
	;;;;;;;;;;;;;;;;;;;;;; COPY FONTS

	ld de, Font
	ld hl, $8800
	ld bc, FontEnd - Font
	call MemCopy

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

	; Copy the falling cat tiles
	ld de, CatFall
	ld hl, $8040
	ld bc, CatFallEnd - CatFall
	call MemCopy

	; Copy pigeon tiles
	ld de, Pigeon
	ld hl, $8060
	ld bc, PigeonEnd - Pigeon
	call MemCopy

	; Copy shit tiles
	ld de, Shit
	ld hl, $8080
	ld bc, ShitEnd - Shit
	call MemCopy

	; Copy somsiad tiles
	ld de, Somsiad
	ld hl, $80A0
	ld bc, SomsiadEnd - Somsiad
	call MemCopy
	
	; init

	call ClearSoftwareOam
    call SetupPlayer
	call InitCats
	call InitPigeon
	call SetupShit

    ret
