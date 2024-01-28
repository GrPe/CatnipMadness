all: bin output graphs src

bin:
	mdkir bin

output:
	mkdir output

graphs:
# orange 
	rgbgfx graphics/cat.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o bin/cat.2bpp
	rgbgfx graphics/human.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o bin/human.2bpp
	rgbgfx graphics/golob.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o bin/golob.2bpp
	rgbgfx graphics/somsiad.png -c "#7f6a00,#7f3300,#7f0000,#000000" --columns -o bin/somsiad.2bpp

# fonts
	rgbgfx graphics/font.png -c "#FFFFFF,#cbcbcb,#414141,#000000" --columns -o bin/font.2bpp

# green 
	rgbgfx graphics/thesciana_left.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/thesciana_left.2bpp
	rgbgfx graphics/thesciana_right.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/thesciana_right.2bpp
	rgbgfx graphics/roof.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/roof.2bpp
	rgbgfx graphics/ground.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/ground.2bpp
	rgbgfx graphics/shit.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/shit.2bpp
	rgbgfx graphics/head.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/head.2bpp
	rgbgfx graphics/window.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/window.2bpp
	rgbgfx graphics/cegla.png -c "#9bbc0f,#8bac0f,#306230,#0f380f" --columns -o bin/cegla.2bpp

src:	
	rgbasm -L -o output/main.o code/main.asm --include code
	rgblink -o output/game.gb output/main.o
	rgblink -n output/game.sym output/main.o
	rgbfix -v -p 0xFF output/game.gb
