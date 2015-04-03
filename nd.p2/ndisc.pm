#!/usr/bin/perl -w
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
# $TAHI: ct/nd.p2/ndisc.pm,v 1.23 2010/03/26 11:04:51 akisada Exp $
#
########################################################################



package ndisc;



use Exporter;
use File::Basename;
use V6evalTool;



BEGIN
{
	require './config.pl';

	$IGN_NA_O_FLAG			= 0;
	$IGN_UNI_NA_TLL			= 1;
	$IGN_UNI_NS_SLL			= 0;
	$NOT_USE_FAST_CHANGE_STATE	= 0;
	$REACHABLE_TIME			= 30;
	$REBOOT_TIMEOUT			= $wait_rebootcmd;
	$RETRANS_TIMER			= 1;
	$WAIT_QUEUE_LMT			= 3;

	$SIG{'ALRM'}	= \&sigalrm;

	$alrm_expired	= 0;

	$V6evalTool::TestVersion = '$Name: V6LC_5_0_0 $';

	$tr1_default = 0;
	$tr1_cache = 0;
	$tn1_cache = 0;
	$tn2_cache = 0;
	$NEED_COMMON_CLEANUP = 0;
	$cleanup_tn_global = 0;
	$force_cleanup_r0 = 0;
	$rut_rtadvd = 0;
	$rut_rtadvd_retrans = 0;
}



END
{
	$SIG{'ALRM'}	= 'DEFAULT';
}



@ISA = qw(Exporter);

@EXPORT = qw(
	%pktdesc
	$Link0
	$Link1
	$WAIT_QUEUE_LMT
	$IGN_UNI_NA_TLL
	$IGN_NA_O_FLAG
	$NOT_USE_FAST_CHANGE_STATE
	$MAX_MULTICAST_SOLICIT
	$MAX_FINAL_RTR_ADVERTISEMENTS
	$MAX_UNICAST_SOLICIT
	$DELAY_FIRST_PROBE_TIME
	$MIN_RANDOM_FACTOR
	$MAX_RANDOM_FACTOR
	$RETRANS_TIMER
	$REBOOT_TIMEOUT
	$MAX_RTR_SOLICITATION_DELAY
	$MAX_RTR_SOLICITATIONS
	$RTR_SOLICITATION_INTERVAL
	$MIN_DELAY_BETWEEN_RAS
	$MAX_RA_DELAY_TIME
	$MAX_ANYCAST_DELAY_TIME
	$MAX_INITIAL_RTR_ADVERTISEMENTS
	$MAX_INITIAL_RTR_ADVERT_INTERVAL
	$REACHABLE_TIME
	$TimeOut
	$SeekTime
	$alrm_expired
	$tr1_default
	$tr1_cache
	$tn1_cache
	$tn2_cache
	$NEED_COMMON_CLEANUP
	$cleanup_tn_global
	$force_cleanup_r0
	$rut_rtadvd
	$rut_rtadvd_retrans
	%hash_erep
	%hash_na
	%hash_mcast_ns
	%hash_ucast_ns
	%hash_na_router
	flushBuffer
	startNdiscWorld
	setupCommon11
	exitIgnore
	exitPass
	exitFail
	exitInitFail
	exitFatal
	exitHostOnly
	exitRouterOnly
	vRecvWrapper
	mcastNS
	ucastNS
	ndiscNone2Incomplete
	ndiscNone2Reachable
	ndiscNone2ReachableR
	ndiscNone2ReachableRTest
	ndiscNone2Stale
	ndiscNone2StaleLoose
	ndiscNone2StaleR
	ndiscNone2Delay
	ndiscNone2DelayLoose
	ndiscNone2DelayR
	ndiscNone2ProbeWithNS
	ndiscStale2ReachableByPacketForwarding1
	ndiscReachable2Stale
	ignoreDAD
);

push(@EXPORT, sort(@V6evalTool::EXPORT));



