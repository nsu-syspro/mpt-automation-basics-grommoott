.PHONY: all clean
NAME = $(shell jq -r .name config.json)
VERSION = $(shell jq -r .version config.json)
SOURCES = $(wildcard ./src/**.c)
CONFIG = config.json
TARGET = ./build/$(NAME)

INS = $(wildcard ./test/*.txt)
TESTS = $(INS:.txt=.test)
EXPECTEDS = $(TESTS:.txt=.expected)

all: $(TARGET)

check: $(TESTS)
	@echo "All tests passed"

$(TESTS): %.test: %.txt %.expected $(TARGET)
	@echo "Running $*..."
	@$(TARGET) < $*.txt > $*.output
	@diff $*.expected $*.output
	@rm $*.output

$(TARGET): $(SOURCES) $(CONFIG)
	mkdir -p build
	cc \
		-D NAME="\"$(NAME)\"" \
		-D VERSION="\"$(VERSION)\"" \
		-o $(TARGET) \
		$(SOURCES)

clean:
	rm -r build
