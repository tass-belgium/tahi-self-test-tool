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
# $TAHI: ct/nd.p2/common.pm,v 1.23 2010/05/07 04:30:16 akisada Exp $
#
########################################################################

package common;

use Exporter;
use V6evalTool;
require './config.pl';

BEGIN {
	$V6evalTool::TestVersion	= '$Name: V6LC_5_0_0 $';
}

END   {}

@ISA = qw(Exporter);

@EXPORT = qw(
	$wait_rebootcmd
	$sleep_after_reboot
	%pktdesc
	%tn1_mcast_nd_offlink
	%tn1_mcast_nd_onlink
	%tn1_mcast_nd_onlinkX
	%tn1_mcast_nd_common
	%tr1_mcast_nd_common
	%tr2_mcast_nd_common
	%tr3_mcast_nd_common
	%tn1_ucast_nd_common
	%tr1_ucast_nd_common
	%tr2_ucast_nd_common
	%tn1_ucast_nd_diff
	%tr1_ucast_nd_diff
	%tr2_ucast_nd_diff
	$true
	$false
	$Link0
	$Link1
	$TimeOut
	$RETRANS_TIMER
	$DELAY_FIRST_PROBE_TIME
	$MAX_UNICAST_SOLICIT
	$MAX_MULTICAST_SOLICIT
	$MAX_INITIAL_RTR_ADVERT_INTERVAL
	$MAX_INITIAL_RTR_ADVERTISEMENTS
	$MAX_RA_DELAY_TIME
	$MIN_DELAY_BETWEEN_RAS
	$MAX_FINAL_RTR_ADVERTISEMENTS
	$MAX_RTR_SOLICITATIONS
	$RTR_SOLICITATION_INTERVAL
	$MAX_RTR_SOLICITATION_DELAY
	$REACHABLE_TIME
	$MAX_RANDOM_FACTOR
	$min_MaxRtrAdvInterval
	$max_MaxRtrAdvInterval
	$min_MinRtrAdvInterval
	$max_MinRtrAdvInterval
	$min_AdvLinkMTU
	$max_AdvLinkMTU
	$min_AdvReachableTime
	$max_AdvReachableTime
	$min_AdvRetransTimer
	$max_AdvRetransTimer
	$min_AdvCurHopLimit
	$max_AdvCurHopLimit
	$min_AdvDefaultLifetime
	$max_AdvDefaultLifetime
	$min_AdvValidLifetime
	$max_AdvValidLifetime
	$min_AdvPreferredLifetime
	$max_AdvPreferredLifetime
	commonSetup_1_1
	commonSetup_1_1_v6LC_2_2_13_A
	commonSetup_1_2
	commonSetup_1_3
	commonCleanup
	exitPass
	exitFail
	exitFatal
	exitInitFail
	exitHostOnly
	exitRouterOnly
	exitTypeMismatch
	ignoreDAD
	$nut_rtime
	$nut_chlim
	$tr1_default
	$tr1_prefix
	$tr1_change_param
	$tr2_change_param
	$tr3_change_param
	$tr1_force
	$tr2_force
	$tr3_force
	$force_reboot
	$tr1_cache
	$tn1_offlink_cache
	$tn1_onlink_cache
	$tn1_onlink_cacheX
	$tr2_default
	$tr2_prefix
	$tn1_cache
	$tn1_cache_link1
	$tr2_cache
	$tr3_default
	$tr3_prefix
	$tr3_cache
	$tr1_route_2_3_17
	$rut_addr_v6LC_2_3_16_A
	$rut_rtadvd
	$rut_ipv6_forwarding_disable
	$rut_rtadvd_param_change
	$use_slave_interface
	tn1_none_to_incomplete
	tr1_none_to_incomplete
	tr2_none_to_incomplete
	tn1_none_to_reachable
	tr1_none_to_reachable
	tr2_none_to_reachable
	tn1_none_to_stale
	tr1_none_to_stale
	tr2_none_to_stale
	tn1_none_to_probe
	tr1_none_to_probe
	is_tn1_incomplete
	is_tr2_incomplete
	is_tn1_stale
	is_tr1_stale
	is_tr2_stale
	is_tn1_stale_diff
	is_tr1_stale_diff
	is_tr2_stale_diff
	is_tn1_reachable
	is_tn1_probe
	getaddr_v6LC_2_3_16_A
	stopToRtAdv
	startIPv6forwarding
	register
);

push(@EXPORT, sort(@V6evalTool::EXPORT));



#------------------------------#
# global constants             #
#------------------------------#
$true					= 1;
$false					= 0;
$Link0					= 'Link0';
$Link1					= 'Link1';
$RETRANS_TIMER				= 1;
$MAX_RTR_SOLICITATION_DELAY		= 1;
$DELAY_FIRST_PROBE_TIME			= 5;
$MAX_MULTICAST_SOLICIT			= 3;
$MAX_UNICAST_SOLICIT			= 3;
$DupAddrDetectTransmits			= 1;
$MAX_INITIAL_RTR_ADVERT_INTERVAL	= 16;
$MAX_INITIAL_RTR_ADVERTISEMENTS		= 3;
$MAX_RA_DELAY_TIME			= 0.5;
$MIN_DELAY_BETWEEN_RAS			= 3;
$MAX_FINAL_RTR_ADVERTISEMENTS		= 3;
$MAX_RTR_SOLICITATIONS			= 3;
$RTR_SOLICITATION_INTERVAL		= 4;
$REACHABLE_TIME				= 30;
$MAX_RANDOM_FACTOR			= 1.5;

%tr1_mcast_nd_common	= (
	'tr1_mcast_ns_linklocal_common'	=> 'tr1_na_linklocal_common',
	'tr1_mcast_ns_global_common'	=> 'tr1_na_global_common',
);

