# Paths
OUTPUT_FILE_NAME	= game.gb

SOURCE		 		= graphics
SOURCETILEMAP		= $(SOURCE)/tilemaps
SOURCESPRITES		= $(SOURCE)/sprites
SOURCEFONTS		= $(SOURCE)/fonts

GEN					= bin
GENSPRITES			= $(GEN)/sprites
GENBACKGROUND		= $(GEN)/backgrounds
GENFONTS			= $(GEN)/fonts

BUILD_DIR			= output# for final game build

all: $(GENFONTS)/font.2bpp $(GENBACKGROUND)/blokTiles.tilemap src

$(GENFONTS)/font.2bpp: $(SOURCEFONTS)/font.png $(GENFONTS)
	rgbgfx $< -c "#FFFFFF,#cbcbcb,#414141,#000000" --columns -o $@

$(GENBACKGROUND)/blokTiles.tilemap: $(SOURCETILEMAP)/blokTiles.png | $(GENBACKGROUND)
	rgbgfx -c "#e0f8d0,#88c070,#346856,#081820;" \
		--unique-tiles \
		-o $(GENBACKGROUND)/blokTiles.2bpp \
		--tilemap $@ \
		$<

$(GENFONTS): $(GEN)
	mkdir -p $(GENFONTS)

$(GENBACKGROUND): $(GEN)
	mkdir -p $(GENBACKGROUND)

$(GEN):
	mdkir $(GEN)

# orange 
# 	rgbgfx $(SOURCESPRITES)/cat.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o $(GENSPRITES)/cat.2bpp
# 	rgbgfx $(SOURCESPRITES)/human.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o $(GENSPRITES)/human.2bpp
# 	rgbgfx $(SOURCESPRITES)/golob.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o $(GENSPRITES)/golob.2bpp
# 	rgbgfx $(SOURCESPRITES)/somsiad.png -c "#7f6a00,#7f3300,#7f0000,#000000" --columns -o $(GENSPRITES)/somsiad.2bpp

# # green 
# 	rgbgfx $(SOURCESPRITES)/head.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o $(GENSPRITES)/head.2bpp


src:
	rgbasm -L -o output/main.o code/main.asm --include code
	rgblink -o output/game.gb output/main.o
	rgblink -n output/game.sym output/main.o
	rgbfix -v -p 0xFF output/game.gb

clean:
	rm -rfv $(GEN)