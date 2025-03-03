NAME = emeralds

all: build

build:
	shards build --release --no-debug
	cp bin/emeralds bin/em

debug:
	shards build
	cp bin/emeralds bin/em

test:
	crystal spec ./spec/$(NAME).spec.cr

spec: test

document:
	$(RM) -r ./docs
	crystal docs src/*.cr

clean:
	$(RM) -r bin