%tn1_mcast_nd_common	= (
	'tn1_mcast_ns_linklocal_common'	=> 'tn1_na_linklocal_common',
	'tn1_mcast_ns_global_common'	=> 'tn1_na_global_common',
);

%tr2_mcast_nd_common	= (
	'tr2_mcast_ns_linklocal_common'	=> 'tr2_na_linklocal_common',
	'tr2_mcast_ns_global_common'	=> 'tr2_na_global_common',
);

%tr3_mcast_nd_common	= (
	'tr3_mcast_ns_linklocal_common'	=> 'tr3_na_linklocal_common',
	'tr3_mcast_ns_global_common'	=> 'tr3_na_global_common',
);

%tr1_ucast_nd_common	= (
	'tr1_ucast_ns_linklocal'	=> 'tr1_na_linklocal_common',
	'tr1_ucast_ns_linklocal_sll'	=> 'tr1_na_linklocal_common',
	'tr1_ucast_ns_global'		=> 'tr1_na_global_common',
	'tr1_ucast_ns_global_sll'	=> 'tr1_na_global_common',
);

%tn1_ucast_nd_common	= (
	'tn1_ucast_ns_linklocal'	=> 'tn1_na_linklocal_common',
	'tn1_ucast_ns_linklocal_sll'	=> 'tn1_na_linklocal_common',
	'tn1_ucast_ns_global'		=> 'tn1_na_global_common',
	'tn1_ucast_ns_global_sll'	=> 'tn1_na_global_common',
);

%tr2_ucast_nd_common	= (
	'tr2_ucast_ns_linklocal'	=> 'tr2_na_linklocal_common',
	'tr2_ucast_ns_linklocal_sll'	=> 'tr2_na_linklocal_common',
	'tr2_ucast_ns_global'		=> 'tr2_na_global_common',
	'tr2_ucast_ns_global_sll'	=> 'tr2_na_global_common',
);

%tn1_ucast_nd_diff	= (
	'tn1_ucast_ns_linklocal_diff'		=> 'tn1_na_linklocal_diff',
	'tn1_ucast_ns_linklocal_sll_diff'	=> 'tn1_na_linklocal_diff',
	'tn1_ucast_ns_global_diff'		=> 'tn1_na_global_diff',
	'tn1_ucast_ns_global_sll_diff'		=> 'tn1_na_global_diff',
);

%tr1_ucast_nd_diff	= (
	'tr1_ucast_ns_linklocal_diff'		=> 'tr1_na_linklocal_diff',
	'tr1_ucast_ns_linklocal_sll_diff'	=> 'tr1_na_linklocal_diff',
	'tr1_ucast_ns_global_diff'		=> 'tr1_na_global_diff',
	'tr1_ucast_ns_global_sll_diff'		=> 'tr1_na_global_diff',
);

%tr2_ucast_nd_diff	= (
	'tr2_ucast_ns_linklocal_diff'		=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_linklocal_sll_diff'	=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_global_diff'		=> 'tr2_na_linklocal_diff',
	'tr2_ucast_ns_global_sll_diff'		=> 'tr2_na_linklocal_diff',
);

%tn1_mcast_nd_offlink	= (
	'tn1_mcast_ns_linklocal_offlink'	=> 'tn1_na_linklocal_offlink',
	'tn1_mcast_ns_global_offlink'		=> 'tn1_na_global_offlink',
);

%tn1_mcast_nd_onlink	= (
	'tn1_mcast_ns_linklocal_onlink'	=> 'tn1_na_linklocal_onlink',
	'tn1_mcast_ns_global_onlink'	=> 'tn1_na_global_onlink',
);

%tn1_mcast_nd_onlinkX	= (
	'tn1_mcast_ns_linklocal_onlinkX'	=> 'tn1_na_linklocal_onlinkX',
	'tn1_mcast_ns_global_onlinkX'		=> 'tn1_na_global_onlinkX',
);


#------------------------------#
# global variables             #
#------------------------------#
$TimeOut			= $RETRANS_TIMER + 1;
$master_interface		= $Link0;
$slave_interface		= $Link1;

$nut_rtime			= $false;
$nut_chlim			= $false;
$tr1_default			= $false;
$tr1_prefix			= $false;
$tr1_change_param		= $false;
$tr2_change_param		= $false;
$tr3_change_param		= $false;
$tr1_force			= $false;
$tr2_force			= $false;
$tr3_force			= $false;
$force_reboot			= $false;
$tr1_cache			= $false;
$tn1_cache			= $false;
$tn1_cache_link1		= $false;
$tn1_offlink_cache		= $false;
$tn1_onlink_cache		= $false;
$tn1_onlink_cacheX		= $false;
$tr2_default			= $false;
$tr2_prefix			= $false;
$tr2_cache			= $false;
$tr3_default			= $false;
$tr3_prefix			= $false;
$tr3_cache			= $false;
$tr1_route_2_3_17		= $false;
$rut_addr_v6LC_2_3_16_A		= $false;
$rut_rtadvd			= $false;
$rut_ipv6_forwarding_disable	= $false;
$rut_rtadvd_param_change	= $false;
$use_slave_interface		= $false;