#------------------------------#
# global variables             #
#------------------------------#
%pktdesc	= (
	'ndisc_dad_linklocal'
		=> '    Recv NS (link-local) w/o SLL: '.
			'unspecified address -&gt; '.
			'NUT solicited-node multicast address',

	'ndisc_dad_global'
		=> '    Recv NS (global) w/o SLL: '.
			'unspecified address -&gt; '.
			'NUT solicited-node multicast address',

	'ndisc_rs'
		=> '    Recv RS w/o SLL: '.
			'NUT (link-local) -&gt; all-routers multicast address',

	'ndisc_rs_sll'
		=> '    Recv RS w/ SLL: '.
			'NUT (link-local) -&gt; all-routers multicast address',

	'ndisc_rs_unspec'
		=> '    Recv RS w/o SLL: '.
			'unspecified address -&gt; '.
			'all-routers multicast address',

	'nd_tn_ra'
		=> '    Send RA w/o SLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'nd_tn_ra_sll'
		=> '    Send RA w/ SLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'nd_ra_rltime0'
		=> '    Send RA (rltime=0) w/o SLL: '.
			'R0 (link-local) -&gt; all-nodes multicast address',

	'ra_force_to_default'
		=> '    Send RA (default parameter) w/o SLL: '.
			'R0 (link-local) -&gt; all-nodes multicast address',

	'nd_ra_rltime0_no_prefix'
		=> '    Send RA (rltime=0) w/o SLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'nd_ra_rltime0_vltime0_pltime0'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'R0 (link-local) -&gt; all-nodes multicast address',

	'nd_tn_ra_rltime0_vltime0_pltime0'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'nd_r0_ra_rltime0_vltime0_pltime0'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'R0 (link-local) -&gt; all-nodes multicast address',

	'nd_tn_ra_rltime0_vltime0_pltime0_diff'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_ereq_offlink'
		=> '    Send Echo Request: H0 (Link1) -&gt; NUT (Link0)',

	'ndisc_erep_offlink'
		=> '    Recv Echo Reply: NUT (Link0) -&gt; H0 (Link1)',

	'ndisc_ereq_offlink_diff'
		=> '    Send Echo Request: H0 (Link1) -&gt; NUT (Link0)',

	'ndisc_erep_offlink_diff'
		=> '    Recv Echo Reply: NUT (Link0) -&gt; H0 (Link1)',

	'ndisc_ereq_LL'
		=> '    Send Echo Request: TN (link-local) -&gt; '.
			'NUT (link-local)',

	'ndisc_ereq_GG'
		=> '    Send Echo Request: TN (global) -&gt; NUT (global)',

	'ndisc_ereq_GL'
		=> '    Send Echo Request: TN (global) -&gt; NUT (link-local)',

	'ndisc_ereq_LG'
		=> '    Send Echo Request: TN (link-local) -&gt; NUT (global)',

	'ndisc_erep_LL'
		=> '    Recv Echo Reply: NUT (link-local) -&gt; '.
			'TN (link-local)',

	'ndisc_erep_GG'
		=> '    Recv Echo Reply: NUT (global) -&gt; TN (global)',

	'ndisc_erep_GL'
		=> '    Recv Echo Reply: NUT (global) -&gt; TN (link-local)',

	'ndisc_erep_LG'
		=> '    Recv Echo Reply: NUT (link-local) -&gt; TN (global)',

	'ndisc_ereq_LL_x'
		=> '    Send Echo Request: H0 (link-local) -&gt; '.
			'NUT (link-local)',

	'ndisc_ereq_GG_x'
		=> '    Send Echo Request: H0 (global) -&gt; NUT (global)',

	'ndisc_ereq_GL_x'
		=> '    Send Echo Request: H0 (global) -&gt; NUT (link-local)',

	'ndisc_ereq_LG_x'
		=> '    Send Echo Request: H0 (link-local) -&gt; NUT (global)',

	'ndisc_erep_LL_x'
		=> '    Recv Echo Reply: NUT (link-local) -&gt; '.
			'H0 (link-local)',

	'ndisc_erep_GG_x'
		=> '    Recv Echo Reply: NUT (global) -&gt; H0 (global)',

	'ndisc_erep_GL_x'
		=> '    Recv Echo Reply: NUT (global) -&gt; H0 (link-local)',

	'ndisc_erep_LG_x'
		=> '    Recv Echo Reply: NUT (link-local) -&gt; H0 (global)',

	'ndisc_ereq_LL_diff'
		=> '    Send Echo Request (diff): TN (link-local) -&gt; '.
			'NUT (link-local)',

	'ndisc_ereq_GG_diff'
		=> '    Send Echo Request (diff): TN (global) -&gt; '.
			'NUT (global)',

	'ndisc_ereq_GL_diff'
		=> '    Send Echo Request (diff): TN (global) -&gt; '.
			'NUT (link-local)',

	'ndisc_ereq_LG_diff'
		=> '    Send Echo Request (diff): TN (link-local) -&gt; '.
			'NUT (global)',

	'ndisc_erep_LL_diff'
		=> '    Recv Echo Reply (diff): NUT (link-local) -&gt; '.
			'TN (link-local)',

	'ndisc_erep_GG_diff'
		=> '    Recv Echo Reply (diff): NUT (global) -&gt; TN (global)',

	'ndisc_erep_GL_diff'
		=> '    Recv Echo Reply (diff): NUT (global) -&gt; '.
			'TN (link-local)',

	'ndisc_erep_LG_diff'
		=> '    Recv Echo Reply (diff): NUT (link-local) -&gt; '.
			'TN (global)',

	'ndisc_mcast_ns_sll_LL'
		=> '    Recv NS (link-local) w/ SLL: NUT (link-local) -&gt; '.
			'TN solicited-node multicast address',

	'ndisc_mcast_ns_offlink'
		=> '    Recv NS (global) w/ SLL: NUT (global) -&gt; '.
			'H0 solicited-node multicast address',

	'ndisc_mcast_ns_sll_GG'
		=> '    Recv NS (global) w/ SLL: NUT (global) -&gt; '.
			'TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_LG'
		=> '    Recv NS (global) w/ SLL: NUT (link-local) -&gt; '.
			'TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_GL'
		=> '    Recv NS (link-local) w/ SLL: NUT (global) -&gt; '.
			'TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_LL_x'
		=> '    Recv NS (link-local) w/ SLL: NUT (link-local) -&gt; '.
			'H0 solicited-node multicast address',

	'ndisc_mcast_ns_sll_GG_x'
		=> '    Recv NS (global) w/ SLL: NUT (global) -&gt; '.
			'H0 solicited-node multicast address',

	'ndisc_mcast_ns_sll_LG_x'
		=> '    Recv NS (global) w/ SLL: NUT (link-local) -&gt; '.
			'H0 solicited-node multicast address',

	'ndisc_mcast_ns_sll_GL_x'
		=> '    Recv NS (link-local) w/ SLL: NUT (global) -&gt; '.
			'H0 solicited-node multicast address',

	'ndisc_mcast_ns_sll_LL_diff'
		=> '    Recv NS (link-local) w/ SLL (diff): NUT (link-local) '.
			'-&gt; TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_GG_diff'
		=> '    Recv NS (global) w/ SLL (diff): NUT (global) -&gt; '.
			'TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_LG_diff'
		=> '    Recv NS (global) w/ SLL (diff): NUT (link-local)'.
			' -&gt; TN solicited-node multicast address',

	'ndisc_mcast_ns_sll_GL_diff'
		=> '    Recv NS (link-local) w/ SLL (diff): NUT (global)'.
			' -&gt; TN solicited-node multicast address',

	'ndisc_na_rSO_tll_LL'
		=> '    Send NA (rSO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_GG'
		=> '    Send NA (rSO, global) w/ TLL: '.
			'TN (global) -&gt; NUT (global)',

	'ndisc_na_rSO_tll_GL'
		=> '    Send NA (rSO, global) w/ TLL: '.
			'TN (global) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_LG'
		=> '    Send NA (rSO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; NUT (global)',

	'ndisc_na_rSO_tll_LL_x'
		=> '    Send NA (rSO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_GG_x'
		=> '    Send NA (rSO, global) w/ TLL: '.
			'H0 (global) -&gt; NUT (global)',

	'ndisc_na_rSO_tll_GL_x'
		=> '    Send NA (rSO, global) w/ TLL: '.
			'H0 (global) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_LG_x'
		=> '    Send NA (rSO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; NUT (global)',

	'ndisc_na_rSO_tll_LL_diff'
		=> '    Send NA (rSO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_GG_diff'
		=> '    Send NA (rSO, global) w/ TLL (diff): '.
			'TN (global) -&gt; NUT (global)',

	'ndisc_na_rSO_tll_GL_diff'
		=> '    Send NA (rSO, global) w/ TLL (diff): '.
			'TN (global) -&gt; NUT (link-local)',

	'ndisc_na_rSO_tll_LG_diff'
		=> '    Send NA (rSO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; NUT (global)',

	'ndisc_ucast_ns_sll_LL'
		=> '    Recv NS (link-local) w/ SLL: NUT (link-local) -&gt; '.
			'TN (link-local)',

	'ndisc_ucast_ns_sll_GG'
		=> '    Recv NS (global) w/ SLL: NUT (global) -&gt; '.
			'TN (global)',

	'ndisc_ucast_ns_sll_LG'
		=> '    Recv NS (global) w/ SLL: NUT (link-local) -&gt; '.
			'TN (global)',

	'ndisc_ucast_ns_sll_GL'
		=> '    Recv NS (link-local) w/ SLL: NUT (global) -&gt; '.
			'TN (link-local)',

	'ndisc_ucast_ns_LL'
		=> '    Recv NS (link-local) w/o SLL: NUT (link-local) -&gt; '.
			'TN (link-local)',

	'ndisc_ucast_ns_GG'
		=> '    Recv NS (global) w/o SLL: NUT (global) -&gt; '.
			'TN (global)',

	'ndisc_ucast_ns_LG'
		=> '    Recv NS (global) w/o SLL: NUT (link-local) -&gt; '.
			'TN (global)',

	'ndisc_ucast_ns_GL'
		=> '    Recv NS (link-local) w/o SLL: NUT (global) -&gt; '.
			'TN (link-local)',

	'ndisc_ucast_ns_sll_LL_x'
		=> '    Recv NS (link-local) w/ SLL: NUT (link-local) -&gt; '.
			'H0 (link-local)',

	'ndisc_ucast_ns_sll_GG_x'
		=> '    Recv NS (global) w/ SLL: NUT (global) -&gt; '.
			'H0 (global)',

	'ndisc_ucast_ns_sll_LG_x'
		=> '    Recv NS (global) w/ SLL: NUT (link-local) -&gt; '.
			'H0 (global)',

	'ndisc_ucast_ns_sll_GL_x'
		=> '    Recv NS (link-local) w/ SLL: NUT (global) -&gt; '.
			'H0 (link-local)',

	'ndisc_ucast_ns_LL_x'
		=> '    Recv NS (link-local) w/o SLL: NUT (link-local) -&gt; '.
			'H0 (link-local)',

	'ndisc_ucast_ns_GG_x'
		=> '    Recv NS (global) w/o SLL: NUT (global) -&gt; '.
			'H0 (global)',

	'ndisc_ucast_ns_LG_x'
		=> '    Recv NS (global) w/o SLL: NUT (link-local) -&gt; '.
			'H0 (global)',

	'ndisc_ucast_ns_GL_x'
		=> '    Recv NS (link-local) w/o SLL: NUT (global) -&gt; '.
			'H0 (link-local)',

	'ndisc_ucast_ns_sll_LL_diff'
		=> '    Recv NS (link-local) w/ SLL (diff): NUT (link-local)'.
			' -&gt; TN (link-local)',

	'ndisc_ucast_ns_sll_GG_diff'
		=> '    Recv NS (global) w/ SLL (diff): NUT (global) -&gt; '.
			'TN (global)',

	'ndisc_ucast_ns_sll_LG_diff'
		=> '    Recv NS (global) w/ SLL (diff): NUT (link-local)'.
			' -&gt; TN (global)',

	'ndisc_ucast_ns_sll_GL_diff'
		=> '    Recv NS (link-local) w/ SLL (diff): NUT (global)'.
			' -&gt; TN (link-local)',

	'ndisc_ucast_ns_LL_diff'
		=> '    Recv NS (link-local) w/o SLL (diff): NUT (link-local)'.
			' -&gt; TN (link-local)',

	'ndisc_ucast_ns_GG_diff'
		=> '    Recv NS (global) w/o SLL (diff): NUT (global)'.
			' -&gt; TN (global)',

	'ndisc_ucast_ns_LG_diff'
		=> '    Recv NS (global) w/o SLL (diff): NUT (link-local)'.
			' -&gt; TN (global)',

	'ndisc_ucast_ns_GL_diff'
		=> '    Recv NS (link-local) w/o SLL (diff): NUT (global)'.
			' -&gt; TN (link-local)',

	'ndisc_cleanup_ns'
		=> '    Send NS (link-local) w/ SLL (diff):'.
			' TN (link-local) -&gt; NUT (link-local)',

	'ndisc_cleanup_ns_global'
		=> '    Send NS (global) w/ SLL (diff):'.
			' TN (global) -&gt; NUT (global)',

	'redirect_r0_cleanup_ns'
		=> '    Send NS (link-local) w/ SLL (diff):'.
			' R0 (link-local) -&gt; NUT (link-local)',

	'ndisc_cleanup_ns_tn'
		=> '    Send NS (link-local) w/ SLL:'.
			' TN (link-local) -&gt; NUT (link-local)',

	'ndisc_cleanup_ns_x'
		=> '    Send NS (link-local) w/ SLL (diff):'.
			' H0 (link-local) -&gt; NUT (link-local)',

	'ndisc_na_rsO_tll_LL'
		=> '    Send NA (rsO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GG'
		=> '    Send NA (rsO, global) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GL'
		=> '    Send NA (rsO, global) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_LG'
		=> '    Send NA (rsO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_LL_x'
		=> '    Send NA (rsO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GG_x'
		=> '    Send NA (rsO, global) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GL_x'
		=> '    Send NA (rsO, global) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_LG_x'
		=> '    Send NA (rsO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_LL_diff'
		=> '    Send NA (rsO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GG_diff'
		=> '    Send NA (rsO, global) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_GL_diff'
		=> '    Send NA (rsO, global) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_rsO_tll_LG_diff'
		=> '    Send NA (rsO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LL'
		=> '    Send NA (RsO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GG'
		=> '    Send NA (RsO, global) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GL'
		=> '    Send NA (RsO, global) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LG'
		=> '    Send NA (RsO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LL_x'
		=> '    Send NA (RsO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GG_x'
		=> '    Send NA (RsO, global) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GL_x'
		=> '    Send NA (RsO, global) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LG_x'
		=> '    Send NA (RsO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LL_diff'
		=> '    Send NA (RsO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GG_diff'
		=> '    Send NA (RsO, global) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_GL_diff'
		=> '    Send NA (RsO, global) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RsO_tll_LG_diff'
		=> '    Send NA (RsO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; all-nodes multicast address',

	'ndisc_na_RSO_tll_LL'
		=> '    Send NA (RSO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_GG'
		=> '    Send NA (RSO, global) w/ TLL: '.
			'TN (global) -&gt; NUT (global)',

	'ndisc_na_RSO_tll_GL'
		=> '    Send NA (RSO, global) w/ TLL: '.
			'TN (global) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_LG'
		=> '    Send NA (RSO, link-local) w/ TLL: '.
			'TN (link-local) -&gt; NUT (global)',

	'ndisc_na_RSO_tll_LL_x'
		=> '    Send NA (RSO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_GG_x'
		=> '    Send NA (RSO, global) w/ TLL: '.
			'H0 (global) -&gt; NUT (global)',

	'ndisc_na_RSO_tll_GL_x'
		=> '    Send NA (RSO, global) w/ TLL: '.
			'H0 (global) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_LG_x'
		=> '    Send NA (RSO, link-local) w/ TLL: '.
			'H0 (link-local) -&gt; NUT (global)',

	'ndisc_na_RSO_tll_LL_diff'
		=> '    Send NA (RSO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_GG_diff'
		=> '    Send NA (RSO, global) w/ TLL (diff): '.
			'TN (global) -&gt; NUT (global)',

	'ndisc_na_RSO_tll_GL_diff'
		=> '    Send NA (RSO, global) w/ TLL (diff): '.
			'TN (global) -&gt; NUT (link-local)',

	'ndisc_na_RSO_tll_LG_diff'
		=> '    Send NA (RSO, link-local) w/ TLL (diff): '.
			'TN (link-local) -&gt; NUT (global)',
);

