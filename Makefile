
LUA     := lua
VERSION := $(shell cd src && $(LUA) -e "m = require [[Test.More]]; print(m._VERSION)")
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
	mkdir -p $(LIBDIR)/Test/Builder/Tester
	cp src/Test/More.lua                    $(LIBDIR)/Test
	cp src/Test/Builder.lua                 $(LIBDIR)/Test
	cp src/Test/Builder/Tester.lua          $(LIBDIR)/Test/Builder
	cp src/Test/Builder/Tester/File.lua     $(LIBDIR)/Test/Builder/Tester

uninstall:
	rm -f $(LIBDIR)/Test/More.lua
	rm -f $(LIBDIR)/Test/Builder.lua
	rm -f $(LIBDIR)/Test/Builder/Tester.lua
	rm -f $(LIBDIR)/Test/Builder/Tester/File.lua

manifest_pl := \
use strict; \
use warnings; \
my @files = qw{MANIFEST}; \
while (<>) { \
    chomp; \
    next if m{^\.}; \
    next if m{/\.}; \
    next if m{^doc/\.}; \
    next if m{^doc/cover}; \
    next if m{^doc/google}; \
    next if m{^doc/lua}; \
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

doc:
	git read-tree --prefix=doc/ -u remotes/origin/gh-pages

MANIFEST: doc
	git ls-files | perl -e '$(manifest_pl)' > MANIFEST

$(TARBALL): MANIFEST
	[ -d lua-TestMore-$(VERSION) ] || ln -s . lua-TestMore-$(VERSION)
	perl -ne 'print qq{lua-TestMore-$(VERSION)/$$_};' MANIFEST | \
	    tar -zc -T - -f $(TARBALL)
	rm lua-TestMore-$(VERSION)
	rm -rf doc
	git rm doc/*

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

README.html: README.md
	Markdown.pl README.md > README.html

clean:
	rm -rf doc
	rm -f MANIFEST *.bak src/luacov.*.out README.html

.PHONY: test rockspec CHANGES