%pktdesc        = (
	'tn1_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TN1 (link-local) -&gt; NUT (link-local)',

	'tn1_na_global_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TN1 (link-local) -&gt; NUT (global)',

	'tn1_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN1 (link-local)',

	'tn1_ereq_diff'
		=> '    Send Echo Request: '.
			'TN1 (link-local) -&gt; NUT (link-local)',

	'tn1_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tr1_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'ra_2_2_13_A'
		=> '    Send RA (rtime=600000) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR1 (link-local) solicited-node multicast address',

	'tr1_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR1 (link-local) solicited-node multicast address',

	'tr1_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR1 (link-local) -&gt; NUT (global)',

	'tr1_ereq_common'
		=> '    Send Echo Request: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tn1_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tr1_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; all-nodes multicast address',

	'tr1_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr2_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_common'
		=> '    Send RA w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr2_ra_common_sll'
		=> '    Send RA w/ SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr2_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR2 (link-local) solicited-node multicast address',

	'tn1_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TN1 (link-local) solicited-node multicast address',

	'tr2_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr3_na_linklocal_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tn1_na_linklocal_common'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (link-local) -&gt; NUT (link-local)',

	'tr1_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; NUT (link-local)',

	'tr1_na_global_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR1 (link-local) -&gt; NUT (global)',

	'tr2_na_linklocal_diff'
		=> '    Send NA (RSO) w/ TLL (diff): '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr2_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR2 (link-local) -&gt; NUT (global)',

	'tr3_na_global_common'
		=> '    Send NA (RSO) w/ TLL: '.
			'TR3 (link-local) -&gt; NUT (global)',

	'tn1_na_global_common'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (link-local) -&gt; NUT (global)',

	'tr2_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR2 (link-local) solicited-node multicast address',

	'tn1_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TN1 (link-local) solicited-node multicast address',

	'tr1_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tn1_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN1 (link-local)',

	'tn1_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN1 (link-local)',

	'tr2_ucast_ns_linklocal'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_diff'
		=> '    Recv NS w/o SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_sll'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr1_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr1_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR1 (link-local)',

	'tr2_ucast_ns_linklocal_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ucast_ns_global_sll_diff'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TR2 (link-local)',

	'tr2_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr2_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_force_cleanup'
		=> '    Send RA (rltime=0, rtime=30000, retrans=1000, '.
			'vltime=0, pltime=0) w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr2_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR2 (link-local) -&gt; all-nodes multicast address',

	'tn1_ereq_common'
		=> '    Send Echo Request: '.
			'TN1 (link-local) -&gt; NUT (link-local)',

	'tr2_ereq_common'
		=> '    Send Echo Request: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr3_ereq_common'
		=> '    Send Echo Request: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tr2_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr3_erep_common'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR3 (link-local)',

	'tr1_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR1 (link-local)',

	'tr2_erep_diff'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr2_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR2 (link-local) -&gt; NUT (link-local)',

	'tr2_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR2 (link-local)',

	'tr3_ra_common_sll'
		=> '    Send RA w/ SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_ra_cleanup'
		=> '    Send RA (rltime=0, vltime=0, pltime=0) w/o SLL: '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_mcast_ns_linklocal_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TR3 (link-local) solicited-node multicast address',

	'tr3_mcast_ns_global_common'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TR3 (link-local) solicited-node multicast address',

	'tr3_na_cleanup'
		=> '    Send NA (RsO) w/ TLL (diff): '.
			'TR3 (link-local) -&gt; all-nodes multicast address',

	'tr3_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TR3 (link-local) -&gt; NUT (link-local)',

	'tr3_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TR3 (link-local)',

	'tn1_mcast_ns_linklocal_offlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; '.
			'TN1 (off-link global) '.
			'solicited-node multicast address',

	'tn1_na_linklocal_offlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (off-link global) -&gt; NUT (link-local)',

	'tn1_mcast_ns_global_offlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; '.
			'TN1 (off-link global) '.
			'solicited-node multicast address',

	'tn1_na_global_offlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (off-link global) -&gt; NUT (global)',

	'tn1_offlink_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN1 (link-local) -&gt; all-nodes multicast address',

	'tn1_offlink_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN1 (off-link global) -&gt; NUT (link-local)',

	'tn1_offlink_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN1 (off-link global)',

	'tn1_mcast_ns_linklocal_onlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN1 (global) '.
			'solicited-node multicast address',

	'tn1_mcast_ns_linklocal_onlinkX'
		=> '    Recv NS w/ SLL: '.
			'NUT (link-local) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn1_na_linklocal_onlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (global) -&gt; NUT (link-local)',

	'tn1_na_linklocal_onlinkX'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn1_mcast_ns_global_onlink'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN1 (global) '.
			'solicited-node multicast address',

	'tn1_mcast_ns_global_onlinkX'
		=> '    Recv NS w/ SLL: '.
			'NUT (global) -&gt; TN2 (global) '.
			'solicited-node multicast address',

	'tn1_na_global_onlink'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN1 (global) -&gt; NUT (global)',

	'tn1_na_global_onlinkX'
		=> '    Send NA (rSO) w/ TLL: '.
			'TN2 (global) -&gt; NUT (global)',

	'tn1_onlink_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN1 (link-local) -&gt; all-nodes multicast address',

	'tn1_onlink_na_cleanupX'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN2 (link-local) -&gt; all-nodes multicast address',

	'tn1_onlink_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN1 (global) -&gt; NUT (link-local)',

	'tn1_onlink_ereq_cleanupX'
		=> '    Send Echo Request: '.
			'TN2 (global) -&gt; NUT (link-local)',

	'tn1_onlink_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN1 (global)',

	'tn1_onlink_erep_cleanupX'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN2 (global)',

	'tn1_na_cleanup'
		=> '    Send NA (rsO) w/ TLL (diff): '.
			'TN1 (link-local) -&gt; all-nodes multicast address',

	'tn1_ereq_cleanup'
		=> '    Send Echo Request: '.
			'TN1 (link-local) -&gt; NUT (link-local)',

	'tn1_erep_cleanup'
		=> '    Recv Echo Reply: '.
			'NUT (link-local) -&gt; TN1 (link-local)',
);


