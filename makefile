FLEX_SDK ?= /Users/lorimcdaniel/ApacheFlex

APP=game
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/*.hx

all: $(APP).swf

$(APP).swf: $(SOURCES)
	haxe \
		-cp src \
		-cp vendor \
		-swf-version 11.8 \
		-swf-header 960:520:60:ffffff \
		-main Startup \
		-swf $(APP).swf \
		-swf-lib vendor/starling.swc --macro "patchTypes('vendor/starling.patch')"

clean:
	rm -rf $(APP).swf

test: $(APP).swf
	$(ADL) -profile tv -screensize 960x520:960x520 $(APP_XML)


