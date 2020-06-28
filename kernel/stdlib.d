module kernel.stdlib;
import core.volatile;

const uint COLUMNS = 80; //Screensize
const uint LINES = 25;

extern(C) int printf (const char * format, ... ) {
  ubyte* vidmem = cast(ubyte*)0xFFFF_8000_000B_8000;
  int ypos = 0; //Starting points of the cursor
  int xpos = 0;
  volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2, 'D' & 0xFF); //Prints the letter D
  volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2 + 1, 0x07); //Sets the colour for D to be light grey (0x07)

  int pos = 0;

  while (true) {
    char c = format[pos];
    if (c == '\n') {
      ypos++;
      continue;
    }

    if (c == 0x00) {
      break;
    }

    volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2, c & 0xFF); //Prints the letter D
    volatileStore(vidmem + (xpos + ypos * COLUMNS) * 2 + 1, 0x07); //Sets the colour for D to be light grey (0x07)
    xpos++;
    pos++;
  }
  return pos;
}

void clearScreen() {
  ubyte* vidmem = cast(ubyte*)0xFFFF_8000_000B_8000;
  for (int i = 0; i < COLUMNS * LINES * 2; i++) { //Loops through the screen and clears it
      volatileStore(vidmem + i, 0);
  }
}