#------------------------------#
# commonSetup_1_1()            #
#------------------------------#

# Common Test Setup 1.1
# Summary:
# 	This minimal setup procedure provides
# 	the NUT with a default router TR1, a global prefix,
#	and ensures that the NUT can communicate with TR1.

sub
commonSetup_1_1($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Common Test Setup 1.1'.
		'</B></U></FONT><BR>');

	for( ; ; ) {
		if($V6evalTool::NutDef{'Type'} eq 'host') {

# 1.
# 	If the NUT is a host,
# 	TR1 transmits a Router Advertisement to the all-nodes multicast address.
# 	The Router Advertisement includes a Prefix Advertisement
# 	with a global prefix and the L and A bits set.
# 	This should cause the NUT to add TR1 to its Default Router List,
# 	configure a global address, and compute Reachable Time.
# 	The Router and Prefix Lifetimes are long enough such
# 	that they do not expire during the test. 

			vSend($Link, 'tr1_ra_common');

			$tr1_default	= $true;
			$tr1_prefix	= $true;

			ignoreDAD($Link);

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'router') {

# 2.
# 	If the NUT is a router,
# 	configure a default route with TR1 as the next hop.

			if(vRemote(
				'route.rmt',
				'cmd=add',
				'prefix=default',
				"gateway=fe80::200:ff:fe00:a0a0",
				"if=$V6evalTool::NutDef{'Link0_device'}"
			)) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'route.rmt: Could\'t set route'.
					'</B></FONT><BR>');
				return($false);
			}

			$tr1_default	= $true;

			last;
		}

		exitTypeMismatch($Link);
		last;
	}

# 3.
# 	TR1 transmits an Echo Request to the NUT
# 	and responds to Neighbor Solicitations from the NUT.
# 	Wait for an Echo Reply from the NUT.
# 	This should cause the NUT to resolve the address of TR1
# 	and create a Neighbor Cache entry for TR1 in state REACHABLE.

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#--------------------------------------#
# commonSetup_1_1_v6LC_2_2_13_A()      #
#--------------------------------------#

# Common Test Setup 1.1
# Summary:
# 	This minimal setup procedure provides
# 	the NUT with a default router TR1, a global prefix,
#	and ensures that the NUT can communicate with TR1.

sub
commonSetup_1_1_v6LC_2_2_13_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Common Test Setup 1.1'.
		'</B></U></FONT><BR>');

	for( ; ; ) {
		if($V6evalTool::NutDef{'Type'} eq 'host') {

# 1.
# 	If the NUT is a host,
# 	TR1 transmits a Router Advertisement to the all-nodes multicast address.
# 	The Router Advertisement includes a Prefix Advertisement
# 	with a global prefix and the L and A bits set.
# 	This should cause the NUT to add TR1 to its Default Router List,
# 	configure a global address, and compute Reachable Time.
# 	The Router and Prefix Lifetimes are long enough such
# 	that they do not expire during the test. 

			vSend($Link, 'ra_2_2_13_A');

			$tr1_default	= $true;
			$tr1_prefix	= $true;
			$tr1_force	= $true;

			ignoreDAD($Link);

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'router') {

# 2.
# 	If the NUT is a router,
# 	configure a default route with TR1 as the next hop.

			if(vRemote(
				'route.rmt',
				'cmd=add',
				'prefix=default',
				"gateway=fe80::200:ff:fe00:a0a0",
				"if=$V6evalTool::NutDef{'Link0_device'}"
			)) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'route.rmt: Could\'t set route'.
					'</B></FONT><BR>');
				return($false);
			}

			$tr1_default	= $true;

			last;
		}

		exitTypeMismatch($Link);
		last;
	}

# 3.
# 	TR1 transmits an Echo Request to the NUT
# 	and responds to Neighbor Solicitations from the NUT.
# 	Wait for an Echo Reply from the NUT.
# 	This should cause the NUT to resolve the address of TR1
# 	and create a Neighbor Cache entry for TR1 in state REACHABLE.

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# commonSetup_1_2()            #
#------------------------------#

# Common Test Setup 1.2
# Summary:
# 	This minimal setup procedure provides the NUT
# 	with two default routers TR1 and TR2, a global prefix,
# 	and ensures that the NUT can communicate with TR1 and TR2.

sub
commonSetup_1_2($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Common Test Setup 1.2'.
		'</B></U></FONT><BR>');

	for( ; ; ) {
		if($V6evalTool::NutDef{'Type'} eq 'host') {
# 1.
# 	TR1 and TR2 each transmit a Router Advertisement
# 	to the all-nodes multicast address.
# 	The Router Advertisements include a Prefix Advertisement
# 	with a global prefix and the L and A bits set.
# 	This should cause the NUT to add TR1 and TR2
# 	to its Default Router List, configure a global address,
# 	and compute Reachable Time.
# 	The Router and Prefix Lifetimes are long enough such
# 	that they do not expire during the test.

			vSend($Link, 'tr1_ra_common');

			$tr1_default	= $true;
			$tr1_prefix	= $true;

			ignoreDAD($Link);

			vSend($Link, 'tr2_ra_common');

			$tr2_default	= $true;
			$tr2_prefix	= $true;

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'router') {

# 	(If the NUT is a router, configure it to have an address
# 	with the advertised prefix.)

#			if(vRemote(
#				'route.rmt',
#				'cmd=add',
#				'prefix=default',
#				"gateway=fe80::200:ff:fe00:a0a0",
#				"if=$V6evalTool::NutDef{'Link0_device'}"
#			)) {
#				vLogHTML('<FONT COLOR="#FF0000"><B>'.
#					'route.rmt: Could\'t set route'.
#					'</B></FONT><BR>');
#				return($false);
#			}
#
#			$tr1_default	= $true;

			last;
		}

		exitTypeMismatch($Link);
		last;
	}

