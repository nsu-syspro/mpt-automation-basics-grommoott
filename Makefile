.PHONY: all clean check
NAME = $(shell jq -r .name config.json)
VERSION = $(shell jq -r .version config.json)
SOURCES = $(wildcard ./src/**.c)
CONFIG = config.json
TARGET = ./build/$(NAME)

INS = $(wildcard ./test/*.txt)
TESTS = $(INS:./test/%.txt=./test/%.test)
EXPECTEDS = $(TESTS:.txt=.expected)

all: $(TARGET)

check: $(TARGET) $(TESTS)
	@echo ""

$(TESTS): ./%.test: ./%.txt ./%.expected $(TARGET)
	@$(TARGET) < ./$*.txt | diff -u ./$*.expected -

$(TARGET): $(SOURCES) $(CONFIG)
	@mkdir -p build
	@cc \
		-D NAME="\"$(NAME)\"" \
		-D VERSION="\"$(VERSION)\"" \
		-o $(TARGET) \
		$(SOURCES)

clean:
	@rm -r build
