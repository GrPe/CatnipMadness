src: 
	rgbgfx graphics/cat.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o graphics/cat.2bpp
	rgbgfx graphics/human.png -c "#7f6a00,#ff6a00,#000000,#7f3300" --columns -o graphics/human.2bpp
	rgbgfx graphics/font.png -c "#FFFFFF,#cbcbcb,#414141,#000000" --columns -o graphics/font.2bpp

	rgbasm -L -o output/main.o code/main.asm --include code
	rgblink -o output/game.gb output/main.o
	rgblink -n output/game.sym output/main.o
	rgbfix -v -p 0xFF output/game.gb
