ROOT := $(shell pwd)

# The default is to download the official release binary
# for x86_64-unknown-linux-gnu. If that default is unsuitable,
# build your own binary and copy or symlink it here, or
# override the variable with "make MDBOOK_BINARY=...".
MDBOOK_BINARY = $(ROOT)/mdbook

# The architecture can be changed. Only Linux .tar.gz files
# are currently supported, though. See https://github.com/rust-lang-nursery/mdBook/releases
# for available architectures.
MDBOOK_ARCH = x86_64-unknown-linux-gnu

# The mdbook version.
MDBOOK_RELEASE = v0.2.1

# Download URL for mdbook and resulting file.
MDBOOK_FILE = mdbook-$(MDBOOK_RELEASE)-$(MDBOOK_ARCH).tar.gz
MDBOOK_URL = https://github.com/rust-lang-nursery/mdBook/releases/download/$(MDBOOK_RELEASE)/$(MDBOOK_FILE)

# As an extra sanity check, the hash of the downloaded file must match before it is used.
MDBOOK_SHA1 = 5da8d46d09df02d6a671dfbbde20ea85811edbaf

all: $(MDBOOK_BINARY)
	cd book && $(MDBOOK_BINARY) build

clean:
	rm -rf docs mdbook-*.tar.gz

clobber: clean
	rm -f mdbook

# Start mdbook as web server.
MDBOOK_HOSTNAME = localhost
MDBOOK_PORT = 3000
serve:
	cd book && $(MDBOOK_BINARY) serve --hostname $(MDBOOK_HOSTNAME) --port $(MDBOOK_PORT)

$(MDBOOK_BINARY): $(MDBOOK_FILE)
	if [ "`sha1sum < $(MDBOOK_FILE) | sed -e 's/ *-$$//'`" != $(MDBOOK_SHA1) ]; then \
		echo "ERROR: hash mismatch, check downloaded file $(MDBOOK_FILE) and/or update MDBOOK_SHA1"; \
		exit 1; \
	fi
	tar xf $(MDBOOK_FILE)
	touch $@

$(MDBOOK_FILE):
	curl -L -O $(MDBOOK_URL)

.PHONY: all clean clobber serve
