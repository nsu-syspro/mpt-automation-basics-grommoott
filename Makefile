.PHONY: all clean check
NAME = $(shell jq -r .name config.json)
VERSION = $(shell jq -r .version config.json)
SOURCES = $(wildcard ./src/**.c)
CONFIG = config.json
TARGET = ./build/$(NAME)

INS = $(wildcard ./test/*.txt)
TESTS = $(INS:./test/%.txt=./build/test/%.test)
EXPECTEDS = $(TESTS:.txt=.expected)

all: $(TARGET)

check: $(TARGET) $(TESTS)
	@echo ""

$(TESTS): ./build/test/%.test: ./test/%.txt ./test/%.expected $(TARGET)
	@echo "Running $*..."
	@$(TARGET) < ./test/$*.txt > ./test/$*.output
	@diff ./test/$*.expected ./test/$*.output
	@rm ./test/$*.output
	@mkdir -p build/test
	@touch $@

$(TARGET): $(SOURCES) $(CONFIG)
	@mkdir -p build
	@cc \
		-D NAME="\"$(NAME)\"" \
		-D VERSION="\"$(VERSION)\"" \
		-o $(TARGET) \
		$(SOURCES)

clean:
	@rm -r build