@Links		= ();
$TimeOut	= $RETRANS_TIMER + 1;
$SeekTime	= 0;



#------------------------------#
# global constants             #
#------------------------------#
$Link0					= 'Link0';
$Link1					= 'Link1';
$MAX_RTR_SOLICITATIONS			= 3;
$MAX_FINAL_RTR_ADVERTISEMENTS		= 3;
$MAX_RTR_SOLICITATION_DELAY		= 1;
$MAX_MULTICAST_SOLICIT			= 3;
$MAX_UNICAST_SOLICIT			= 3;
$DELAY_FIRST_PROBE_TIME			= 5;
$MIN_RANDOM_FACTOR			= 0.5;
$MAX_RANDOM_FACTOR			= 1.5;
$RTR_SOLICITATION_INTERVAL		= 4;
$MAX_INITIAL_RTR_ADVERT_INTERVAL	= 16;
$MAX_FINAL_RTR_ADVERTISEMENTS		= 3;
$MAX_INITIAL_RTR_ADVERTISEMENTS		= 3;
$MIN_DELAY_BETWEEN_RAS			= 3;
$MAX_RA_DELAY_TIME			= 0.5;
$MAX_ANYCAST_DELAY_TIME			= 1;

$Success = 0;		# subroutine exit status
$Failure = 1;
$WAIT_REPLY = 5;

%hash_erep	= (
	'ndisc_ereq_LL'		=> 'ndisc_erep_LL',
	'ndisc_ereq_GG'		=> 'ndisc_erep_GG',
	'ndisc_ereq_LG'		=> 'ndisc_erep_GL',
	'ndisc_ereq_GL'		=> 'ndisc_erep_LG',
	'ndisc_ereq_LL_x'	=> 'ndisc_erep_LL_x',
	'ndisc_ereq_GG_x'	=> 'ndisc_erep_GG_x',
	'ndisc_ereq_LG_x'	=> 'ndisc_erep_GL_x',
	'ndisc_ereq_GL_x'	=> 'ndisc_erep_LG_x',
	'ndisc_ereq_LL_diff'	=> 'ndisc_erep_LL_diff',
	'ndisc_ereq_GG_diff'	=> 'ndisc_erep_GG_diff',
	'ndisc_ereq_LG_diff'	=> 'ndisc_erep_GL_diff',
	'ndisc_ereq_GL_diff'	=> 'ndisc_erep_LG_diff',
	'tr1_ereq_linklocal'	=> 'tr1_erep_linklocal',
);

