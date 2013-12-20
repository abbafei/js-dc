BC_VERSION = 1.06
BC_SRC_DIR = src/bc-$(BC_VERSION)/

BC_DLFILE = dl/dc.tar.gz
CFLAGS = -O2 -s ASM_JS=0
EMCC_CFLAGS = --pre-js code/dc_cmdline-pre.js --post-js code/dc_cmdline-post.js $(CFLAGS) 


all: dl build

distclean: clean-dl clean

build: src bin
clean: clean-src clean-bin

dl:
	mkdir $@
	wget -O $(BC_DLFILE) 'http://ftpmirror.gnu.org/bc/bc-$(BC_VERSION).tar.gz'
src:
	mkdir $@
	tar -C src -xvzf $(BC_DLFILE)
	patch -d $(BC_SRC_DIR) -p1 < patch_src.patch
	(export AM_CFLAGS="$(CFLAGS)"; cd $(BC_SRC_DIR); autoreconf -i; emconfigure ./configure; make)
	ln -s dc $(BC_SRC_DIR)/dc/dc.bc
bin:
	mkdir $@
	emcc $(EMCC_CFLAGS) $(BC_SRC_DIR)/dc/dc.bc -o $@/dc.js

clean-dl:
	if [ -d "dl" ]; then rm -rv dl; fi
clean-src:
	if [ -d "src" ]; then rm -rv src; fi
clean-bin:
	if [ -d "bin" ]; then rm -rv bin; fi
