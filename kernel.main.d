module kernel.main;
import kernel.stdlib : printf, clearScreen;
import std.format;
import std.stdio : writeln;

void huebr() {
	printf("Hello World from He4rtDevs!!\n");
	printf("ABCD\n");
	printf("INT: %d\n\n\n\n", 20);
	printf("huebr teste %d %x %o %q teste\nSECONDLINE: \n", -1337, 0xFF01, 504, "my quoted".ptr);
	printf("THIRDLINE\n");
	for (int i = 0; i < 18; i++) {
		printf("LINE %d\n", i);
	}
}

extern(C) void main(uint magic, uint addr) {
	clearScreen();
	huebr();
	for (;;) { //Loop forever. You can add your kernel logic here
	}
}