# 2.
# 	TR1 and TR2 each transmit an Echo Request to the NUT
# 	and respond to Neighbor Solicitations from the NUT.
# 	Wait for Echo Replies from the NUT.
# 	This should cause the NUT to resolve the addresses of TR1 and TR2
# 	and create a Neighbor Cache entry for each router in state REACHABLE.

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	$bool	= $false;
	@frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# commonSetup_1_3()            #
#------------------------------#

# Common Test Setup 1.3 
# Summary:
# 	This minimal setup procedure provides the NUT
# 	with three default routers TR1, TR2, and TR3, a global prefix,
# 	and ensures that the NUT can communicate with TR1, TR2, and TR3.

sub
commonSetup_1_3($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Common Test Setup 1.3'.
		'</B></U></FONT><BR>');

	for( ; ; ) {
		if($V6evalTool::NutDef{'Type'} eq 'host') {
# 1.
# 	TR1, TR2, and TR3 each transmit a Router Advertisement
# 	to the all-nodes multicast address.
# 	The Router Advertisements include a Prefix Advertisement
# 	with a global prefix and the L and A bits set.
# 	This should cause the NUT to add all three routers
# 	to its Default Router List, configure a global address,
# 	and compute Reachable Time.
# 	The Router and Prefix Lifetimes are long enough
#	such that they do not expire during the test.

			vSend($Link, 'tr1_ra_common');

			$tr1_default	= $true;
			$tr1_prefix	= $true;

			ignoreDAD($Link);

			vSend($Link, 'tr2_ra_common');

			$tr2_default	= $true;
			$tr2_prefix	= $true;

			vSend($Link, 'tr3_ra_common');

			$tr3_default	= $true;
			$tr3_prefix	= $true;

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'router') {
			last;
		}

		exitTypeMismatch($Link);
		last;
	}

