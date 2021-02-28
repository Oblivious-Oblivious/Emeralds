INPUT = emeralds.cr

all:
	crystal src/$(INPUT)

remake_export:
	$(RM) -r export
	mkdir export

build: remake_export
	crystal build --release src/$(INPUT) -o export/em
	cp export/em export/emeralds

document:
	$(RM) -r ./docs
	crystal docs src/*.cr

clean:
	$(RM) -r ./export