%hash_na	= (
	'ndisc_mcast_ns_sll_LL'		=> 'ndisc_na_rSO_tll_LL',
	'ndisc_mcast_ns_sll_GG'		=> 'ndisc_na_rSO_tll_GG',
	'ndisc_mcast_ns_sll_LG'		=> 'ndisc_na_rSO_tll_GL',
	'ndisc_mcast_ns_sll_GL'		=> 'ndisc_na_rSO_tll_LG',
	'ndisc_mcast_ns_sll_LL_x'	=> 'ndisc_na_rSO_tll_LL_x',
	'ndisc_mcast_ns_sll_GG_x'	=> 'ndisc_na_rSO_tll_GG_x',
	'ndisc_mcast_ns_sll_LG_x'	=> 'ndisc_na_rSO_tll_GL_x',
	'ndisc_mcast_ns_sll_GL_x'	=> 'ndisc_na_rSO_tll_LG_x',
	'ndisc_mcast_ns_sll_LL_diff'	=> 'ndisc_na_rSO_tll_LL_diff',
	'ndisc_mcast_ns_sll_GG_diff'	=> 'ndisc_na_rSO_tll_GG_diff',
	'ndisc_mcast_ns_sll_LG_diff'	=> 'ndisc_na_rSO_tll_GL_diff',
	'ndisc_mcast_ns_sll_GL_diff'	=> 'ndisc_na_rSO_tll_LG_diff',
);

%hash_na_router	= (
	'ndisc_mcast_ns_sll_LL'		=> 'ndisc_na_RSO_tll_LL',
	'ndisc_mcast_ns_sll_GG'		=> 'ndisc_na_RSO_tll_GG',
	'ndisc_mcast_ns_sll_LG'		=> 'ndisc_na_RSO_tll_GL',
	'ndisc_mcast_ns_sll_GL'		=> 'ndisc_na_RSO_tll_LG',
	'ndisc_mcast_ns_sll_LL_x'	=> 'ndisc_na_RSO_tll_LL_x',
	'ndisc_mcast_ns_sll_GG_x'	=> 'ndisc_na_RSO_tll_GG_x',
	'ndisc_mcast_ns_sll_LG_x'	=> 'ndisc_na_RSO_tll_GL_x',
	'ndisc_mcast_ns_sll_GL_x'	=> 'ndisc_na_RSO_tll_LG_x',
	'ndisc_mcast_ns_sll_LL_diff'	=> 'ndisc_na_RSO_tll_LL_diff',
	'ndisc_mcast_ns_sll_GG_diff'	=> 'ndisc_na_RSO_tll_GG_diff',
	'ndisc_mcast_ns_sll_LG_diff'	=> 'ndisc_na_RSO_tll_GL_diff',
	'ndisc_mcast_ns_sll_GL_diff'	=> 'ndisc_na_RSO_tll_LG_diff',
	'tn1_mcast_ns_via_tr1_linklocal'	=> 'tr1_na_RSO_tll_linklocal',
	'tn1_mcast_ns_via_tr1_global'	=> 'tr1_na_RSO_tll_global',
);

%hash_ucast_na_router	= (
	'ndisc_ucast_ns_sll_LL'		=> 'ndisc_na_RSO_tll_LL',
	'ndisc_ucast_ns_sll_GG'		=> 'ndisc_na_RSO_tll_GG',
	'ndisc_ucast_ns_sll_LG'		=> 'ndisc_na_RSO_tll_GL',
	'ndisc_ucast_ns_sll_GL'		=> 'ndisc_na_RSO_tll_LG',
	'ndisc_ucast_ns_sll_LL_x'	=> 'ndisc_na_RSO_tll_LL_x',
	'ndisc_ucast_ns_sll_GG_x'	=> 'ndisc_na_RSO_tll_GG_x',
	'ndisc_ucast_ns_sll_LG_x'	=> 'ndisc_na_RSO_tll_GL_x',
	'ndisc_ucast_ns_sll_GL_x'	=> 'ndisc_na_RSO_tll_LG_x',
	'ndisc_ucast_ns_sll_LL_diff'	=> 'ndisc_na_RSO_tll_LL_diff',
	'ndisc_ucast_ns_sll_GG_diff'	=> 'ndisc_na_RSO_tll_GG_diff',
	'ndisc_ucast_ns_sll_LG_diff'	=> 'ndisc_na_RSO_tll_GL_diff',
	'ndisc_ucast_ns_sll_GL_diff'	=> 'ndisc_na_RSO_tll_LG_diff',
	'ndisc_ucast_ns_LL'		=> 'ndisc_na_RSO_tll_LL',
	'ndisc_ucast_ns_GG'		=> 'ndisc_na_RSO_tll_GG',
	'ndisc_ucast_ns_LG'		=> 'ndisc_na_RSO_tll_GL',
	'ndisc_ucast_ns_GL'		=> 'ndisc_na_RSO_tll_LG',
	'ndisc_ucast_ns_LL_x'		=> 'ndisc_na_RSO_tll_LL_x',
	'ndisc_ucast_ns_GG_x'		=> 'ndisc_na_RSO_tll_GG_x',
	'ndisc_ucast_ns_LG_x'		=> 'ndisc_na_RSO_tll_GL_x',
	'ndisc_ucast_ns_GL_x'		=> 'ndisc_na_RSO_tll_LG_x',
	'ndisc_ucast_ns_LL_diff'	=> 'ndisc_na_RSO_tll_LL_diff',
	'ndisc_ucast_ns_GG_diff'	=> 'ndisc_na_RSO_tll_GG_diff',
	'ndisc_ucast_ns_LG_diff'	=> 'ndisc_na_RSO_tll_GL_diff',
	'ndisc_ucast_ns_GL_diff'	=> 'ndisc_na_RSO_tll_LG_diff',
);

%hash_mcast_na_router	= (
    'ndisc_mcast_ns_sll_GL' => 'ndisc_na_RSO_tll_LL',
						   );


%hash_na_unsol	= (
	'ndisc_mcast_ns_sll_LL'		=> 'ndisc_na_rsO_tll_LL',
	'ndisc_mcast_ns_sll_GG'		=> 'ndisc_na_rsO_tll_GG',
	'ndisc_mcast_ns_sll_LG'		=> 'ndisc_na_rsO_tll_GL',
	'ndisc_mcast_ns_sll_GL'		=> 'ndisc_na_rsO_tll_LG',
	'ndisc_mcast_ns_sll_LL_x'	=> 'ndisc_na_rsO_tll_LL_x',
	'ndisc_mcast_ns_sll_GG_x'	=> 'ndisc_na_rsO_tll_GG_x',
	'ndisc_mcast_ns_sll_LG_x'	=> 'ndisc_na_rsO_tll_GL_x',
	'ndisc_mcast_ns_sll_GL_x'	=> 'ndisc_na_rsO_tll_LG_x',
	'ndisc_mcast_ns_sll_LL_diff'	=> 'ndisc_na_rsO_tll_LL_diff',
	'ndisc_mcast_ns_sll_GG_diff'	=> 'ndisc_na_rsO_tll_GG_diff',
	'ndisc_mcast_ns_sll_LG_diff'	=> 'ndisc_na_rsO_tll_GL_diff',
	'ndisc_mcast_ns_sll_GL_diff'	=> 'ndisc_na_rsO_tll_LG_diff',
);