# 2.
# 	TR1, TR2, and TR3 each transmit an Echo Request to the NUT
# 	and respond to Neighbor Solicitations from the NUT.
# 	Wait for Echo Replies from the NUT.
# 	This should cause the NUT to resolve the addresses
# 	of all three routers and create a Neighbor Cache entry
#	for each router in state REACHABLE.

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}



	$bool	= $false;
	@frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}



	$bool	= $false;
	@frames	= sort(keys(%tr3_mcast_nd_common));

	vSend($Link, 'tr3_ereq_common');

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr3_mcast_nd_common{$frame});
			$tr3_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr3_erep_common');
	unless($ret{'recvFrame'} eq 'tr3_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#--------------------------------------#
# additionalCleanup_v6LC_2_3_16_A()    #
#--------------------------------------#

sub
additionalCleanup_v6LC_2_3_16_A($)
{
	my ($Link) = @_;

	my $addr = getaddr_v6LC_2_3_16_A($Link);
	if($addr eq '') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t calculate the address for RUT'.
			'</B></FONT><BR>');

		return($false);
	}

	if(vRemote(
		'manualaddrconf.rmt',
		"if=$V6evalTool::NutDef{'Link0_device'}",
		'addr=3ffe:501:ffff::',
		'len=64',
		'type=delete',
		'subnet_router_anycast=true'
	)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'manualaddrconf.rmt: Could\'t remove the address'.
			'</B></FONT><BR>');
		return($false);
	}

	if(vRemote(
		'manualaddrconf.rmt',
		"if=$V6evalTool::NutDef{'Link0_device'}",
		"addr=$addr",
		'len=64',
		'type=delete'
	)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'manualaddrconf.rmt: Could\'t remove the address'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# commonCleanup()              #
#------------------------------#

# Common Test Cleanup (for all tests)
# Summary:
# 	The Cleanup procedure should cause the NUT
# 	to transition Neighbor Cache entries created in this test
# 	to state INCOMPLETE
# 	and remove any entries from its Default Router and Prefix Lists.

sub
commonCleanup($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Common Test Cleanup'.
		'</B></U></FONT><BR>');

	if($force_reboot) {
		if(vRemote('reboot.rmt', "timeout=$wait_rebootcmd")) {
			vLogHTML('<FONT COLOR="#FF0000"><B>reboot.rmt: '.
				'Could\'t reboot</B></FONT><BR>');
			exitFatal($Link0);
		}

		if($sleep_after_reboot) {
			vSleep($sleep_after_reboot);
		}

		my $waitingTime = $MAX_RTR_SOLICITATION_DELAY
			+ ($RTR_SOLICITATION_INTERVAL * $MAX_RTR_SOLICITATIONS)
			+ $MAX_RTR_SOLICITATION_DELAY;
		vRecv($Link0, $waitingTime, 0, 0);

		return($true);
	}


	if($rut_ipv6_forwarding_disable) {
		startIPv6forwarding($Link);
	}

	if($rut_rtadvd) {
		stopToRtAdv($Link);
	}

	if($rut_rtadvd_param_change) {
		if(vRemote('racontrol.rmt',
			'mode=start',
			'maxinterval=600',
			'mininterval=200',
			'mtu=1500',
			'rtime=30000',
			'retrans=1000',
			'chlim=64',
			'rltime=1800',
			'vltime=2592000',
			'pinfoflagsL=true',
			'pltime=604800',
			'pinfoflagsA=true',
			"link0=$V6evalTool::NutDef{'Link0_device'}")) {

			vLogHTML('<FONT COLOR="#FF0000">racontrol.rmt: '.
				'Can\'t enable RA function</FONT><BR>');

			exitFatal($Link);
		}

		$rut_rtadvd_param_change  = $false;
		$rut_rtadvd = $true;
	}

	if($rut_rtadvd) {
		stopToRtAdv($Link);
	}

	if($nut_chlim) {
		if(vRemote('racontrol.rmt',
			'mode=start',
			"link0=$V6evalTool::NutDef{'Link0_device'}",
			"chlim=64")) {

			vLogHTML('<FONT COLOR="#FF0000">racontrol.rmt: '.
				'Can\'t enable RA function</FONT><BR>');

			exitFatal($Link);
		}

		$nut_chlim  = $false;
		$rut_rtadvd = $true;
	}

	if($rut_rtadvd) {
		stopToRtAdv($Link);
	}

	if($nut_rtime) {
		if(vRemote('racontrol.rmt',
			'mode=start',
			"link0=$V6evalTool::NutDef{'Link0_device'}",
			"rtime=30000")) {

			vLogHTML('<FONT COLOR="#FF0000">racontrol.rmt: '.
				'Can\'t enable RA function</FONT><BR>');

			exitFatal($Link);
		}

		$nut_rtime  = $false;
		$rut_rtadvd = $true;
	}

	if($rut_rtadvd) {
		stopToRtAdv($Link);
	}

	if($tn1_offlink_cache &&
		!cache_clean(
			$Link,
			'tn1_offlink_na_cleanup',
			'tn1_offlink_ereq_cleanup',
			'tn1_offlink_erep_cleanup',
			'tn1_mcast_ns_linklocal_offlink'
		)
	) {
		return($false);
	}

	if($tn1_onlink_cache &&
		!cache_clean(
			$Link,
			'tn1_onlink_na_cleanup',
			'tn1_onlink_ereq_cleanup',
			'tn1_onlink_erep_cleanup',
			'tn1_mcast_ns_linklocal_onlink'
		)
	) {
		return($false);
	}

	if($tn1_onlink_cacheX &&
		!cache_clean(
			$Link,
			'tn1_onlink_na_cleanupX',
			'tn1_onlink_ereq_cleanupX',
			'tn1_onlink_erep_cleanupX',
			'tn1_mcast_ns_linklocal_onlinkX'
		)
	) {
		return($false);
	}

	if($tn1_cache &&
		!cache_clean(
			$Link,
			'tn1_na_cleanup',
			'tn1_ereq_cleanup',
			'tn1_erep_cleanup',
			'tn1_mcast_ns_linklocal_common'
		)
	) {
		return($false);
	}

	if($tr3_cache &&
		!cache_clean(
			$Link,
			'tr3_na_cleanup',
			'tr3_ereq_cleanup',
			'tr3_erep_cleanup',
			'tr3_mcast_ns_linklocal_common'
		)
	) {
		return($false);
	}

	if($tr2_cache &&
		!cache_clean(
			$Link,
			'tr2_na_cleanup',
			'tr2_ereq_cleanup',
			'tr2_erep_cleanup',
			'tr2_mcast_ns_linklocal_common'
		)
	) {
		return($false);
	}

	if($tr1_cache &&
		!cache_clean(
			$Link,
			'tr1_na_cleanup',
			'tr1_ereq_cleanup',
			'tr1_erep_cleanup',
			'tr1_mcast_ns_linklocal_common'
		)
	) {
		return($false);
	}

	for( ; ; ) {
		if($V6evalTool::NutDef{'Type'} eq 'host') {
# 1.
# 	If a TR transmitted a Router Advertisement in the Test Setup
# 	or Procedure, that TR transmits a Router Advertisement
# 	with the Router Lifetime and each Prefix Lifetime,
# 	if applicable, set to zero.

			if((($tr3_default) && ($tr3_prefix)) ||
				$tr3_change_param) {

				if($tr3_force) {
					vSend($Link, 'tr3_ra_force_cleanup');
				} else {
					vSend($Link, 'tr3_ra_cleanup');
				}
			}

			if((($tr2_default) && ($tr2_prefix)) ||
				$tr2_change_param) {

				if($tr2_force) {
					vSend($Link, 'tr2_ra_force_cleanup');
				} else {
					vSend($Link, 'tr2_ra_cleanup');
				}
			}

			if((($tr1_default) && ($tr1_prefix)) ||
				$tr1_change_param) {

				if($tr1_force) {
					vSend($Link, 'tr1_ra_force_cleanup');
				} else {
					vSend($Link, 'tr1_ra_cleanup');
				}
			}

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'router') {
			if($tr1_route_2_3_17) {
				if(vRemote(
					'route.rmt',
					'cmd=delete',
					'prefix=3ffe:501:ffff::',
					'prefixlen=64',
					"gateway=fe80::200:ff:fe00:a0a0",
					"if=$V6evalTool::NutDef{'Link0_device'}"
				)) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'route.rmt: Could\'t '.
						'delete the route'.
						'</B></FONT><BR>');
					return($false);
				}
			}

			if($tr2_default) {
				if(vRemote(
					'route.rmt',
					'cmd=delete',
					'prefix=default',
					"gateway=fe80::200:ff:fe00:a1a1",
					"if=$V6evalTool::NutDef{'Link0_device'}"
				)) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'route.rmt: Could\'t '.
						'delete the route'.
						'</B></FONT><BR>');
					return($false);
				}
			}

			if($tr1_default) {
				if(vRemote(
					'route.rmt',
					'cmd=delete',
					'prefix=default',
					"gateway=fe80::200:ff:fe00:a0a0",
					"if=$V6evalTool::NutDef{'Link0_device'}"
				)) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'route.rmt: Could\'t '.
						'delete the route'.
						'</B></FONT><BR>');
					return($false);
				}
			}

			last;
		}

		if($V6evalTool::NutDef{'Type'} eq 'special') {
			if((($tr3_default) && ($tr3_prefix)) ||
				$tr3_change_param) {

				if($tr3_force) {
					exitTypeMismatch($Link);
				} else {
					exitTypeMismatch($Link);
				}
			}

			if((($tr2_default) && ($tr2_prefix)) ||
				$tr2_change_param) {

				if($tr2_force) {
					exitTypeMismatch($Link);
				} else {
					exitTypeMismatch($Link);
				}
			}

			if((($tr1_default) && ($tr1_prefix)) ||
				$tr1_change_param) {

				if($tr1_force) {
					exitTypeMismatch($Link);
				} else {
					exitTypeMismatch($Link);
				}
			}

			if($tr1_route_2_3_17) {
					exitTypeMismatch($Link);
			}

			if($tr2_default) {
					exitTypeMismatch($Link);
			}

			if($tr1_default) {
					exitTypeMismatch($Link);
			}

			last;
		}

		return($false);
		last;
	}

	if($rut_addr_v6LC_2_3_16_A &&
		!additionalCleanup_v6LC_2_3_16_A($Link)
	) {
		return($false);
	}

	return($true);
}



