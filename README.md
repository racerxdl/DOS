# DOS
D Operating System - Just because HUEBR


# Compiling with Docker

```bash
make docker
```

# Compiling on MacOSX

```bash
brew install FiloSottile/musl-cross/musl-cross nasm ldc
make LD=x86_64-linux-musl-ld
```

# Compiling on Windows
```bash
choco install nasm ldc
make NASM=/path/to/nasm LD=/path/to/LD
```

# Compiling on Linux

```bash
make
```
