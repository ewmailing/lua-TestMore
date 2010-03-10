
LUAJIT = luajit
LLVM_LUA = llvm-lua
LUA = lua
LUA_COVER = ../doc/lua-5.1.4/src/lua

LUA_VERSION = $(shell $(LUA) -e "print(_VERSION)")
OSNAME = $(shell perl -MConfig -e "print Config->{osname}")
ARCHNAME = $(shell perl -MConfig -e "print Config->{archname}")
INTSIZE = $(shell perl -MConfig -e "print Config->{intsize}")

export LUA_PATH=;;../src/?.lua
export LUA_INIT=platform = { lua=[[$(LUA)]], osname=[[$(OSNAME)]], intsize=$(INTSIZE) }

harness:
	prove --exec=$(LUA) *.t

sanity:
	prove --exec=$(LUA) 0*.t

luajit:
	prove --exec=$(LUAJIT) *.t

llvm-lua:
	prove --exec=$(LLVM_LUA) *.t

cover:
	prove --exec=$(LUA_COVER) *.t

upload_pl = \
use strict; \
use warnings; \
use LWP::UserAgent; \
my $$ua = LWP::UserAgent->new(); \
$$ua->env_proxy(); \
my $$server = q{http://smolder.plusthree.com}; \
my $$project_id = 12; \
my $$url = $$server . q{/app/projects/process_add_report/} . $$project_id; \
my $$response = $$ua->post( \
    $$url, \
    Content_Type => q{form-data}, \
    Content      => [ \
        architecture => q{$(ARCHNAME)}, \
        platform     => q{$(OSNAME)}, \
        tags         => q{$(OSNAME), $(ARCHNAME), $(LUA), $(LUA_VERSION)}, \
        comments     => q{$(LUA)}, \
        project_id   => $$project_id, \
        report_file  => [q{test_lua51.tar.gz}], \
        ] \
); \
if ($$response->code == 302) { \
    my ($$report_id) = $$response->content =~ /Reported .(\d+) added/i; \
    my $$report_url = $$server . q{/app/projects/report_details/} . $$report_id; \
    my $$project_url = $$server . q{/app/projects/smoke_reports/} . $$project_id; \
    print qq{Test report successfully sent to Smolder at\n$$report_url} \
      . qq{\nYou can see other recent reports at\n$$project_url .\n\n}; \
} \
else { \
    die qq{Could not upload report to Smolder at $$server} \
      . qq{\nHTTP CODE: } . $$response->code . q{ (} \
      . $$response->message . qq{)\n}; \
}

smolder:
	-prove --archive test_lua51.tar.gz --exec=$(LUA) *.t
	perl -e '$(upload_pl)'
