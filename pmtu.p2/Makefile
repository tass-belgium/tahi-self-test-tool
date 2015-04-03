#
# Copyright (C) 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010
# Yokogawa Electric Corporation.
# All rights reserved.
# 
# Redistribution and use of this software in source and binary
# forms, with or without modification, are permitted provided that
# the following conditions and disclaimer are agreed and accepted
# by the user:
# 
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with
#    the distribution.
# 
# 3. Neither the names of the copyrighters, the name of the project
#    which is related to this software (hereinafter referred to as
#    "project") nor the names of the contributors may be used to
#    endorse or promote products derived from this software without
#    specific prior written permission.
# 
# 4. No merchantable use may be permitted without prior written
#    notification to the copyrighters.
# 
# 5. The copyrighters, the project and the contributors may prohibit
#    the use of this software at any time.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHTERS, THE PROJECT AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING
# BUT NOT LIMITED THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE, ARE DISCLAIMED.  IN NO EVENT SHALL THE
# COPYRIGHTERS, THE PROJECT OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
# IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# $Id: Makefile,v 1.6 2010/03/30 01:07:11 akisada Exp $
#
########################################################################

TITLE	= 'Section 4: RFC 1981 - Path MTU Discovery for IPv6'

INDEX_P1_HOST		= INDEX_p1_host
INDEX_P1_ROUTER		= INDEX_p1_router
INDEX_P1_SPECIAL	= INDEX_p1_special

INDEX_P2_HOST		= INDEX_p2_host
INDEX_P2_ROUTER		= INDEX_p2_router



clean:
	-/bin/rm -f \
		*.log *.dump *.pcap [0-9]*.html \
		report.html summary.html index.html \
		pod2htmd.tmp pod2htmi.tmp \
		../config.def \
		lcna_results



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
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_host: document_ipv6ready_p1_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny\
	-title=$(TITLE) \
	$(INDEX_P1_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p1_router:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_router: document_ipv6ready_p1_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny\
	-title=$(TITLE) \
	$(INDEX_P1_ROUTER)



#------------------------------#
# special device               #
#------------------------------#
document_ipv6ready_p1_special:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P1_SPECIAL)
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p1_special: document_ipv6ready_p1_special
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny\
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
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p2_host: document_ipv6ready_p2_host
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny\
	-title=$(TITLE) \
	$(INDEX_P2_HOST)



#------------------------------#
# router                       #
#------------------------------#
document_ipv6ready_p2_router:
	$(AUTORUN) -G \
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)
	rm -f pod2html-dircache pod2html-itemcache

ipv6ready_p2_router: document_ipv6ready_p2_router
	/bin/rm -f index.html summary.html report.html
	$(AUTORUN) $(AROPT) -F -tiny\
	-title=$(TITLE) \
	$(INDEX_P2_ROUTER)



.include "../Makefile.inc"
