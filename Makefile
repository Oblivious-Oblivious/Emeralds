INPUT = emeralds.cr

all:
	crystal src/$(INPUT)

remake_bin:
	$(RM) -r bin
	mkdir bin

build: remake_bin
	crystal build --release src/$(INPUT) -o bin/em
	cp bin/em bin/emeralds

run:
	./bin/em

document:
	$(RM) -r ./docs
	crystal docs src/*.cr

clean:
	$(RM) -r ./bin
