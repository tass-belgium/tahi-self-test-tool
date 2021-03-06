#
# Makefile
#
# $TAHI: ct/Makefile.test.TAKE,v 1.6 2010/01/22 12:36:52 akisada Exp $
#

SUBDIR= spec.p2	

ipv6ready_p1_host	document_ipv6ready_p1_host	\
ipv6ready_p1_router	document_ipv6ready_p1_router	\
ipv6ready_p1_special	document_ipv6ready_p1_special	\
ipv6ready_p2_host	document_ipv6ready_p2_host	\
ipv6ready_p2_host_dev	document_ipv6ready_p2_host_dev	\
ipv6ready_p2_host_reg	document_ipv6ready_p2_host_reg	\
ipv6ready_p2_router	document_ipv6ready_p2_router:
	@for subdir in ${SUBDIR}; do \
		echo "===> $$subdir"; \
		(cd $$subdir; ${MAKE} $@); \
	done

clean:
	rm -f config.def

.include <bsd.subdir.mk>
