module kernel.main;
import core.stdc.stdio : printf;
import kernel.stdlib : clearScreen;

void huebr() {
	printf("huebr\n");
}

extern(C) void main(uint magic, uint addr) {
	clearScreen();
	huebr();
	for (;;) { //Loop forever. You can add your kernel logic here
	}
}
