all: clean compile

clean:
	./node_modules/.bin/grunt clean

compile:
	./node_modules/.bin/grunt compile

test: all
	./node_modules/.bin/grunt test

.PHONY: test