%hash_na_unsol_router	= (
	'ndisc_mcast_ns_sll_LL'		=> 'ndisc_na_RsO_tll_LL',
	'ndisc_mcast_ns_sll_GG'		=> 'ndisc_na_RsO_tll_GG',
	'ndisc_mcast_ns_sll_LG'		=> 'ndisc_na_RsO_tll_GL',
	'ndisc_mcast_ns_sll_GL'		=> 'ndisc_na_RsO_tll_LG',
	'ndisc_mcast_ns_sll_LL_x'	=> 'ndisc_na_RsO_tll_LL_x',
	'ndisc_mcast_ns_sll_GG_x'	=> 'ndisc_na_RsO_tll_GG_x',
	'ndisc_mcast_ns_sll_LG_x'	=> 'ndisc_na_RsO_tll_GL_x',
	'ndisc_mcast_ns_sll_GL_x'	=> 'ndisc_na_RsO_tll_LG_x',
	'ndisc_mcast_ns_sll_LL_diff'	=> 'ndisc_na_RsO_tll_LL_diff',
	'ndisc_mcast_ns_sll_GG_diff'	=> 'ndisc_na_RsO_tll_GG_diff',
	'ndisc_mcast_ns_sll_LG_diff'	=> 'ndisc_na_RsO_tll_GL_diff',
	'ndisc_mcast_ns_sll_GL_diff'	=> 'ndisc_na_RsO_tll_LG_diff',
);

%hash_mcast_ns	= (
	'ndisc_ereq_LL'		=> 'ndisc_mcast_ns_sll_LL',
	'ndisc_ereq_GG'		=> 'ndisc_mcast_ns_sll_GG',
	'ndisc_ereq_LG'		=> 'ndisc_mcast_ns_sll_GL',
	'ndisc_ereq_GL'		=> 'ndisc_mcast_ns_sll_LG',
	'ndisc_ereq_LL_x'	=> 'ndisc_mcast_ns_sll_LL_x',
	'ndisc_ereq_GG_x'	=> 'ndisc_mcast_ns_sll_GG_x',
	'ndisc_ereq_LG_x'	=> 'ndisc_mcast_ns_sll_GL_x',
	'ndisc_ereq_GL_x'	=> 'ndisc_mcast_ns_sll_LG_x',
	'ndisc_ereq_LL_diff'	=> 'ndisc_mcast_ns_sll_LL_diff',
	'ndisc_ereq_GG_diff'	=> 'ndisc_mcast_ns_sll_GG_diff',
	'ndisc_ereq_LG_diff'	=> 'ndisc_mcast_ns_sll_GL_diff',
	'ndisc_ereq_GL_diff'	=> 'ndisc_mcast_ns_sll_LG_diff',
	'tr1_ereq_linklocal'	=> 'tn1_mcast_ns_via_tr1_linklocal',
);

%hash_mcast_ns_ign_src	= (
	'ndisc_mcast_ns_sll_LL'		=> 'ndisc_mcast_ns_sll_GL',
	'ndisc_mcast_ns_sll_GG'		=> 'ndisc_mcast_ns_sll_LG',
	'ndisc_mcast_ns_sll_LG'		=> 'ndisc_mcast_ns_sll_GG',
	'ndisc_mcast_ns_sll_GL'		=> 'ndisc_mcast_ns_sll_LL',
	'ndisc_mcast_ns_sll_LL_x'	=> 'ndisc_mcast_ns_sll_GL_x',
	'ndisc_mcast_ns_sll_GG_x'	=> 'ndisc_mcast_ns_sll_LG_x',
	'ndisc_mcast_ns_sll_LG_x'	=> 'ndisc_mcast_ns_sll_GG_x',
	'ndisc_mcast_ns_sll_GL_x'	=> 'ndisc_mcast_ns_sll_LL_x',
	'ndisc_mcast_ns_sll_LL_diff'	=> 'ndisc_mcast_ns_sll_GL_diff',
	'ndisc_mcast_ns_sll_GG_diff'	=> 'ndisc_mcast_ns_sll_LG_diff',
	'ndisc_mcast_ns_sll_LG_diff'	=> 'ndisc_mcast_ns_sll_GG_diff',
	'ndisc_mcast_ns_sll_GL_diff'	=> 'ndisc_mcast_ns_sll_LL_diff',
	'tn1_mcast_ns_via_tr1_linklocal'	=> 'tn1_mcast_ns_via_tr1_global',
);

%hash_ucast_ns		= (
	'ndisc_ereq_LL'		=> 'ndisc_ucast_ns_sll_LL',
	'ndisc_ereq_GG'		=> 'ndisc_ucast_ns_sll_GG',
	'ndisc_ereq_LG'		=> 'ndisc_ucast_ns_sll_LL',
	'ndisc_ereq_GL'		=> 'ndisc_ucast_ns_sll_GG',
	'ndisc_ereq_LL_x'	=> 'ndisc_ucast_ns_sll_LL_x',
	'ndisc_ereq_GG_x'	=> 'ndisc_ucast_ns_sll_GG_x',
	'ndisc_ereq_LG_x'	=> 'ndisc_ucast_ns_sll_LL_x',
	'ndisc_ereq_GL_x'	=> 'ndisc_ucast_ns_sll_GG_x',
	'ndisc_ereq_LL_diff'	=> 'ndisc_ucast_ns_sll_LL_diff',
	'ndisc_ereq_GG_diff'	=> 'ndisc_ucast_ns_sll_GG_diff',
	'ndisc_ereq_LG_diff'	=> 'ndisc_ucast_ns_sll_LL_diff',
	'ndisc_ereq_GL_diff'	=> 'ndisc_ucast_ns_sll_GG_diff',
);

%hash_ucast_ns_ign_src	= (
	'ndisc_ucast_ns_sll_LL'		=> 'ndisc_ucast_ns_sll_GL',
	'ndisc_ucast_ns_sll_GG'		=> 'ndisc_ucast_ns_sll_LG',
	'ndisc_ucast_ns_sll_GL'		=> 'ndisc_ucast_ns_sll_LL',
	'ndisc_ucast_ns_sll_LG'		=> 'ndisc_ucast_ns_sll_GG',
	'ndisc_ucast_ns_sll_LL_x'	=> 'ndisc_ucast_ns_sll_GL_x',
	'ndisc_ucast_ns_sll_GG_x'	=> 'ndisc_ucast_ns_sll_LG_x',
	'ndisc_ucast_ns_sll_GL_x'	=> 'ndisc_ucast_ns_sll_LL_x',
	'ndisc_ucast_ns_sll_LG_x'	=> 'ndisc_ucast_ns_sll_GG_x',
	'ndisc_ucast_ns_sll_LL_diff'	=> 'ndisc_ucast_ns_sll_GL_diff',
	'ndisc_ucast_ns_sll_GG_diff'	=> 'ndisc_ucast_ns_sll_LG_diff',
	'ndisc_ucast_ns_sll_GL_diff'	=> 'ndisc_ucast_ns_sll_LL_diff',
	'ndisc_ucast_ns_sll_LG_diff'	=> 'ndisc_ucast_ns_sll_GG_diff',
);

