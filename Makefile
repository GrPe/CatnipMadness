# Paths
BUILD_DIR			= output
GAMEFILE			= game.gb
BUILD				= $(BUILD_DIR)/$(GAMEFILE)

SOURCE		 		= graphics
SOURCETILEMAP		= $(SOURCE)/tilemaps
SOURCESPRITES		= $(SOURCE)/sprites
SOURCEFONTS			= $(SOURCE)/fonts

GEN					= bin
GENSPRITES			= $(GEN)/sprites
GENBACKGROUND		= $(GEN)/backgrounds
GENFONTS			= $(GEN)/fonts


NEEDED_GRAPHICS = \
	$(GENSPRITES)/cat.2bpp \
	$(GENSPRITES)/catFall.2bpp \
	$(GENSPRITES)/somsiad.2bpp \
	$(GENSPRITES)/pigeon.2bpp \
	$(GENSPRITES)/son.2bpp \
	$(GENSPRITES)/shit.2bpp \
	$(GENFONTS)/font.2bpp \
	$(GENBACKGROUND)/head.2bpp \
	$(GENBACKGROUND)/blokTiles.tilemap

all: $(NEEDED_GRAPHICS) $(BUILD)

$(GENSPRITES)/cat.2bpp: $(SOURCESPRITES)/cat.png | $(GENSPRITES)
	rgbgfx -c "#ffffff,#88c070,#346856,#081820;" --columns -o $@ $<

$(GENSPRITES)/catFall.2bpp: $(SOURCESPRITES)/catFall.png | $(GENSPRITES)
	rgbgfx -c "#e0f8d0,#88c070,#346856,#081820;" --columns -o $@ $<

$(GENSPRITES)/somsiad.2bpp: $(SOURCESPRITES)/somsiad.png | $(GENSPRITES)
	rgbgfx -c "#ffffff,#e0f8d0,#88c070,#346856;" --columns -o $@ $<

$(GENSPRITES)/pigeon.2bpp: $(SOURCESPRITES)/pigeon.png | $(GENSPRITES)
	rgbgfx -c "#ffffff,#346856,#e0f8d0,#88c070;" --columns -o $@ $<

$(GENSPRITES)/son.2bpp: $(SOURCESPRITES)/son.png | $(GENSPRITES)
	rgbgfx -c "#ffffff,#88c070,#346856,#081820;" --columns -o $@ $<

$(GENSPRITES)/shit.2bpp: $(SOURCESPRITES)/shit.png | $(GENSPRITES)
	rgbgfx -c "#e0f8d0,#88c070,#346856,#081820;" --columns -o $@ $<

$(GENFONTS)/font.2bpp: $(SOURCEFONTS)/font.png | $(GENFONTS)
	rgbgfx -c "#FFFFFF,#cbcbcb,#414141,#000000" --columns -o $@ $<

$(GENBACKGROUND)/head.2bpp: $(SOURCETILEMAP)/head.png | $(GENBACKGROUND)
	rgbgfx -c "#e0f8d0,#88c070,#346856,#081820;" --columns -o $@ $<

$(GENBACKGROUND)/blokTiles.tilemap: $(SOURCETILEMAP)/blokTiles.png | $(GENBACKGROUND)
	rgbgfx -c "#e0f8d0,#88c070,#346856,#081820;" \
		--unique-tiles \
		-o $(GENBACKGROUND)/blokTiles.2bpp \
		--tilemap $@ \
		$<

$(GENSPRITES): $(GEN)
	mkdir -p $(GENSPRITES)

$(GENFONTS): $(GEN)
	mkdir -p $(GENFONTS)

$(GENBACKGROUND): $(GEN)
	mkdir -p $(GENBACKGROUND)

$(GEN):
	mkdir $(GEN)

$(BUILD): $(BUILD_DIR)
	rgbasm -L -o $(BUILD_DIR)/main.o code/main.asm --include code
	rgblink -o $(BUILD) $(BUILD_DIR)/main.o
	rgblink -n $(BUILD_DIR)/game.sym $(BUILD_DIR)/main.o
	rgbfix -v -p 0xFF $(BUILD)
.PHONY: $(BUILD)

$(BUILD_DIR):
	mkdir $(BUILD_DIR)

clean:
	rm -rfv $(GEN)
	rm -rfv $(BUILD_DIR)
.PHONY: clean