#------------------------------#
# exitPass()                   #
#------------------------------#
sub
exitPass($)
{
	my ($Link) = @_;

	vLogHTML('<B>PASS</B><BR>');
	exitCommon($V6evalTool::exitPass, $Link);
}



#------------------------------#
# exitFail()                   #
#------------------------------#
sub
exitFail($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000"><B>FAIL</B></FONT><BR>');
	exitCommon($V6evalTool::exitFail, $Link);
}



#------------------------------#
# exitFatal()                  #
#------------------------------#
sub
exitFatal($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000"><B>internal error</B></FONT><BR>');
	exit($V6evalTool::exitFatal);
}



#------------------------------#
# exitInitFail()               #
#------------------------------#
sub
exitInitFail($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000"><B>Initialization Fail</B></FONT><BR>');
	exitCommon($V6evalTool::exitInitFail, $Link);
}



#------------------------------#
# exitHostOnly()               #
#------------------------------#
sub
exitHostOnly($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#00FF00"><B>Host Only</B></FONT><BR>');
	exitCommon($V6evalTool::exitHostOnly, $Link);
}



#------------------------------#
# exitRouterOnly()             #
#------------------------------#
sub
exitRouterOnly($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#00FF00"><B>Router Only</B></FONT><BR>');
	exitCommon($V6evalTool::exitRouterOnly, $Link);
}



#------------------------------#
# exitTypeMismatch()           #
#------------------------------#
sub
exitTypeMismatch($)
{
	my ($Link) = @_;

	my $type = $V6evalTool::NutDef{'Type'}?
			$V6evalTool::NutDef{'Type'}:
			undef;

	my $html  = '<FONT COLOR="#00FF00"><B>Type Mismatch';
	   $html .= $type? " -- $type": '';
	   $html .= '</B></FONT><BR>';

	vLogHTML($html);

	exitCommon($V6evalTool::exitTypeMismatch, $Link);
}



#------------------------------#
# exitCommon()                 #
#------------------------------#
sub
exitCommon($$)
{
	my ($ecode, $Link) = @_;

	unless(commonCleanup($Link)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Cleanup Fail'.
			'</B></FONT><BR>');

		$ecode = $V6evalTool::exitCleanupFail;
	}

	if($use_slave_interface) {
		if($tn1_cache_link1 &&
			!cache_clean(
				$slave_interface,
				'tn1_na_cleanup',
				'tn1_ereq_cleanup',
				'tn1_erep_cleanup',
				'tn1_mcast_ns_linklocal_common'
			)
		) {

			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Cleanup Fail'.
				'</B></FONT><BR>');

			$ecode = $V6evalTool::exitCleanupFail;
		}

		vStop($slave_interface);
		vStop($master_interface);
	} else {
		vStop($Link);
	}

	exit($ecode);
}



#------------------------------#
# ignoreDAD()                  #
#------------------------------#
sub
ignoreDAD($)
{
	my ($Link) = @_;

	vRecv($Link,
		$MAX_RTR_SOLICITATION_DELAY +
			$TimeOut * $DupAddrDetectTransmits,
		0, 0);

	return;
}



#------------------------------#
# cache_clean()                #
#------------------------------#
sub
cache_clean($$$$$)
{
	my ($Link, $na, $ereq, $erep, $ns) = @_;

# 2.
# 	Each TR or TN in the test transmits a Neighbor Advertisement
# 	for each Neighbor Cache Entry with a Source Link-layer Address Option
# 	containing a different cached address.
# 	The Override flag should be set.

	vSend($Link, $na);

# 3.
# 	Each TR or TN transmits an Echo Request to the NUT
# 	and waits for an Echo Reply.

	vSend($Link, $ereq);

	my %ret = vRecv($Link, $TimeOut, 0, 0, $erep, $ns);
	for( ; ; ) {
		if($ret{'recvFrame'} eq $erep) {
# 4.
# 	Each TR or TN does not respond to further Neighbor Solicitations.

			vRecv($Link,
				$DELAY_FIRST_PROBE_TIME +
					$TimeOut * $MAX_UNICAST_SOLICIT,
				0, 0);

			last;
		}

		if($ret{'recvFrame'} eq $ns) {
			vRecv($Link,
				$TimeOut * $MAX_MULTICAST_SOLICIT,
				0, 0);

			last;
		}

		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply or NS'.
			'</B></FONT><BR>');

		return($false);
	}

	return($true);
}



