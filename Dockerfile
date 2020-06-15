FROM ubuntu:focal

RUN apt-get update -y && apt install -y build-essential ldc nasm

RUN rm -rf /var/lib/apt/lists/*

WORKDIR /tmp
CMD ["/bin/bash"]