%hash_ucast_ns_ign_sll	= (
	'ndisc_ucast_ns_sll_LL'		=> 'ndisc_ucast_ns_GL',
	'ndisc_ucast_ns_sll_GG'		=> 'ndisc_ucast_ns_LG',
	'ndisc_ucast_ns_sll_GL'		=> 'ndisc_ucast_ns_LL',
	'ndisc_ucast_ns_sll_LG'		=> 'ndisc_ucast_ns_GG',
	'ndisc_ucast_ns_sll_LL_x'	=> 'ndisc_ucast_ns_GL_x',
	'ndisc_ucast_ns_sll_GG_x'	=> 'ndisc_ucast_ns_LG_x',
	'ndisc_ucast_ns_sll_GL_x'	=> 'ndisc_ucast_ns_LL_x',
	'ndisc_ucast_ns_sll_LG_x'	=> 'ndisc_ucast_ns_GG_x',
	'ndisc_ucast_ns_sll_LL_diff'	=> 'ndisc_ucast_ns_GL_diff',
	'ndisc_ucast_ns_sll_GG_diff'	=> 'ndisc_ucast_ns_LG_diff',
	'ndisc_ucast_ns_sll_GL_diff'	=> 'ndisc_ucast_ns_LL_diff',
	'ndisc_ucast_ns_sll_LG_diff'	=> 'ndisc_ucast_ns_GG_diff',
);



#------------------------------#
# sigalrm()                    #
#------------------------------#
sub
sigalrm
{
	alarm(0);
	$alrm_expired ++;

	return;
}



#------------------------------#
# startNdiscWorld()            #
#------------------------------#
sub
startNdiscWorld(@)
{
	my (@Link) = sort(@_);

	foreach my $link (@Link) {
		push(@Links, $link);
		vCapture($link);
	}

	return;
}



#===============================================================
# setupCommon11(Link0) - Common Test Setup 1.1
#===============================================================
sub
setupCommon11
{
	my($status);

	if ($V6evalTool::NutDef{'Type'} eq 'router') {
		$status = _setup11_Router(@_);
	} else {
		$status = _setup11_Host(@_);
	}

	return ($status);
}



sub
_setup11_Host
{
	my($IF) = @_;
	my(%ret);

	vLogHTML('--- start Common Test Setup 1.1 for Host<BR>');

	vSend($IF, 'setup_echo_request');
	%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			vSend($IF, 'na_l2l');
			%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_g2l') {
			vSend($IF, 'na_l2g');
			%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply');
		}
	}

	if ($ret{'status'} == 0 and $ret{'recvFrame'} eq 'setup_echo_reply') {
		vLogHTML('OK<BR>');
	} else {
		vLogHTML('Cannot receive Echo Reply<BR>');
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
		vLogHTML('<FONT COLOR="#FF0000">setup failure</FONT><BR>');
		return ($Failure);
	}

	vSend($IF, 'setup_ra');
	$useRA = 1;
	vRecv3($IF, $wait_dadns, 0, 0, 'setup_dadns');
	vSleep($wait_after_dadns);

	vSend($IF, 'setup_echo_request_g');
	%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply_g', 'ns_g2g', 'ns_l2g');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_g2g') {
			vSend($IF, 'na_g2g');
			%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply_g');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			vSend($IF, 'na_g2l');
			%ret = vRecv3($IF, $WAIT_REPLY, 0, 0, 'setup_echo_reply_g');
		}
	}

	if ($ret{'status'} == 0 and $ret{'recvFrame'} eq 'setup_echo_reply_g') {
		vLogHTML('OK<BR>');
	} else {
		vLogHTML('Cannot receive Echo Reply<BR>');
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
		vLogHTML('<FONT COLOR="#FF0000">setup failure</FONT><BR>');
		return ($Failure);
	}

	vClear($IF);
	vLogHTML('--- end Common Test Setup 1.1 for Host<BR>');
	return ($Success);
}



sub
_setup11_Router
{
	my($IF) = @_;
	my($tnaddr, $nutdev, %ret, $retv);

	vLogHTML('--- start Common Test Setup 1.1 for Router<BR>');

	$tnaddr = vMAC2LLAddr($V6evalTool::TnDef{'Link0_addr'});
	$nutdev = $V6evalTool::NutDef{'Link0_device'};

	$retv = vRemote('route.rmt',	'cmd=add ' .
					'prefix=default ' .
					"gateway=$tnaddr " .
					"if=$nutdev");
	if ($retv != 0) {
		vLogHTML('Cannot set default router<BR>');
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
		vLogHTML('<FONT COLOR="#FF0000">setup failure</FONT><BR>');
		return ($Failure);
	}

	$routeSet = 1;

	vClear($IF);
	desc_vSend($IF, 'setup_echo_request');
	%ret = desc_vRecv($IF, $WAIT_REPLY, 0, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			desc_vSend($IF, 'na_l2l');
			%ret = desc_vRecv($IF, $WAIT_REPLY, 0, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			desc_vSend($IF, 'na_g2l');
			%ret = desc_vRecv($IF, $WAIT_REPLY, 0, 0, 0, 'setup_echo_reply');
		}
	}

	vClear($IF);
	vLogHTML('--- end Common Test Setup 1.1 for Router<BR>');

	if ($ret{'status'} == 0 and $ret{'recvFrame'} eq 'setup_echo_reply') {
		vLogHTML('OK<BR>');
		return ($Success)
	} else {
		vLogHTML('Cannot receive Echo Reply<BR>');
		vLogHTML('<FONT COLOR="#FF0000">NG</FONT><BR>');
		vLogHTML('<FONT COLOR="#FF0000">setup failure</FONT><BR>');
		return ($Failure);
	}
}



#------------------------------#
# cleanupCommon11()            #
#------------------------------#
sub
cleanupCommon11($)
{
	my ($Link) = @_;

	if($rut_rtadvd) {
		vClear($Link);
		if(vRemote('racontrol.rmt', 'mode=stop')) {
			vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
				'Could\'t stop to send RA</B></FONT><BR>');

			exitFatal();
			#NOTREACHED
		}

		vRecv($Link,
			$MAX_INITIAL_RTR_ADVERT_INTERVAL *
				$MAX_INITIAL_RTR_ADVERTISEMENTS +
				$MIN_DELAY_BETWEEN_RAS + 1,
			0, 0);
	}

	if($rut_rtadvd_retrans && ($V6evalTool::NutDef{'Type'} eq 'router')) {
		vClear($Link);
		if(vRemote('racontrol.rmt', 'mode=start',
			'retrans=1000',
			"link0=$V6evalTool::NutDef{'Link0_device'}")) {

			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'racontrol.rmt: '.
				'Could\'t start to send RA'.
				'</B></FONT><BR>');

			exitFatal();
			#NOTREACHED
		}

		vClear($Link);
		if(vRemote('racontrol.rmt', 'mode=stop')) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'racontrol.rmt: Could\'t stop to send RA'.
				'</B></FONT><BR>');

			exitFatal();
			#NOTREACHED
		}

		vRecv($Link,
			$MAX_INITIAL_RTR_ADVERT_INTERVAL *
				$MAX_INITIAL_RTR_ADVERTISEMENTS +
					$MIN_DELAY_BETWEEN_RAS + 1,
			0, 0);

		$rut_rtadvd_retrans = 0;
	}

	if($tr1_cache) {
		vSend($Link, 'na_cleanup_tr1');
		vSend($Link, 'ereq_cleanup_tr1');
		vRecv($Link, $TimeOut, 0, 0, 'erep_cleanup_tr1');

		flushBuffer($Link,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 1);
	}

	if($cleanup_tn_global) {
		vSend($Link, 'na_cleanup_tn1_global');
		vSend($Link, 'ereq_cleanup_tn1_global');
		vRecv($Link, $TimeOut, 0, 0, 'erep_cleanup_tn1_global');

		flushBuffer($Link,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 1);
	}
	if($tn1_cache) {
		vSend($Link, 'na_cleanup_tn1');
		vSend($Link, 'ereq_cleanup_tn1');
		vRecv($Link, $TimeOut, 0, 0, 'erep_cleanup_tn1');

		flushBuffer($Link,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 1);
	}

	if($tn2_cache) {
		vSend($Link, 'na_cleanup_tn2');
		vSend($Link, 'ereq_cleanup_tn2');
		vRecv($Link, $TimeOut, 0, 0, 'erep_cleanup_tn2');

		flushBuffer($Link,
			$DELAY_FIRST_PROBE_TIME + $RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 1);
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		if($force_cleanup_r0) {
			vSend($Link, 'ra_cleanup_r0_force');
			ignoreDAD($Link);
		} elsif($tr1_default) {
			vSend($Link, 'ra_cleanup_r0');
			ignoreDAD($Link);
		}
	}

	if($tr1_default && ($V6evalTool::NutDef{'Type'} eq 'router')) {
		if(vRemote(
			'route.rmt',
			'cmd=delete',
			'prefix=default',
			"gateway=fe80::200:ff:fe00:a0a0",
			"if=$V6evalTool::NutDef{'Link0_device'}"
		)) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'route.rmt: Could\'t delete the route</B></FONT><BR>');
			return($false);
		}

		$tr1_default = 0;
	}

	return;
}



