SECTION "Tile data", ROM0

Tiles:
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
	dw `00000000
TilesEnd:

Player: incbin "bin/human.2bpp"
PlayerEnd:

Cat: incbin "bin/cat.2bpp"
CatEnd:

Pigeon: incbin "bin/golob.2bpp"
PigeonEnd:

Shit: incbin "bin/shit.2bpp"
ShitEnd:

WallLeft: incbin "bin/thesciana_left.2bpp"
WallLeftEnd:

WallRight: incbin "bin/thesciana_right.2bpp"
WallRightEnd:

Font: incbin "bin/font.2bpp"
FontEnd:

Roof: incbin "bin/roof.2bpp"
RoofEnd:

Ground: incbin "bin/ground.2bpp"
GroundEnd:

Head: incbin "bin/head.2bpp"
HeadEnd:

Window: incbin "bin/window.2bpp"
WindowEnd:

Bricks: incbin "bin/cegla.2bpp"
BricksEnd:

Somsiad: incbin "bin/somsiad.2bpp"
SomsiadEnd:

SECTION "Tilemap", ROM0

Tilemap:
	db $13, $13, $13, $13, $13, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0F, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $11,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $1C, $1F, $22, $25, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $14, $16, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $1D, $20, $23, $26, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $15, $17, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $1E, $21, $24, $27, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $0A, $0A, $0A, $18, $1A, $18, $1A, $0A, $0A, $0A, $14, $16, $0A, $0A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $0A, $0A, $0A, $19, $1B, $19, $1B, $0A, $0A, $0A, $15, $17, $0A, $0A, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $14, $16, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $18, $1A, $18, $1A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $15, $17, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $19, $1B, $19, $1B, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0C, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0E,  0,0,0,0,0,0,0,0,0,0,0,0
	db $0B, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $12, $0D,  0,0,0,0,0,0,0,0,0,0,0,0
TilemapEnd:
