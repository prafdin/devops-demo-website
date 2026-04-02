FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y build-essential libcurl4-openssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY main.cpp .

RUN g++ -std=c++17 main.cpp -o server -lcurl

CMD ["./server"]