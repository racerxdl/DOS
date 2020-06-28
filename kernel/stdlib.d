module kernel.stdlib;
import core.volatile;
import core.vararg;

enum VBIOS_TERMINAL = 0xB8000;

const uint COLUMNS = 80;
const uint LINES = 25;
const uint LINE_BYTES = COLUMNS * 2;
const uint TOTAL_BUFFER_LINES = LINES * LINE_BYTES;

__gshared int __ypos = 0;
__gshared int __xpos = 0;

@trusted extern(C) void printIntOnBase(const int inval, const int base) {
  char[256] buff;

  int val = inval;

  if (val < 0) {
    putc('-');
    val = -val;
  }

  if (val == 0) {
    putc('0');
    return;
  }

  int numcases = 0;

  while (val > 0) {
    int t = val % base;
    if (t > 9) {
      t -= 10;
      buff[numcases++] = cast(char)('A' + t);
    } else {
      buff[numcases++] = cast(char)('0' + t);
    }
    val /= base;
  }

  int n = 0;
  while (numcases > 0) {
    char c = buff[--numcases];
    putc(c);
  }
}

@trusted extern(C) void shiftBufferOneLineIfNeeded() {
  if (__ypos >= LINES) {
    ubyte* vidmem = cast(ubyte*)VBIOS_TERMINAL;
    for (int i = LINE_BYTES; i < TOTAL_BUFFER_LINES; i++) {
      volatileStore(vidmem + i - LINE_BYTES, volatileLoad(vidmem + i));
    }
    __ypos--;
      for (int i = TOTAL_BUFFER_LINES - LINE_BYTES; i < TOTAL_BUFFER_LINES; i++) {
      volatileStore(vidmem + i, 0x00);
    }
  }
}

@trusted extern(C) void putc(const char c) {
  ubyte* vidmem = cast(ubyte*)VBIOS_TERMINAL;

  if (c == '\n') {
    __ypos++;
    __xpos = 0;
    shiftBufferOneLineIfNeeded();
    return;
  }

  volatileStore(vidmem + (__xpos + __ypos * COLUMNS) * 2, c & 0xFF); //Prints the letter D
  volatileStore(vidmem + (__xpos + __ypos * COLUMNS) * 2 + 1, 0x07); //Sets the colour for D to be light grey (0x07)

  __xpos++;
  if (__xpos==COLUMNS) {
    __xpos = 0;
    __ypos++;
    shiftBufferOneLineIfNeeded();
  }
}

extern(C) void __assert(const(char)* __file, const char* __msg,  int __line) {
  //printf("%s: %d %s\n", __file, __line, __msg);
}

@trusted extern(C) void * memset (void *ptr, int value, size_t num ) {
  char *cptr = cast(char*)ptr;

  while (num > 0) {
    cptr[--num] = cast(char)(value & 0xFF);
  }
  return ptr;
}

extern(C) int printf(const char * sformat, ... ) {
  ubyte* vidmem = cast(ubyte*)VBIOS_TERMINAL;
  int pos  = 0;
  string tmp;
  va_list args;
  va_start(args, sformat);

  while (true) {
    char c = sformat[pos++];
    if (c == '%') {
      c = sformat[pos++];

      switch (c) {
        case 'd':
          int val = va_arg!int(args);
          printIntOnBase(val, 10);
          break;
        case 'o':
          int val = va_arg!int(args);
          printIntOnBase(val, 8);
          break;
        case 'x':
        case 'X':
          int val = va_arg!int(args);
          printIntOnBase(val, 16);
          break;
        case 's':
          const char* val = va_arg!(const char*)(args);
          int n = 0;
          while (true) {
            c = val[n++];
            if (c == 0x00) {
              break;
            }
            putc(c);
          }
          break;
        case 'q':
          const char* val = va_arg!(const char*)(args);
          int n = 0;
          putc('"');
          while (true) {
            c = val[n++];
            if (c == 0x00) {
              break;
            }
            putc(c);
          }
          putc('"');
          break;
        default:
          int val = va_arg!int(args);
          const char *m = "UNKNOWN FORMAT(".ptr;
          int n = 0;
          while (true) {
            char d = m[n++];
            if (d == 0x00) {
              break;
            }
            putc(d);
          }
          putc(c);
          putc(')');
      }

      continue;
    }

    if (c == 0x00) {
      break;
    }

    putc(c);
  }

  return pos;
}

void clearScreen() {
  ubyte* vidmem = cast(ubyte*)VBIOS_TERMINAL;
  for (int i = 0; i < COLUMNS * LINES * 2; i++) { //Loops through the screen and clears it
      volatileStore(vidmem + i, 0);
  }
}