#------------------------------#
# tn1_none_to_incomplete()     # 
#------------------------------#
sub
tn1_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tn1_mcast_nd_common));

	vSend($Link, 'tn1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tr1_none_to_incomplete()     # 
#------------------------------#
sub
tr1_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tr2_none_to_incomplete()     # 
#------------------------------#
sub
tr2_none_to_incomplete($)
{
	my ($Link) = @_;

	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return($false);
}



#------------------------------#
# tn1_none_to_reachable()      # 
#------------------------------#
sub
tn1_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	vSend($Link, 'tn1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr1_none_to_reachable()      # 
#------------------------------#
sub
tr1_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr2_none_to_reachable()      # 
#------------------------------#
sub
tr2_none_to_reachable($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# tr1_none_to_probe()          # 
#------------------------------#
sub
tr1_none_to_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	vSend($Link, 'tr1_ereq_common');
	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	@frames	= sort(keys(%tr1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# tn1_none_to_probe()          # 
#------------------------------#
sub
tn1_none_to_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	vSend($Link, 'tn1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	vSend($Link, 'tn1_ereq_common');
	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	@frames	= sort(keys(%tn1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# tr1_none_to_stale()          # 
#------------------------------#
sub
tr1_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_mcast_nd_common));

	vSend($Link, 'tr1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr1_mcast_nd_common{$frame});
			$tr1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# tr2_none_to_stale()          # 
#------------------------------#
sub
tr2_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# tn1_none_to_stale()          # 
#------------------------------#
sub
tn1_none_to_stale($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	vSend($Link, 'tn1_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_common{$frame});
			$tn1_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link, $REACHABLE_TIME * $MAX_RANDOM_FACTOR, 0, 0);

	return($true);
}



#------------------------------#
# is_tn1_incomplete()          #
#------------------------------#
sub
is_tn1_incomplete($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
		0, 0);

	$tn1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_incomplete()          #
#------------------------------#
sub
is_tr2_incomplete($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn1_stale()               #
#------------------------------#
sub
is_tn1_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr1_stale()               #
#------------------------------#
sub
is_tr1_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_common');
	unless($ret{'recvFrame'} eq 'tr1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_stale()               #
#------------------------------#
sub
is_tr2_stale($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn1_stale_diff()          #
#------------------------------#
sub
is_tn1_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_diff');
	unless($ret{'recvFrame'} eq 'tn1_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr1_stale_diff()          #
#------------------------------#
sub
is_tr1_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr1_erep_diff');
	unless($ret{'recvFrame'} eq 'tr1_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr1_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr1_cache = $false;

	return($true);
}



#------------------------------#
# is_tr2_stale_diff()          #
#------------------------------#
sub
is_tr2_stale_diff($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_diff');
	unless($ret{'recvFrame'} eq 'tr2_erep_diff') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_ucast_nd_diff));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# is_tn1_reachable()           #
#------------------------------#
sub
is_tn1_reachable($)
{
	my ($Link) = @_;

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_common');
	unless($ret{'recvFrame'} eq 'tn1_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		return($true);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn1_cache = $false;

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'observed NS</B></FONT><BR>');

	return($false);
}



#------------------------------#
# is_tn1_probe()               #
#------------------------------#
sub
is_tn1_probe($)
{
	my ($Link) = @_;

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_ucast_nd_common));

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
		0, 0);

	$tn1_cache = $false;

	return($true);
}



#------------------------------#
# getaddr_v6LC_2_3_16_A()      #
#------------------------------#
sub
getaddr_v6LC_2_3_16_A($)
{
	my ($Link) = @_;

	$pktdesc{'getaddr_v6LC_2_3_16_A'} =
		'    Send dummy packet for address calculation';

	my %ret = vSend($Link, 'getaddr_v6LC_2_3_16_A');

	my $TargetAddress = 'Frame_Ether.Packet_IPv6.ICMPv6_NS.TargetAddress';

	unless(defined($ret{$TargetAddress})) {
		return('');
	}

	vRecv($Link, $TimeOut, 0, 0);

	return($ret{$TargetAddress});
}



#------------------------------#
# stopToRtAdv                  #
#------------------------------#
sub
stopToRtAdv($)
{
	my ($Link) = @_;

	if(vRemote('racontrol.rmt', 'mode=stop')) {
		vLogHTML('<FONT COLOR="#FF0000"><B>racontrol.rmt: '.
			'Could\'t stop to send RA</B></FONT><BR>');

		exitFatal($Link);
		#NOTREACHED
	}

	vRecv($Link,
		$MAX_INITIAL_RTR_ADVERT_INTERVAL *
			$MAX_INITIAL_RTR_ADVERTISEMENTS +
			$MIN_DELAY_BETWEEN_RAS + 1,
		0, 0);

	$rut_rtadvd = $false;

	return($true);
}



#------------------------------#
# startIPv6forwarding          #
#------------------------------#
sub
startIPv6forwarding($)
{
	my ($Link) = @_;

	if(vRemote('sysctl.rmt',
		'name=net.inet6.ip6.forwarding',
		'value=1')) {

		vLogHTML('<FONT COLOR="#FF0000"><B>sysctl.rmt: '.
			'Could\'t set kernel state</B></FONT><BR>');

		exitFatal($Link);
		#NOTREACHED
	}

	return($true);
}



#------------------------------#
# register                     #
#------------------------------#
sub
register($$)
{
	my ($master, $slave) = @_;

	$master_interface	= $master;
	$slave_interface	= $slave;

	vCapture($master_interface);
	vCapture($slave_interface);

	$use_slave_interface = $true;

	return($true);
}



1;
