
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "require [[Test.More]]; print(Test.More._VERSION)")
TARBALL := lua-testmore-$(VERSION).tar.gz
ifndef REV
  REV   := 1
endif

ifndef DESTDIR
  DESTDIR := /usr/local
endif
BINDIR  := $(DESTDIR)/bin
LIBDIR  := $(DESTDIR)/share/lua/5.1

install:
	mkdir -p $(LIBDIR)/Test/Builder
	cp src/Test/More.lua            $(LIBDIR)/Test
	cp src/Test/Builder.lua         $(LIBDIR)/Test
	cp src/Test/Builder/Tester.lua  $(LIBDIR)/Test/Builder

uninstall:
	rm -f $(LIBDIR)/Test/More.lua
	rm -f $(LIBDIR)/Test/Builder.lua
	rm -f $(LIBDIR)/Test/Builder/Tester.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{/\.}; \
    next if m{^rockspec/}; \
    push @files, $$_; \
} \
print join qq{\n}, sort @files;

rockspec_pl := \
use strict; \
use warnings; \
use Digest::MD5; \
open my $$FH, q{<}, q{$(TARBALL)} \
    or die qq{Cannot open $(TARBALL) ($$!)}; \
binmode $$FH; \
my %config = ( \
    version => q{$(VERSION)}, \
    rev     => q{$(REV)}, \
    md5     => Digest::MD5->new->addfile($$FH)->hexdigest(), \
); \
close $$FH; \
while (<>) { \
    s{@(\w+)@}{$$config{$$1}}g; \
    print; \
}

version:
	@echo $(VERSION)

CHANGES:
	perl -i.bak -pe "s{^$(VERSION).*}{q{$(VERSION)  }.localtime()}e" CHANGES

tag:
	git tag -a -m 'tag release $(VERSION)' $(VERSION)

MANIFEST:
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-TestMore-$(VERSION) ] || ln -s . lua-TestMore-$(VERSION)
	perl -ne 'print qq{lua-TestMore-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-TestMore-$(VERSION)

dist: $(TARBALL)

rockspec: $(TARBALL)
	perl -e '$(rockspec_pl)' rockspec.in > rockspec/lua-testmore-$(VERSION)-$(REV).rockspec

check: test

test:
	cd src && prove --exec=$(LUA) ../test/*.t

coverage:
	rm -f src/luacov.stats.out src/luacov.report.out
	cd src && prove --exec="$(LUA) -lluacov" ../test/*.t
	cd src && luacov

html:
	xmllint --noout --valid doc/*.html

clean:
	rm -f MANIFEST *.bak

.PHONY: test rockspec CHANGES

