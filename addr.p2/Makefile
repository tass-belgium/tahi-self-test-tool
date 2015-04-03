#
# $Name: V6LC_5_0_0 $
# $TINY: Makefile.test,v 1.11 2002/03/05 17:13:54 miyata Exp $
# 
#

TITLE	= 'Section 3: RFC 4862 - IPv6 Stateless Address Autoconfiguration'

INDEX_P1_HOST		= INDEX_P1_HOST
INDEX_P1_ROUTER		= INDEX_P1_ROUTER
INDEX_P1_SPECIAL	= INDEX_P1_SPECIAL

INDEX_P2_HOST		= INDEX_P2_HOST
INDEX_P2_ROUTER		= INDEX_P2_ROUTER



clean:
	-/bin/rm -f \
		*.log *.dump *.pcap [0-9]*.html \
		report.html summary.html index.html \
		../config.def \
		pod2htmd.tmp pod2htmi.tmp



#======================================================================#
# Phase-I                                                              #
#======================================================================#
#------------------------------#
# host                         #
#------------------------------#
document_ipv6ready_p1_host:
	/bin/rm -f *.html
	/bin/rm -f pod2html-dircache pod2html-itemcache
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_HOST)

ipv6ready_p1_host: document_ipv6ready_p1_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P1_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p1_router:
	/bin/rm -f *.html
	/bin/rm -f pod2html-dircache pod2html-itemcache
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)

ipv6ready_p1_router: document_ipv6ready_p1_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)



#------------------------------#
# special device               #
#------------------------------#
document_ipv6ready_p1_special:
	/bin/rm -f *.html
	/bin/rm -f pod2html-dircache pod2html-itemcache
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_SPECIAL)

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
	/bin/rm -f *.html
	/bin/rm -f pod2html-dircache pod2html-itemcache
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P2_HOST)

ipv6ready_p2_host: document_ipv6ready_p2_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P2_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p2_router:
	/bin/rm -f *.html
	/bin/rm -f pod2html-dircache pod2html-itemcache
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)

ipv6ready_p2_router: document_ipv6ready_p2_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)



.include "../Makefile.inc"
