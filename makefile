FLEX_SDK ?= C:/Flex

APP=game
APP_XML=$(APP).xml
ADL=$(FLEX_SDK)/bin/adl
AMXMLC=$(FLEX_SDK)/bin/amxmlc
SOURCES=src/*.hx

all: $(APP).swf

$(APP).swf: $(SOURCES) assets/Tiles/map.tmx
	haxe \
		-cp src \
		-cp vendor \
		-swf-version 11.8 \
		-swf-header 1280:704:60:ffffff \
		-main Startup \
		-swf $(APP).swf \
		-swf-lib vendor/starling_1_6.swc --macro "patchTypes('vendor/starling.patch')" \
		-resource assets/Tiles/map.tmx@"map"

clean:
	rm -rf $(APP).swf

test: $(APP).swf
	$(ADL) -profile tv -screensize 1280x704:1280x704 $(APP_XML)


