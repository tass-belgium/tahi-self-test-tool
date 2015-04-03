#
# $Id: Makefile,v 1.7 2010/03/30 01:07:12 akisada Exp $
#

TITLE	= 'Section 1: RFC 2460 - IPv6 Specification'

INDEX_P1_HOST		= INDEX_p1_host
INDEX_P1_ROUTER		= INDEX_p1_router
INDEX_P1_SPECIAL	= INDEX_p1_special

INDEX_P2_HOST		= INDEX_p2_host
INDEX_P2_ROUTER		= INDEX_p2_router

PERL	= /usr/bin/perl
POD2HTML= -$(PERL) -e 'use Pod::Html; pod2html("--noindex", @ARGV);'

clean:
	-/bin/rm -f \
		*.log *.dump *.pcap [0-9]*.html \
		index.html summary.html report.html \
		pod2htmd.tmp pod2htmi.tmp \
		../config.def \
		ID.def



#======================================================================#
# Phase-I                                                              #
#======================================================================#
#------------------------------#
# host                         #
#------------------------------#
document_ipv6ready_p1_host:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_HOST)
	$(POD2HTML) SPEC.pm > SPEC.html
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_host: document_ipv6ready_p1_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P1_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p1_router:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)
	$(POD2HTML) SPEC.pm > SPEC.html
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_router: document_ipv6ready_p1_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)



#------------------------------#
# special device               #
#------------------------------#
document_ipv6ready_p1_special:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_SPECIAL)
	$(POD2HTML) SPEC.pm > SPEC.html
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_special: document_ipv6ready_p1_special
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P1_SPECIAL)



#======================================================================#
# Phase-II                                                             #
#======================================================================#
#------------------------------#
# host                         #
#------------------------------#
document_ipv6ready_p2_host:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P2_HOST)
	$(POD2HTML) SPEC.pm > SPEC.html
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p2_host: document_ipv6ready_p2_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P2_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p2_router:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)
	$(POD2HTML) SPEC.pm > SPEC.html
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p2_router: document_ipv6ready_p2_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)



.include "../Makefile.inc"