#------------------------------#
# exitNdiscWorld()             #
#------------------------------#
sub
exitNdiscWorld($)
{
	my ($ecode) = @_;

	if ($NEED_COMMON_CLEANUP) {
		vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>Common Test Cleanup</B></U></FONT><BR>');
		cleanupCommon11($Link0);
	}

	if($ecode != $V6evalTool::exitPass) {
		foreach my $Link (@Links) {
			flushBuffer($Link,
				$DELAY_FIRST_PROBE_TIME +
				$RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, 1);
		}
	}

	while(my $Link = pop(@Links)) {
		vStop($Link);
	}

	exit($ecode);
}



#------------------------------#
# exitIgnore()                 #
#------------------------------#
sub
exitIgnore()
{
	vLogHTML('<B>-</B><BR>');
	exitNdiscWorld($V6evalTool::exitIgnore);
}



#------------------------------#
# exitPass()                   #
#------------------------------#
sub
exitPass()
{
	vLogHTML('<B>PASS</B><BR>');
	exitNdiscWorld($V6evalTool::exitPass);
}



#------------------------------#
# exitInitFail()               #
#------------------------------#
sub
exitInitFail()
{
	vLogHTML('<FONT COLOR="#FF0000"><B>Initialization Fail</B></FONT><BR>');
	exitNdiscWorld($V6evalTool::exitInitFail);
}



#------------------------------#
# exitFail()                   #
#------------------------------#
sub
exitFail()
{
	vLogHTML('<FONT COLOR="#FF0000"><B>FAIL</B></FONT><BR>');
	exitNdiscWorld($V6evalTool::exitFail);
}



#------------------------------#
# exitFatal()                  #
#------------------------------#
sub
exitFatal()
{
	vLogHTML('<FONT COLOR="#FF0000"><B>internal error</B></FONT><BR>');
	exitNdiscWorld($V6evalTool::exitFatal);
}



#------------------------------#
# exitHostOnly()               #
#------------------------------#
sub
exitHostOnly()
{
	vLogHTML('<FONT COLOR="#00FF00"><B>Host Only</B></FONT><BR>');
	exit($V6evalTool::exitHostOnly);
}



#------------------------------#
# exitRouterOnly()             #
#------------------------------#
sub
exitRouterOnly()
{
	vLogHTML('<FONT COLOR="#00FF00"><B>Router Only</B></FONT><BR>');
	exit($V6evalTool::exitRouterOnly);
}



#------------------------------#
# flushBuffer()                #
#------------------------------#
sub
flushBuffer($$$)
{
	my ($Link, $delay, $timeout) = @_;

	my $recvCount = 0;

	my %ret = vRecvWrapper($Link, $delay + $timeout, 0, 0);
	if($ret{'recvCount'}) {
		$recvCount += $ret{'recvCount'};
	}

	vClear($Link);

	$SeekTime = 0;

	return($recvCount);
}



#------------------------------#
# ignoreDAD()                  #
#------------------------------#
sub
ignoreDAD($)
{
	my ($Link) = @_;

	my $recvCount = 0;

	$SeekTime = 0;

	for(my $x = 0; ; $x ++) {
		my %ret = vRecvWrapper($Link,
			$x ? $TimeOut : $MAX_RTR_SOLICITATION_DELAY + $TimeOut,
			$SeekTime, 0, 'ndisc_dad_global');

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			if($ret{'recvFrame'} eq 'ndisc_dad_global') {
				$recvCount --;
				next;
			}
		}

		last;
	}

	vClear($Link);

	$SeekTime = 0;

	return($recvCount);
}



#------------------------------#
# vRecvWrapper()               #
#------------------------------#
sub
vRecvWrapper($$$$@)
{
	my ($ifname, $timeout, $seektime, $count, @frames) = @_;

	my %ret = vRecv($ifname, $timeout, $seektime, $count, sort(@frames));

	if($ret{'recvCount'}) {
		$SeekTime = $ret{'recvTime' . $ret{'recvCount'}};
	}

	return(%ret);
}



#------------------------------#
# mcastNS()                    #
#------------------------------#
sub
mcastNS($)
{
	my ($ereq) = @_;

	my @ret = ();
	my $mcast_ns		= $hash_mcast_ns{$ereq};
	my $mcast_ns_ign_src	= $hash_mcast_ns_ign_src{$mcast_ns};
	push(@ret, $mcast_ns);
	push(@ret, $mcast_ns_ign_src);

	return(@ret);
}



#------------------------------#
# ucastNS()                    #
#------------------------------#
sub
ucastNS($)
{
	my ($ereq) = @_;

	my @ret = ();

	my $ucast_ns		= $hash_ucast_ns{$ereq};
	my $ucast_ns_ign_src	= $hash_ucast_ns_ign_src{$ucast_ns};

	push(@ret, $ucast_ns);
	push(@ret, $ucast_ns_ign_src);

	if($IGN_UNI_NS_SLL) {
		push(@ret, $hash_ucast_ns_ign_sll{$ucast_ns});
		push(@ret, $hash_ucast_ns_ign_sll{$ucast_ns_ign_src});
	}

	return(@ret);
}



#------------------------------#
# ndiscNone2Incomplete()       #
#------------------------------#
sub
ndiscNone2Incomplete($$)
{
	my ($Link, $ereq) = @_;

	my @frames = mcastNS($ereq);

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(0);
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}



#------------------------------#
# ndiscNone2Reachable()        #
#------------------------------#
sub
ndiscNone2Reachable($$)
{
	my ($Link, $ereq) = @_;

	my @frames	= mcastNS($ereq);

	if($ereq eq 'ndisc_ereq_LG') {
		push(@frames, mcastNS('ndisc_ereq_LL'));
	}

	#vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>INITIALIZATION'.
	#		 '</B></U></FONT><BR>');

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(ndiscIncomplete2Reachable($Link,
					$ereq, $frame));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}



