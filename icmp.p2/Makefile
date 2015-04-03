#
#
# $TAHI: ct/icmp.p2/Makefile,v 1.6 2010/03/30 01:07:04 akisada Exp $
#

TITLE	= 'Section 5: RFC 4443 - ICMPv6'

INDEX_P1_HOST		= INDEX_BEGIN_ume INDEX_P1_host
INDEX_P1_ROUTER		= INDEX_BEGIN_ume INDEX_P1_router
INDEX_P1_SPECIAL	= INDEX_BEGIN_ume INDEX_P1_special

INDEX_P2_HOST		= INDEX_BEGIN_ume INDEX_P2_host
INDEX_P2_ROUTER		= INDEX_BEGIN_ume INDEX_P2_router



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

ipv6ready_p2_router: document_ipv6ready_p2_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)



.include "../Makefile.inc"
