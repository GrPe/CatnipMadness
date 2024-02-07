SECTION "Gameplay sprites tiles", ROM0

Player: incbin "bin/human.2bpp"
PlayerEnd:

Cat: incbin "bin/cat.2bpp"
CatEnd:

Pigeon: incbin "bin/golob.2bpp"
PigeonEnd:

Shit: incbin "bin/shit.2bpp"
ShitEnd:

Head: incbin "bin/head.2bpp"
HeadEnd:

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
	
	; init

	call ClearSoftwareOam
    call SetupPlayer
	call InitCats
	call InitPigeon
	call SetupShit

    ret
