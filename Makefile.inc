.ifdef V6EVALROOT
PREFIX?=$(V6EVALROOT)
.else
PREFIX?=/usr/local/v6eval
.endif

.ifndef AUTORUN
AUTORUN = $(PREFIX)/bin/autorun
.endif
