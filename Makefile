RESOURCES:=https://unpkg.com/primer/build/build.css

UNAME_S := $(shell uname -s)
XARGS_ARGS:=-d '\n'
ifeq ($(UNAME_S),Darwin)
	XARGS_ARGS:=-0
endif

all:
	find . -name "* *" -type d -exec rename "s/\s/_/g" {} \; 2> /dev/null;:
	find . -not -path '*/\.*' -type d -links 2 -exec touch {}/demo.html \;
	find . -name "demo.html" -print0 | xargs $(XARGS_ARGS) python -m jsfiddle_generator
	find . -name "demo.details" -print0 | xargs $(XARGS_ARGS) grep -Z -L 'https://' | xargs -L 1 -I{} python -m jsfiddle.details.resources {} $(RESOURCES)
	find . -name "demo.html" -print0 | xargs $(XARGS_ARGS) python -m jsfiddle_build
	find . -name "demo.html" -print0 | xargs $(XARGS_ARGS) python -m jsfiddle_readme
	touch .
