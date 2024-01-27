test: 
	rgbasm -L -o output/main.o code/main.asm --include code
	rgblink -o output/game.gb output/main.o
	rgblink -n output/game.sym output/main.o
	rgbfix -v -p 0xFF output/game.gb
