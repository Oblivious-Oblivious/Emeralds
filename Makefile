NAME = emeralds
INPUT = $(NAME).cr

all: build

remake_export:
	$(RM) -r export
	mkdir export

build: remake_export
	crystal build --release src/$(INPUT) -o export/em
	cp export/em export/emeralds

test:
	crystal spec ./spec/$(NAME).spec.cr
	$(RM) -r testapp

spec: test

document:
	$(RM) -r ./docs
	crystal docs src/*.cr

clean:
	$(RM) -r ./export
