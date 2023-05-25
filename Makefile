# Makefile

# ビルドに使用するコンパイラとオプションを指定します
CC = iverilog
CFLAGS = -Wall

# srcディレクトリ内のすべてのVerilogファイルを取得します
SRCS := $(wildcard src/*.v)

# benchファイルを指定します
BENCH = bench/bench.v

# ターゲットとなる実行可能ファイルを指定します
TARGET = my_design.o

all: $(TARGET)

$(TARGET): $(SRCS) $(BENCH)
	$(CC) $(CFLAGS) -o $@ $(SRCS) $(BENCH)
	vvp $(TARGET)

clean:
	rm -f $(TARGET)
	rm -f sim_result.vcd