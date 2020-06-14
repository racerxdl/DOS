module kernel.main;
import core.bitop; // will be core.volatile in later gdc
 
extern(C) void main(uint magic, uint addr) {
    int ypos = 0; //Starting points of the cursor
	int xpos = 0;
	const uint COLUMNS = 80; //Screensize
	const uint LINES = 25;
 
	ubyte* vidmem = cast(ubyte*)0xFFFF_8000_000B_8000; //Video memory address
 
	for (int i = 0; i < COLUMNS * LINES * 2; i++) { //Loops through the screen and clears it
			volatileStore(vidmem + i, 0);
	}
 
	volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2, 'D' & 0xFF); //Prints the letter D
	volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2 + 1, 0x07); //Sets the colour for D to be light grey (0x07)
 
	for (;;) { //Loop forever. You can add your kernel logic here
	}
}
