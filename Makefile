#MODE = run
#MODE = build
#MODE = spec
#MODE = init

INPUT = src/emerald.c

CC = clang
OPT = -O2
VERSION = -std=c11
OUTPUT = emerald

FLAGS = -Wall -Wextra -Werror -pedantic -pedantic-errors -Wpedantic
WARNINGS = -Wno-incompatible-pointer-types -Wno-int-conversion -Wno-macro-redefined
UNUSED_WARNINGS = -Wno-unused-parameter -Wno-unused-variable -Wno-unused-function -Wno-extra-semi
REMOVE_WARNNINGS =
HEADERS =
LIBS =

TESTFILES = sources/emerald/string.c \
			sources/emerald/vector.c \
			sources/emerald/read_handler.c \
			sources/emerald/write_handler.c

TESTINPUT = emerald.spec.c
TESTOUTPUT = specs_results

all: default

default:
	$(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(OUTPUT) $(INPUT)
	$(RM) -r export && mkdir export
	mv $(OUTPUT) export/
	./export/$(OUTPUT)

run: default

build: default

test:
	mkdir spec/sources && cp -R src/* spec/sources/
	cd spec && $(CC) $(OPT) $(VERSION) $(HEADERS) $(FLAGS) $(WARNINGS) $(REMOVE_WARNINGS) $(UNUSED_WARNINGS) $(LIBS) -o $(TESTOUTPUT) $(TESTFILES) $(TESTINPUT)
	@echo
	./spec/$(TESTOUTPUT)
	$(RM) -r $(TESTOUTPUT)

spec: test

clean:
	$(RM) -r spec/$(TESTOUTPUT)
	$(RM) -r spec/sources
	$(RM) -r export