#------------------------------#
# ndiscNone2ReachableR()       #
#------------------------------#
sub
ndiscNone2ReachableR($$)
{
	my ($Link, $ereq) = @_;

	my @frames	= mcastNS($ereq);

	#vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>INITIALIZATION'.
	#	'</B></U></FONT><BR>');

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(ndiscIncomplete2ReachableR($Link,
					$ereq, $frame));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}



#------------------------------#
# ndiscNone2ReachableRTest()   #
#------------------------------#
sub
ndiscNone2ReachableRTest($$)
{
	my ($Link, $ereq) = @_;

	my @frames	= mcastNS($ereq);

	#vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
	#	'</B></U></FONT><BR>');

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(ndiscIncomplete2ReachableR($Link,
					$ereq, $frame));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}



#------------------------------#
# ndiscIncomplete2Reachable()  #
#------------------------------#
sub
ndiscIncomplete2Reachable($$$)
{
	my ($Link, $ereq, $mcast_ns) = @_;

	my $erep	= $hash_erep{$ereq};
	my $na		= $hash_na{$mcast_ns};

	vSend($Link, $na);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			return(0);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
		'</B></FONT><BR>');

	return(-1);
}



#------------------------------#
# ndiscIncomplete2ReachableR() #
#------------------------------#
sub
ndiscIncomplete2ReachableR($$$)
{
	my ($Link, $ereq, $mcast_ns) = @_;

	my $erep	= $hash_erep{$ereq};
	my $na		= $hash_na_router{$mcast_ns};

	vSend($Link, $na);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			return(0);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
		'</B></FONT><BR>');

	return(-1);
}



#------------------------------#
# ndiscNone2Stale()            #
#------------------------------#
sub
ndiscNone2Stale($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2Reachable($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscReachable2Stale($Link));
}



#------------------------------#
# ndiscNone2StaleLoose()       #
#------------------------------#
sub
ndiscNone2StaleLoose($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2Reachable($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscReachable2StaleLoose($Link));
}



#------------------------------#
# ndiscNone2StaleR()           #
#------------------------------#
sub
ndiscNone2StaleR($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2ReachableR($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscReachable2Stale($Link));
}



#------------------------------#
# ndiscReachable2Stale()       #
#------------------------------#
sub
ndiscReachable2Stale($)
{
	my ($Link) = @_;

	my $frame	= 'ns_any2any';

	my %ret = vRecvWrapper($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR + 1,
		$SeekTime, 0, $frame);

	if($ret{'recvFrame'} eq $frame) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
			'</B></FONT><BR>');
		return(-1);
	}

	return(0);
}



#------------------------------#
# ndiscReachable2StaleLoose()  #
#------------------------------#
sub
ndiscReachable2StaleLoose($)
{
	my ($Link) = @_;

	my %ret = vRecvWrapper($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR + 1,
		$SeekTime, 0);

	return($ret{'recvCount'});
}



#------------------------------#
# ndiscNone2Delay()            #
#------------------------------#
sub
ndiscNone2Delay($$)
{
	my ($Link, $ereq) = @_;

	if($NOT_USE_FAST_CHANGE_STATE) {
		return(ndiscNone2Delay0($Link, $ereq));
	}

	return(ndiscNone2Delay1($Link, $ereq));
}



#------------------------------#
# ndiscNone2DelayLoose()       #
#------------------------------#
sub
ndiscNone2DelayLoose($$)
{
	my ($Link, $ereq) = @_;

	if($NOT_USE_FAST_CHANGE_STATE) {
		return(ndiscNone2DelayLoose0($Link, $ereq));
	}

	return(ndiscNone2Delay1($Link, $ereq));
}



#------------------------------#
# ndiscNone2DelayR()           #
#------------------------------#
sub
ndiscNone2DelayR($$)
{
	my ($Link, $ereq) = @_;

	if($NOT_USE_FAST_CHANGE_STATE) {
		return(ndiscNone2DelayR0($Link, $ereq));
	}

	return(ndiscNone2DelayR1($Link, $ereq));
}



#------------------------------#
# ndiscNone2Delay0()           #
#------------------------------#
sub
ndiscNone2Delay0($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2Stale($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscStale2Delay($Link, $ereq));
}



#------------------------------#
# ndiscNone2DelayLoose0()      #
#------------------------------#
sub
ndiscNone2DelayLoose0($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2StaleLoose($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscStale2Delay($Link, $ereq));
}



#------------------------------#
# ndiscNone2DelayR0()          #
#------------------------------#
sub
ndiscNone2DelayR0($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2StaleR($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscStale2Delay($Link, $ereq));
}



#------------------------------#
# ndiscNone2Delay1()           #
#------------------------------#
sub
ndiscNone2Delay1($$)
{
	my ($Link, $ereq) = @_;

	my @frames	= mcastNS($ereq);

	my $mcast_ns	= '';

	#vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
	#		 '</B></U></FONT><BR>');

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$mcast_ns = $frame;
				last;
			}
		}
	}

	if($mcast_ns eq '') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS</B></FONT><BR>');
		return(-1);
	}

	my $erep	= $hash_erep{$ereq};
	my $na		= $hash_na_unsol{$mcast_ns};

	vSend($Link, $na);

	%ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			return(0);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
		'</B></FONT><BR>');

	return(-1);
}



#------------------------------#
# ndiscNone2DelayR1()          #
#------------------------------#
sub
ndiscNone2DelayR1($$)
{
	my ($Link, $ereq) = @_;

	my @frames	= mcastNS($ereq);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>INITIALIZATION'.
		'</B></U></FONT><BR>');

	my $mcast_ns	= '';

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$mcast_ns = $frame;
				last;
			}
		}
	}

	if($mcast_ns eq '') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS</B></FONT><BR>');
		return(-1);
	}

	my $erep	= $hash_erep{$ereq};
	my $na		= $hash_na_unsol_router{$mcast_ns};

	vSend($Link, $na);

	%ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			return(0);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
		'</B></FONT><BR>');

	return(-1);
}



#------------------------------#
# ndiscStale2Delay()           #
#------------------------------#
sub
ndiscStale2Delay($$)
{
	my ($Link, $ereq) = @_;

	my $erep	= $hash_erep{$ereq};

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			return(0);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
		'</B></FONT><BR>');

	return(-1);
}



#------------------------------#
# ndiscNone2ProbeWithNS()      #
#------------------------------#
sub
ndiscNone2ProbeWithNS($$)
{
	my ($Link, $ereq) = @_;

	if(ndiscNone2Delay($Link, $ereq) < 0) {
		return(-1);
	}

	return(ndiscDelay2Probe($Link, $ereq));
}



#------------------------------#
# ndiscDelay2Probe()           #
#------------------------------#
sub
ndiscDelay2Probe($$)
{
	my ($Link, $ereq) = @_;

	my @frames = ucastNS($ereq);

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					return(0);
				}
			}

			next;
		}

		last;
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}



#----------------------------------------------#
# ndiscStale2ReachableByPacketForwarding1()    #
#----------------------------------------------#
sub
ndiscStale2ReachableByPacketForwarding1($)
{
	my ($Link) = @_;

	my $erep	= 'ndisc_erep_offlink';
	my $ereq	= 'ndisc_ereq_offlink';
	my $got_erep	= 0;

	my @frames = ('ns_l2l', 'ns_g2l');

	my %nd_local_hash = (
		'ns_l2l'	=> 'na_l2l',
		'ns_g2l'	=> 'na_l2g',
	);

	my $bool = 0;

	vClear($Link);
	vSend($Link, $ereq);
	%ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);
	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				vClear($Link);
				vSend($Link, $nd_local_hash{$frame});
				$bool ++;
				last;
			}
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
		return(-1);
	}

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return(-1);
	}

	return(0);
}

1;
