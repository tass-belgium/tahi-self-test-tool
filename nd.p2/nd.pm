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
# $TAHI: ct/nd.p2/nd.pm,v 1.15 2010/03/29 00:47:40 akisada Exp $
#
########################################################################

package nd;

use Exporter;
use ndisc;

BEGIN {}
END   {}

@ISA = qw(Exporter);

@EXPORT = qw(
	ndBasicIncomplete
	ndRetransTimerIncomplete
	ndBasicProbe
	ndRetransTimerProbe
	ndBasicIncompleteForwarding
	ndRetransTimerIncompleteForwarding
	ndBasicProbeForwarding
	ndRetransTimerProbeForwarding
	ndProbe2None
	ndNone2StaleForwarding
	ndNone2DelayForwarding
	ndNone2NoneForwarding
	ndResolutionWaitQueueSingleSetup
	ndResolutionWaitQueueMultipleSetup
	ndResolutionWaitQueueSingle
	ndResolutionWaitQueueMultiple
	ndRecvNsNone2Incomplete
	ndRecvNsNone2IncompleteWithEchoRequest
	ndRecvNsNone2Probe
	ndRecvNsNone2ProbeWithEchoRequest
	ndRecvNsNone2ProbeSuspicious
	ndRecvNsIncomplete2Probe
	ndRecvNsIncomplete2ProbeWithEchoRequest
	ndSetNa4dadNs
	ndSetNa4ucastNs
	ndSetNa4mcastNs
	ndSetNa4ucastNsX
	ndSetNa4mcastNsX
	ndRecvNsReachable2Reachable
	ndRecvNsReachable2Probe
	ndRecvNsReachable2ReachableWithEchoRequest
	ndRecvNsReachable2ProbeWithEchoRequest
	ndSendNsRecvNaStale
	ndRecvNsDelay2Probe
	ndRecvNsDelay2Stale
	ndRecvNsProbe2Probe
	ndRecvNsProbe2Stale
	ndRecvNsProbe2ProbeWithEchoRequest
	ndRecvNsProbe2StaleWithEchoRequest
	ndSendNaNone2None
	ndSendNaIncomplete2Incomplete
	ndSendNaIncomplete2Stale
	ndSendNaIncomplete2Reachable
	ndSendNaReachable2Reachable
	ndSendNaReachable2Stale
	ndSendNaDelay2Delay
	ndSendNaProbe2Probe
	ndSendNaReachable2ReachableFalse
	ndSendNaReachable2StaleFalseX
	ndSendNsIgnore
	ndRecvDadNs
	ndSendNsRecvNa
	ndOfflinkEchoDelay
	ndOfflinkEchoDelayX
);

push(@EXPORT, sort(@ndisc::EXPORT));



#------------------------------#
# global variables             #
#------------------------------#
$pktdesc{'nd_ucast_ns'}
	= '    Send NS (link-local) w/o SLL: TN (link-local) -&gt; '.
		'NUT (link-local)';

$pktdesc{'nd_ucast_ns_sll'}
	= '    Send NS (link-local) w/ SLL: TN (link-local) -&gt; '.
		'NUT (link-local)';

$pktdesc{'nd_mcast_ns'}
	= '    Send NS (link-local) w/o SLL: TN (link-local) -&gt; '.
		'NUT solicited-node multicast address';

$pktdesc{'nd_mcast_ns_sll'}
	= '    Send NS (link-local) w/ SLL: TN (link-local) -&gt; '.
		'NUT solicited-node multicast address';

$pktdesc{'nd_ucast_ns_x'}
	= '    Send NS (link-local) w/o SLL (diff): TN (link-local) -&gt; '.
		'NUT (link-local)';

$pktdesc{'nd_ucast_ns_sll_x'}
	= '    Send NS (link-local) w/ SLL (diff): TN (link-local) -&gt; '.
		'NUT (link-local)';

$pktdesc{'nd_mcast_ns_x'}
	= '    Send NS (link-local) w/o SLL (diff): TN (link-local) -&gt; '.
		'NUT solicited-node multicast address';

$pktdesc{'nd_mcast_ns_sll_x'}
	= '    Send NS (link-local) w/ SLL (diff): TN (link-local) -&gt; '.
		'NUT solicited-node multicast address';

$pktdesc{'nd_dad_na_RsO_tll'}
	= '    Recv NA (RsO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_Rso_tll'}
	= '    Recv NA (Rso, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_rsO_tll'}
	= '    Recv NA (rsO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_rso_tll'}
	= '    Recv NA (rso, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_RsO_tll_global'}
	= '    Recv NA (RsO, link-local) w/ TLL: NUT (global) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_Rso_tll_global'}
	= '    Recv NA (Rso, link-local) w/ TLL: NUT (global) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_rsO_tll_global'}
	= '    Recv NA (rsO, link-local) w/ TLL: NUT (global) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_dad_na_rso_tll_global'}
	= '    Recv NA (rso, link-local) w/ TLL: NUT (global) -&gt; '.
		'all-nodes multicast address';

$pktdesc{'nd_recv_na_RSO_tll'}
	= '    Recv NA (RSO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSO'}
	= '    Recv NA (RSO, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo_tll'}
	= '    Recv NA (RSo, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo'}
	= '    Recv NA (RSo, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso_tll'}
	= '    Recv NA (Rso, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso'}
	= '    Recv NA (Rso, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO_tll'}
	= '    Recv NA (RsO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO'}
	= '    Recv NA (RsO, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_recv_na_rSO_tll'}
	= '    Recv NA (rSO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSO'}
	= '    Recv NA (rSO, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo_tll'}
	= '    Recv NA (rSo, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo'}
	= '    Recv NA (rSo, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso_tll'}
	= '    Recv NA (rso, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso'}
	= '    Recv NA (rso, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO_tll'}
	= '    Recv NA (rsO, link-local) w/ TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO'}
	= '    Recv NA (rsO, link-local) w/o TLL: NUT (link-local) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_recv_na_RSO_tll_GL'}
	= '    Recv NA (RSO, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSO_GL'}
	= '    Recv NA (RSO, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo_tll_GL'}
	= '    Recv NA (RSo, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo_GL'}
	= '    Recv NA (RSo, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso_tll_GL'}
	= '    Recv NA (Rso, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso_GL'}
	= '    Recv NA (Rso, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO_tll_GL'}
	= '    Recv NA (RsO, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO_GL'}
	= '    Recv NA (RsO, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_recv_na_rSO_tll_GL'}
	= '    Recv NA (rSO, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSO_GL'}
	= '    Recv NA (rSO, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo_tll_GL'}
	= '    Recv NA (rSo, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo_GL'}
	= '    Recv NA (rSo, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso_tll_GL'}
	= '    Recv NA (rso, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso_GL'}
	= '    Recv NA (rso, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO_tll_GL'}
	= '    Recv NA (rsO, link-local) w/ TLL: NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO_GL'}
	= '    Recv NA (rsO, link-local) w/o TLL: NUT (global) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_recv_na_RSO_tll_x'}
	= '    Recv NA (RSO, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_RSO_x'}
	= '    Recv NA (RSO, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_RSo_tll_x'}
	= '    Recv NA (RSo, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_RSo_x'}
	= '    Recv NA (RSo, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_Rso_tll_x'}
	= '    Recv NA (Rso, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_Rso_x'}
	= '    Recv NA (Rso, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_RsO_tll_x'}
	= '    Recv NA (RsO, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_RsO_x'}
	= '    Recv NA (RsO, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';

$pktdesc{'nd_recv_na_rSO_tll_x'}
	= '    Recv NA (rSO, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rSO_x'}
	= '    Recv NA (rSO, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rSo_tll_x'}
	= '    Recv NA (rSo, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rSo_x'}
	= '    Recv NA (rSo, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rso_tll_x'}
	= '    Recv NA (rso, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rso_x'}
	= '    Recv NA (rso, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rsO_tll_x'}
	= '    Recv NA (rsO, link-local) w/ TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';
$pktdesc{'nd_recv_na_rsO_x'}
	= '    Recv NA (rsO, link-local) w/o TLL (diff): NUT (link-local)'.
		' -&gt; TN (link-local)';

$pktdesc{'nd_recv_na_RSO_tll_GL_x'}
	= '    Recv NA (RSO, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSO_GL_x'}
	= '    Recv NA (RSO, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo_tll_GL_x'}
	= '    Recv NA (RSo, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RSo_GL_x'}
	= '    Recv NA (RSo, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso_tll_GL_x'}
	= '    Recv NA (Rso, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_Rso_GL_x'}
	= '    Recv NA (Rso, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO_tll_GL_x'}
	= '    Recv NA (RsO, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_RsO_GL_x'}
	= '    Recv NA (RsO, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_recv_na_rSO_tll_GL_x'}
	= '    Recv NA (rSO, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSO_GL_x'}
	= '    Recv NA (rSO, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo_tll_GL_x'}
	= '    Recv NA (rSo, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rSo_GL_x'}
	= '    Recv NA (rSo, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso_tll_GL_x'}
	= '    Recv NA (rso, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rso_GL_x'}
	= '    Recv NA (rso, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO_tll_GL_x'}
	= '    Recv NA (rsO, link-local) w/ TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';
$pktdesc{'nd_recv_na_rsO_GL_x'}
	= '    Recv NA (rsO, link-local) w/o TLL (diff): NUT (global) -&gt; '.
		'TN (link-local)';

$pktdesc{'nd_ucast_na_rso'}
	= '    Send NA (rso, link-local) w/o TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSo'}
	= '    Send NA (rSo, link-local) w/o TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rsO'}
	= '    Send NA (rsO, link-local) w/o TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSO'}
	= '    Send NA (rSO, link-local) w/o TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';

$pktdesc{'nd_mcast_na_rso'}
	= '    Send NA (rso, link-local) w/o TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSo'}
	= '    Send NA (rSo, link-local) w/o TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rsO'}
	= '    Send NA (rsO, link-local) w/o TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSO'}
	= '    Send NA (rSO, link-local) w/o TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';

$pktdesc{'nd_ucast_na_rso_tll'}
	= '    Send NA (rso, link-local) w/ TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSo_tll'}
	= '    Send NA (rSo, link-local) w/ TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rsO_tll'}
	= '    Send NA (rsO, link-local) w/ TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSO_tll'}
	= '    Send NA (rSO, link-local) w/ TLL: TN (link-local) -&gt; '.
		'NUT(link-local)';

$pktdesc{'nd_mcast_na_rso_tll'}
	= '    Send NA (rso, link-local) w/ TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSo_tll'}
	= '    Send NA (rSo, link-local) w/ TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rsO_tll'}
	= '    Send NA (rsO, link-local) w/ TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSO_tll'}
	= '    Send NA (rSO, link-local) w/ TLL: TN (link-local) -&gt; '.
		'all-nodes multicast address';

$pktdesc{'nd_ucast_na_rso_tll_diff'}
	= '    Send NA (rso, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSo_tll_diff'}
	= '    Send NA (rSo, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rsO_tll_diff'}
	= '    Send NA (rsO, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'NUT(link-local)';
$pktdesc{'nd_ucast_na_rSO_tll_diff'}
	= '    Send NA (rSO, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'NUT(link-local)';

$pktdesc{'nd_mcast_na_rso_tll_diff'}
	= '    Send NA (rso, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSo_tll_diff'}
	= '    Send NA (rSo, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rsO_tll_diff'}
	= '    Send NA (rsO, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'all-nodes multicast address';
$pktdesc{'nd_mcast_na_rSO_tll_diff'}
	= '    Send NA (rSO, link-local) w/ TLL (diff): TN (link-local) -&gt; '.
		'all-nodes multicast address';

$pktdesc{'ndisc_mcast_ns_sll_GG_h0_link1'}
	= '    Recv NS (H0, global) w/ SLL: NUT (global) -&gt; '.
		'H0 solicited-node multicast address';

$pktdesc{'ndisc_mcast_ns_sll_LG_h0_link1'}
	= '    Recv NS (H0, global) w/ SLL: NUT (link-local) -&gt; '.
		'H0 solicited-node multicast address';

$pktdesc{'nd_ereq_forwarding'}
	= '    Send Echo Request: H0 (Link1) -&gt; TN (Link0)';

$pktdesc{'nd_ereq_forwarding_link0'}
	= '    Recv Echo Request (forwarded): H0 (Link1) -&gt; TN (Link0)';

$pktdesc{'global_ereq'}
	= '    Send Echo Request: H0 (Link1) -&gt; NUT (Link0)';

$pktdesc{'global_ereq_x'}
	= '    Send Echo Request (diff): H0 (Link1) -&gt; NUT (Link0)';

$pktdesc{'global_erep'}
	= '    Recv Echo Reply: NUT (Link0) -&gt; H0 (Link1)';

$pktdesc{'global_erep_x'}
	= '    Recv Echo Reply (diff): NUT (Link0) -&gt; H0 (Link1)';


#------------------------------#
# global constants             #
#------------------------------#
$nd_ns_queue_def = './nd_ns_queue.def';

$hash_mcast_ns{'nd_ucast_ns'}		= 'ndisc_mcast_ns_sll_LL';
$hash_mcast_ns{'nd_ucast_ns_sll'}	= 'ndisc_mcast_ns_sll_LL';
$hash_mcast_ns{'nd_mcast_ns'}		= 'ndisc_mcast_ns_sll_LL';
$hash_mcast_ns{'nd_mcast_ns_sll'}	= 'ndisc_mcast_ns_sll_LL';

$hash_ucast_ns{'nd_ucast_ns'}		= 'ndisc_ucast_ns_sll_LL';
$hash_ucast_ns{'nd_ucast_ns_sll'}	= 'ndisc_ucast_ns_sll_LL';
$hash_ucast_ns{'nd_mcast_ns'}		= 'ndisc_ucast_ns_sll_LL';
$hash_ucast_ns{'nd_mcast_ns_sll'}	= 'ndisc_ucast_ns_sll_LL';

$hash_mcast_ns{'nd_ucast_ns_x'}		= 'ndisc_mcast_ns_sll_LL_diff';
$hash_mcast_ns{'nd_ucast_ns_sll_x'}	= 'ndisc_mcast_ns_sll_LL_diff';
$hash_mcast_ns{'nd_mcast_ns_x'}		= 'ndisc_mcast_ns_sll_LL_diff';
$hash_mcast_ns{'nd_mcast_ns_sll_x'}	= 'ndisc_mcast_ns_sll_LL_diff';

$hash_ucast_ns{'nd_ucast_ns_x'}		= 'ndisc_ucast_ns_sll_LL_diff';
$hash_ucast_ns{'nd_ucast_ns_sll_x'}	= 'ndisc_ucast_ns_sll_LL_diff';
$hash_ucast_ns{'nd_mcast_ns_x'}		= 'ndisc_ucast_ns_sll_LL_diff';
$hash_ucast_ns{'nd_mcast_ns_sll_x'}	= 'ndisc_ucast_ns_sll_LL_diff';

#------------------------------#
# ndBasicIncomplete()          #
#------------------------------#
sub
ndBasicIncomplete($$)
{
	my ($Link, $ereq) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = mcastNS($ereq);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	$SeekTime = 0;

	vSend($Link, $ereq);

	for( ; ; ) {
		my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					last;
				}
			}

			if($solicit > $MAX_MULTICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

			        return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_MULTICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#------------------------------#
# ndRetransTimerIncomplete()   #
#------------------------------#
sub
ndRetransTimerIncomplete($$)
{
	my ($Link, $ereq) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = mcastNS($ereq);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	$SeekTime = 0;

	my @recvtimes = ();

	vSend($Link, $ereq);

	for( ; ; ) {
		my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					push(@recvtimes,
						$ret{'recvTime'.
							$ret{'recvCount'}});
					last;
				}
			}

			if($solicit > $MAX_MULTICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

			        return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_MULTICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	my $returnvalue = 0;

	vLogHTML('<TABLE>');

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
#			vLogHTML("<TD ROWSPAN=\"2\">$delta sec. ".
#				sprintf("(%.1f sec.)</TD>", $delta));
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			$delta += 0.05;

			if($delta < $RETRANS_TIMER) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = -1;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	if($returnvalue < 0) {
                vLogHTML('<FONT COLOR="#FF0000">'.
			'Retransmissions MUST be rate-limited to '.
			'at most one solicitation per<BR>');
                vLogHTML('<FONT COLOR="#FF0000">'.
			'neighbor every RetransTimer milliseconds.<BR>');
	}

	return($returnvalue);
}

#------------------------------#
# ndBasicProbe()               #
#------------------------------#
sub
ndBasicProbe($$)
{
	my ($Link, $ereq) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = ucastNS($ereq);

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

			        return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#------------------------------#
# ndRetransTimerProbe()        #
#------------------------------#
sub
ndRetransTimerProbe($$)
{
	my ($Link, $ereq) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = ucastNS($ereq);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @recvtimes = ();

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					push(@recvtimes,
						$ret{'recvTime'.
							$ret{'recvCount'}});
					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

			        return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	my $returnvalue = 0;

	vLogHTML('<TABLE>');

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			my $margin = 0.5;
			if($delta < $RETRANS_TIMER-$margin || $delta > $RETRANS_TIMER+$margin) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = -1;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	if($returnvalue < 0) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'Retransmissions MUST be rate-limited to '.
			'at most one solicitation per<BR>');
		vLogHTML('<FONT COLOR="#FF0000">'.
			'neighbor every RetransTimer milliseconds.<BR>');
	}

	return($returnvalue);
}

#------------------------------#
# ndProbe2None()               #
#------------------------------#
sub
ndProbe2None($$)
{
	my ($Link, $ereq) = @_;

	my $solicit	= 0;

	my @frames = ucastNS($ereq);

	$SeekTime	= 0;

	for(my $d = 0; ; $d ++) {
		my $recv_valid	= 0;
		my %ret = vRecvWrapper($Link,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recv_valid	++;
					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

			        return(-1);
			}

			if($recv_valid) {
				next;
			}
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return(0);
}

#--------------------------------------#
# ndBasicIncompleteForwarding()        #
#--------------------------------------#
sub
ndBasicIncompleteForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = (
		'ndisc_mcast_ns_sll_GG',
		'ndisc_mcast_ns_sll_LG'
	);

	$SeekTime = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	vSend($Link1, 'nd_ereq_forwarding');

	for( ; ; ) {
		my %ret = vRecvWrapper($Link0, $TimeOut, $SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					last;
				}
			}

			if($solicit > $MAX_MULTICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

				return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_MULTICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#--------------------------------------#
# ndRetransTimerIncompleteForwarding() #
#--------------------------------------#
sub
ndRetransTimerIncompleteForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = (
		'ndisc_mcast_ns_sll_GG',
		'ndisc_mcast_ns_sll_LG'
	);

	$SeekTime = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @recvtimes = ();

	vSend($Link1, 'nd_ereq_forwarding');

	for( ; ; ) {
		my %ret = vRecvWrapper($Link0, $TimeOut, $SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					push(@recvtimes,
						$ret{'recvTime'.
							$ret{'recvCount'}});
					last;
				}
			}

			if($solicit > $MAX_MULTICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

				return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_MULTICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	my $returnvalue = 0;

	vLogHTML('<TABLE>');

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			$delta += 0.05;

			if($delta < $RETRANS_TIMER) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = -1;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	if($returnvalue < 0) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'Retransmissions MUST be rate-limited to '.
			'at most one solicitation per<BR>');
		vLogHTML('<FONT COLOR="#FF0000">'.
			'neighbor every RetransTimer milliseconds.<BR>');
	}

	return($returnvalue);
}

#------------------------------#
# ndBasicProbeForwarding()     #
#------------------------------#
sub
ndBasicProbeForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount		= 0;
	my $solicit		= 0;

	my @frames = (
		'ndisc_ucast_ns_sll_GG',
		'ndisc_ucast_ns_sll_LG',
		'ndisc_ucast_ns_GG',
		'ndisc_ucast_ns_LG'
	);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link0,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

				return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#--------------------------------------#
# ndRetransTimerProbeForwarding()      #
#--------------------------------------#
sub
ndRetransTimerProbeForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount		= 0;
	my $solicit		= 0;

	my @frames = (
		'ndisc_ucast_ns_sll_GG',
		'ndisc_ucast_ns_sll_LG',
		'ndisc_ucast_ns_GG',
		'ndisc_ucast_ns_LG'
	);

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @recvtimes = ();

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link0,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					push(@recvtimes,
						$ret{'recvTime'.
							$ret{'recvCount'}});

					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

				return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	my $returnvalue = 0;

	vLogHTML('<TABLE>');

	for(my $d = 0; $d <= $#recvtimes; $d ++) {
		vLogHTML('<TR>');
		vLogHTML("<TD ROWSPAN=\"2\">Recv[$d]</TD>");
		vLogHTML('<TD ROWSPAN="2">:</TD>');
		vLogHTML("<TD ROWSPAN=\"2\">$recvtimes[$d] sec.</TD>");

		if($d == 0) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		}

		vLogHTML('</TR>');

		vLogHTML('<TR>');

		if($d == $#recvtimes) {
			vLogHTML('<TD COLSPAN="4">&nbsp;</TD>');
		} else {
			my $delta = $recvtimes[$d + 1] - $recvtimes[$d];

			vLogHTML("<TD ROWSPAN=\"2\">Interval[$d]</TD>");
			vLogHTML('<TD ROWSPAN="2">:</TD>');
			vLogHTML(sprintf("<TD ROWSPAN=\"2\">%.1f sec.</TD>",
				$delta));

			$delta += 0.05;

			if($delta < $RETRANS_TIMER) {
				vLogHTML('<TD ROWSPAN="2">');
				vLogHTML('<FONT COLOR="#FF0000">*</FONT>');
				vLogHTML('</TD>');
				$returnvalue = -1;
			} else {
				vLogHTML('<TD ROWSPAN="2">&nbsp;</TD>');
			}
		}

		vLogHTML('</TR>');
	}

	vLogHTML('</TABLE>');

	if($returnvalue < 0) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'Retransmissions MUST be rate-limited to '.
			'at most one solicitation per<BR>');
		vLogHTML('<FONT COLOR="#FF0000">'.
			'neighbor every RetransTimer milliseconds.<BR>');
	}

	return($returnvalue);
}

#------------------------------#
# ndNone2StaleForwarding()     #
#------------------------------#
sub
ndNone2StaleForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;
        my $solicit	= 0;
        my $ereq	= 0;
	my $na		= '';

	my @frames = (
		'ndisc_mcast_ns_sll_GG',
		'ndisc_mcast_ns_sll_LG'
	);

	my %hash_na_forwarding = (
		'ndisc_mcast_ns_sll_GG' => 'ndisc_na_rSO_tll_GG',
		'ndisc_mcast_ns_sll_LG' => 'ndisc_na_rSO_tll_GL_forwarding',
	);

	$pktdesc{'ndisc_na_rSO_tll_GL_forwarding'}
		= '    Send NA (rSO, global) w/ TLL: '.
			'TN (link-local) -&gt; NUT (link-local)';

	$SeekTime = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>INITIALIZATION'.
		'</B></U></FONT><BR>');

	vSend($Link1, 'nd_ereq_forwarding');

	my %ret = vRecvWrapper($Link0, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		$recvCount += $ret{'recvCount'};

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$solicit ++;
				$na = $hash_na_forwarding{$frame};
				$recvCount --;
				last;
			}
		}
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}



	vSend($Link0, $na);

	%ret = vRecvWrapper($Link0,
		$TimeOut, $SeekTime, 0, 'nd_ereq_forwarding_link0');

	if($ret{'recvCount'}) {
		$recvCount += $ret{'recvCount'};

		if($ret{'recvFrame'} eq 'nd_ereq_forwarding_link0') {
			$ereq ++;
			$recvCount --;
		}
	}

	unless($ereq) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Request (forwarding)'.
			'</B></FONT><BR>');

		return(-1);
	}

	return(ndiscReachable2Stale($Link0));
}

#------------------------------#
# ndNone2DelayForwarding()     #
#------------------------------#
sub
ndNone2DelayForwarding($$)
{
	my ($Link0, $Link1) = @_;

	if($NOT_USE_FAST_CHANGE_STATE) {
		return(ndNone2DelayForwarding0($Link0, $Link1));
	}

	return(ndNone2DelayForwarding1($Link0, $Link1));
}

#------------------------------#
# ndNone2NoneForwarding()      #
#------------------------------#
sub
ndNone2NoneForwarding($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;
	my $solicit	= 0;

	my @frames = (
		'ndisc_ucast_ns_sll_GG',
		'ndisc_ucast_ns_sll_LG',
		'ndisc_ucast_ns_GG',
		'ndisc_ucast_ns_LG'
	);

	if(ndNone2DelayForwarding($Link0, $Link1) < 0) {
		return(-1);
	}

	for(my $d = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link0,
			$d ? $TimeOut : $DELAY_FIRST_PROBE_TIME + $TimeOut,
			$SeekTime, 0, @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					$solicit ++;
					$recvCount --;
					last;
				}
			}

			if($solicit > $MAX_UNICAST_SOLICIT) {
				vLogHTML('<FONT COLOR="#FF0000"><B>Observed '.
					'too many NSs</B></FONT><BR>');

				return(-1);
			}

			next;
		}

		last;
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	if($solicit < $MAX_UNICAST_SOLICIT) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed too less NSs'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#------------------------------#
# ndNone2DelayForwarding0()    #
#------------------------------#
sub
ndNone2DelayForwarding0($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;

	if(ndNone2StaleForwarding($Link0, $Link1) < 0) {
		return(-1);
	}

	vSend($Link1, 'nd_ereq_forwarding');

	my %ret = vRecvWrapper($Link0,
		$TimeOut, 0, 0, 'nd_ereq_forwarding_link0');

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq 'nd_ereq_forwarding_link0') {
			return($recvCount);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe Echo Request (forwarded)</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndNone2DelayForwarding1()    #
#------------------------------#
sub
ndNone2DelayForwarding1($$)
{
	my ($Link0, $Link1) = @_;

	my $recvCount	= 0;
        my $solicit	= 0;
        my $ereq	= 0;

	my @frames = (
		'ndisc_mcast_ns_sll_GG',
		'ndisc_mcast_ns_sll_LG'
	);

	$SeekTime = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>INITIALIZATION'.
		'</B></U></FONT><BR>');

	vSend($Link1, 'nd_ereq_forwarding');

	my %ret = vRecvWrapper($Link0, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		$recvCount += $ret{'recvCount'};

		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				$solicit ++;
				$recvCount --;
				last;
			}
		}
	}

	unless($solicit) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}



	vSend($Link0, 'ndisc_na_rsO_tll_GG');

	%ret = vRecvWrapper($Link0,
		$TimeOut, $SeekTime, 0, 'nd_ereq_forwarding_link0');

	if($ret{'recvCount'}) {
		$recvCount += $ret{'recvCount'};

		if($ret{'recvFrame'} eq 'nd_ereq_forwarding_link0') {
			$ereq ++;
			$recvCount --;
		}
	}

	unless($ereq) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Request (forwarding)'.
			'</B></FONT><BR>');

		return(-1);
	}

	return($recvCount);
}

#--------------------------------------#
# ndResolutionWaitQueueSingleSetup()   #
#--------------------------------------#
sub
ndResolutionWaitQueueSingleSetup($$)
{
	my ($max, $echo) = @_;

	local(*OUTPUT);

	unless(open(OUTPUT, "> $nd_ns_queue_def")) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			"open: $nd_ns_queue_def: $!</B></FONT><BR>");
		return(-1);
	}

	for(my $d = 0; $d < $max; $d ++) {
		my $ereq = sprintf("queue_ereq_%05d", $d);
		my $erep = sprintf("queue_erep_%05d", $d);

		my $seq = $d + 3;

		$$echo{$erep} = $ereq;

		$pktdesc{$ereq}	=
			"    Send Echo Request (SN=$seq): ".
			'TN (link-local) -&gt; NUT (link-local)';

		$pktdesc{$erep}	=
			"    Recv Echo Reply (SN=$seq): ".
			'NUT (link-local) -&gt; TN (link-local)';

		my $addr = "tnv6()";
		my $reqHeaderEther = "_HETHER_tn2nut";
		my $repHeaderEther = "_HETHER_nut2tn";
		ndResolutionWaitQueueSingleWriteEcho(*OUTPUT, $seq, $ereq, $erep, $addr, $reqHeaderEther, $repHeaderEther);
	}

	close(OUTPUT);

	vCPP('-DUSE_ND_NS_QUEUE');

	return(0);
}

#--------------------------------------#
# ndResolutionWaitQueueMultipleSetup() #
#--------------------------------------#
sub
ndResolutionWaitQueueMultipleSetup($$$$)
{
	my ($maxPacketA, $maxPacketB, $echo0, $echo1) = @_;

	local(*OUTPUT);

	unless(open(OUTPUT, "> $nd_ns_queue_def")) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			"open: $nd_ns_queue_def: $!</B></FONT><BR>");
		return(-1);
	}

	my $max = ($maxPacketA >= $maxPacketB) ? $maxPacketA : $maxPacketB;
	for(my $d = 0; $d < $max; $d ++) {

		if ($d < $maxPacketA) {
			my $ereq0 = sprintf("queue_ereq_%05d_a", $d);
			my $erep0 = sprintf("queue_erep_%05d_a", $d);
			$$echo0{$erep0} = $ereq0;

			my $seq = $d + 3;

			$pktdesc{$ereq0}	=
				"    Send Echo Request (SN=$seq): ".
				'TN (link-local) -&gt; NUT (link-local)';
			$pktdesc{$erep0}	=
				"    Recv Echo Reply (SN=$seq): ".
				'NUT (link-local) -&gt; TN (link-local)';

			my $addr = 'tnv6()';
			my $reqHeaderEther = '_HETHER_tn2nut';
			my $repHeaderEther = '_HETHER_nut2tn';
			ndResolutionWaitQueueSingleWriteEcho(*OUTPUT, $seq, $ereq0, $erep0, $addr, $reqHeaderEther, $repHeaderEther);
		}

		if ($d < $maxPacketB) {
			my $ereq1 = sprintf("queue_ereq_%05d_b", $d);
			my $erep1 = sprintf("queue_erep_%05d_b", $d);
			$$echo1{$erep1} = $ereq1;

			my $seq = $d + 4;

			$pktdesc{$ereq1}	=
				"    Send Echo Request (SN=$seq): ".
				'H0 (link-local) -&gt; NUT (link-local)';
			$pktdesc{$erep1}	=
				"    Recv Echo Reply (SN=$seq): ".
				'NUT (link-local) -&gt; H0 (link-local)';
			
			my $addr = 'v6(H0_LINKLOCAL)';
			my $reqHeaderEther = '_HETHER_h02nut';
			my $repHeaderEther = '_HETHER_nut2h0';
			ndResolutionWaitQueueSingleWriteEcho(*OUTPUT, $seq, $ereq1, $erep1,
												 $addr, $reqHeaderEther, $repHeaderEther);
		}
	}

	close(OUTPUT);

	vCPP('-DUSE_ND_NS_QUEUE');

	return(0);
}

#----------------------------------------------#
# ndResolutionWaitQueueSingleWriteEcho()       #
#----------------------------------------------#
sub
ndResolutionWaitQueueSingleWriteEcho(*$$$$$$)
{
	local (*OUTPUT)	= $_[0];
	my ($sequence)	= $_[1];
	my ($ereq)	= $_[2];
	my ($erep)	= $_[3];
	my ($addr) = $_[4];
	my ($reqHeaderEther) = $_[5];
	my ($repHeaderEther) = $_[6];

	print(OUTPUT "FEM_icmp6_echo_request(\n");
	print(OUTPUT "\t$ereq,\n");
	print(OUTPUT "\t$reqHeaderEther,\n");
	print(OUTPUT "\t{\n");
	print(OUTPUT "\t\t_SRC($addr);\n");
	print(OUTPUT "\t\t_DST(nutv6());\n");
	print(OUTPUT "\t},\n");
	print(OUTPUT "\t{\n");
	print(OUTPUT "\t\tSequenceNumber\t= $sequence;\n");
	print(OUTPUT "\t\tpayload\t\t= payload8;\n");
	print(OUTPUT "\t}\n");
	print(OUTPUT ")\n");
	print(OUTPUT "\n");

	print(OUTPUT "FEM_icmp6_echo_reply(\n");
	print(OUTPUT "\t$erep,\n");
	print(OUTPUT "\t$repHeaderEther,\n");
	print(OUTPUT "\t{\n");
	print(OUTPUT "\t\t_SRC(nutv6());\n");
	print(OUTPUT "\t\t_DST($addr);\n");
	print(OUTPUT "\t},\n");
	print(OUTPUT "\t{\n");
	print(OUTPUT "\t\tSequenceNumber\t= $sequence;\n");
	print(OUTPUT "\t\tpayload\t\t= payload8;\n");
	print(OUTPUT "\t}\n");
	print(OUTPUT ")\n");
	print(OUTPUT "\n");

	return(0);
}


#--------------------------------------#
# ndResolutionWaitQueueSingle()        #
#--------------------------------------#
sub
ndResolutionWaitQueueSingle($$)
{
	my ($Link, $echo) = @_;
	my $recvCount = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>Procedure</B></U></FONT><BR>');

	my @ereqs	= sort(values(%$echo));

	$SeekTime	= 0;
	my @frames	= mcastNS('ndisc_ereq_LL');
	my %rest	= %$echo;
	my %recv	= ();
	my @ereps	= keys(%rest);

	vClear($Link);
	foreach my $ereq (@ereqs) {
		vSend($Link, $ereq);
	}

#	vSend($Link, @ereqs);

	for(my $got_ns = 0; ; ) {
		my $recv_valid	= 0;
		my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0,
			$got_ns ? @ereps : @frames);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			unless($got_ns) {
				foreach my $frame (@frames) {
					if($ret{'recvFrame'} eq $frame) {
						$recvCount --;
						$got_ns ++;
						$recv_valid ++;
						vSend($Link, $hash_na{$frame});
						$tn1_cache = 1;

						last;
					}
				}

				next;
			}

			foreach my $erep (@ereps) {
				if($ret{'recvFrame'} eq $erep) {
					$recvCount --;

					$recv{$erep} = $$echo{$erep};

					delete($rest{$erep});
					@ereps = keys(%rest);

					$recv_valid ++;
					last;
				}
			}

			if($recv_valid) {
				next;
			}
		}

		unless($got_ns) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe NS</B></FONT><BR>');
			return(-1);
		}

		last;
	}

	my @master_ereqs	= @ereqs;
	my @master_ereps	= sort(keys(%recv));

	if($#ereps > -1) {
		if($#ereps == $#ereqs) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply</B></FONT><BR>');
			return(-1);
		}

		my @recv_ereps	= keys(%recv);

		while(my $ereq = pop(@ereqs)) {
			my $bool	= 0;

			foreach my $recv_erep (@recv_ereps) {
				if($ereq eq $$echo{$recv_erep}) {
					delete($recv{$recv_erep});
					@recv_ereps	= keys(%recv);
					$bool ++;

					last;
				}
			}

			if($bool) {
				next;
			}

			last;
		}

		if($#recv_ereps > -1) {
			vLogHTML(ndResolutionWaitQueueSingleResult(
				$echo,
				\@master_ereqs,
				\@master_ereps));

			vLogHTML('<B>When a queue overflows, '.
				'the new arrival '.
				'<FONT COLOR="#FF0000">SHOULD</FONT> '.
				'replace the oldest entry.</B><BR>');

			return(-1);
		}
	}

	return($recvCount);
}

#--------------------------------------#
# ndResolutionWaitQueueSingleResult()  #
#--------------------------------------#
sub
ndResolutionWaitQueueSingleResult($$$)
{
	my ($echo, $master_ereqs_ref, $master_ereps_ref) = @_;

	my @master_ereqs = @$master_ereqs_ref;
	my @master_ereps = @$master_ereps_ref;

	my $message	= '';

	$message .= '<BLOCKQUOTE>';
	$message .= '<TABLE BORDER>';
	$message .= '<TR>';
	$message .= '<TH>SN</TH>';
	$message .= '<TH>Echo Request</TH>';
	$message .= '<TH>Echo Reply</TH>';
	$message .= '</TR>';

	for(my $x = 0; $x <= $#master_ereqs; $x ++) {
		my $bool	= 0;
		my %work	= %$echo;

		my $key		= '';
		my $value	= '';

		while(($key, $value) = each (%work)) {
			if($value eq $master_ereqs[$x]) {
				foreach my $y (@master_ereps) {
					if($key eq $y) {
						$bool ++;
						last;
					}
				}

				last;
			}
		}

		$message .= '<TR>';
		$message .= "<TD>$x</TD>";
		$message .= "<TD>Send '$value'</TD>";

		if($bool) {
			$message .= '<TD><FONT SIZE="#FF0000">'.
				"Recv '$key'</FONT></TD>";
		} else {
			$message .= '<TD><FONT COLOR="#FF0000">*</FONT></TD>';
		}

		$message .= '</TR>';
	}

	$message .= '</TABLE>';
	$message .= '</BLOCKQUOTE>';

	return($message);
}

#--------------------------------------#
# ndResolutionWaitQueueMultiple()      #
#--------------------------------------#
sub
ndResolutionWaitQueueMultiple($$$)
{
	my ($Link, $echo0, $echo1) = @_;
	my $recvCount = 0;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>Procedure</B></U></FONT><BR>');

	my @ereqs0	= sort(values(%$echo0));
	my @ereqs1	= sort(values(%$echo1));
	my @ereqs	= sort(@ereqs0, @ereqs1);
	my %rest0	= %$echo0;
	my %rest1	= %$echo1;
	my @ereps0	= keys(%rest0);
	my @ereps1	= keys(%rest1);
	my @frames0	= mcastNS('ndisc_ereq_LL');
	my @frames1	= mcastNS('ndisc_ereq_LL_x');

	$SeekTime	= 0;
	my %recv0	= ();
	my %recv1	= ();

	vClear($Link);
	foreach my $ereq (@ereqs) {
		vSend($Link, $ereq);
	}

#	vSend($Link, @ereqs);

	for(my $got_ns = 0, my $got_ns_x = 0; ; ) {
		my $recv_valid	= 0;
		my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0,
			$got_ns ? @ereps0 : @frames0,
			$got_ns_x ? @ereps1 : @frames1);

		if($ret{'recvCount'}) {
			$recvCount += $ret{'recvCount'};

			unless($got_ns) {
				my $bool = 0;

				foreach my $frame (@frames0) {
					if($ret{'recvFrame'} eq $frame) {
						$recvCount --;
						$got_ns ++;
						$bool ++;
						$recv_valid	++;
						vSend($Link, $hash_na{$frame});
						$tn1_cache = 1;

						last;
					}
				}

				if($bool) {
					next;
				}
			}

			unless($got_ns_x) {
				my $bool = 0;

				foreach my $frame (@frames1) {
					if($ret{'recvFrame'} eq $frame) {
						$recvCount --;
						$got_ns_x ++;
						$bool ++;
						$recv_valid	++;
						vSend($Link, $hash_na{$frame});
						$tn2_cache = 1;

						last;
					}
				}

				if($bool) {
					next;
				}
			}

			if($got_ns) {
				my $bool = 0;

				foreach my $erep (@ereps0) {
					if($ret{'recvFrame'} eq $erep) {
						$recvCount --;
						$bool ++;
						$recv0{$erep} = $$echo0{$erep};

						delete($rest0{$erep});
						@ereps0 = keys(%rest0);

						$recv_valid	++;
						last;
					}
				}

				if($bool) {
					next;
				}
			}

			foreach my $erep (@ereps1) {
				if($ret{'recvFrame'} eq $erep) {
					$recvCount --;
					$recv1{$erep} = $$echo1{$erep};

					delete($rest1{$erep});
					@ereps1 = keys(%rest1);

					$recv_valid	++;
					last;
				}
			}

			if($recv_valid) {
				next;
			}
		}

		unless($got_ns) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe NS for TN</B></FONT><BR>');
			return(-1);
		}

		unless($got_ns_x) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe NS for H0</B></FONT><BR>');
			return(-1);
		}

		last;
	}

	my @master_ereqs0	= @ereqs0;
	my @master_ereqs1	= @ereqs1;

	my @master_ereps0	= sort(keys(%recv0));
	my @master_ereps1	= sort(keys(%recv1));

	if(($#ereps0 > -1) || ($#ereps1 > -1)) {
		if($#ereps0 == $#ereqs0) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply for TN'.
				'</B></FONT><BR>');
			return(-1);
		}

		if($#ereps1 == $#ereqs1) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe Echo Reply for H0'.
				'</B></FONT><BR>');
			return(-1);
		}

		my @recv_ereps0	= keys(%recv0);
		my @recv_ereps1	= keys(%recv1);

		while(my $ereq = pop(@ereqs0)) {
			my $bool	= 0;

			foreach my $recv_erep (@recv_ereps0) {
				if($ereq eq $$echo0{$recv_erep}) {
					delete($recv0{$recv_erep});
					@recv_ereps0	= keys(%recv0);
					$bool ++;

					last;
				}
			}

			if($bool) {
				next;
			}

			last;
		}

		while(my $ereq = pop(@ereqs1)) {
			my $bool	= 0;

			foreach my $recv_erep (@recv_ereps1) {
				if($ereq eq $$echo1{$recv_erep}) {
					delete($recv1{$recv_erep});
					@recv_ereps1	= keys(%recv1);
					$bool ++;

					last;
				}
			}

			if($bool) {
				next;
			}

			last;
		}

		if(($#recv_ereps0 > -1) || ($#recv_ereps1 > -1)) {
			vLogHTML(ndResolutionWaitQueueMultipleResult(
				$echo0,
				$echo1,
				\@master_ereqs0,
				\@master_ereps0,
				\@master_ereqs1,
				\@master_ereps1));

			vLogHTML('<B>When a queue overflows, '.
				'the new arrival '.
				'<FONT COLOR="#FF0000">SHOULD</FONT> '.
				'replace the oldest entry.</B><BR>');

			return(-1);
		}
	}

	return($recvCount);
}

#----------------------------------------------#
# ndResolutionWaitQueueMultipleResult()        #
#----------------------------------------------#
sub
ndResolutionWaitQueueMultipleResult($$$$$$)
{
	my ($echo0, $echo1,
		$master_ereqs0_ref, $master_ereps0_ref,
		$master_ereqs1_ref, $master_ereps1_ref) = @_;

	my @master_ereqs0 = @$master_ereqs0_ref;
	my @master_ereqs1 = @$master_ereqs1_ref;

	my @master_ereps0 = @$master_ereps0_ref;
	my @master_ereps1 = @$master_ereps1_ref;

	my $message	= '';

	$message .= '<BLOCKQUOTE>';
	$message .= '<TABLE BORDER>';
	$message .= '<TR>';
	$message .= '<TH ROWSPAN="2">SN</TH>';
	$message .= '<TH COLSPAN="2">TN</TH>';
	$message .= '<TH COLSPAN="2">H0</TH>';
	$message .= '</TR>';
	$message .= '<TR>';
	$message .= '<TH>Echo Request</TH>';
	$message .= '<TH>Echo Reply</TH>';
	$message .= '<TH>Echo Request</TH>';
	$message .= '<TH>Echo Reply</TH>';
	$message .= '</TR>';

	my $max = ($#master_ereqs0 > $#master_ereqs1)?
			$#master_ereqs0: $#master_ereqs1;

	for(my $x = 0; $x <= $max; $x ++) {
		my %work0	= %$echo0;
		my %work1	= %$echo1;

		my $key0	= '';
		my $value0	= '';

		my $key1	= '';
		my $value1	= '';

		my $bool_key0	= 0;
		my $bool_key1	= 0;
		my $bool_value0	= 0;
		my $bool_value1	= 0;

		if($x <= $#master_ereqs0) {
			while(($key0, $value0) = each (%work0)) {
				if($value0 eq $master_ereqs0[$x]) {
					foreach my $y (@master_ereps0) {
						if($key0 eq $y) {
							$bool_key0 ++;
							last;
						}
					}

					$bool_value0 ++;
					last;
				}
			}
		}

		if($x <= $#master_ereqs1) {
			while(($key1, $value1) = each (%work1)) {
				if($value1 eq $master_ereqs1[$x]) {
					foreach my $y (@master_ereps1) {
						if($key1 eq $y) {
							$bool_key1 ++;
							last;
						}
					}

					$bool_value1 ++;
					last;
				}
			}
		}

		$message .= '<TR>';
		$message .= "<TD>$x</TD>";

		if($bool_value0) {
			$message .= "<TD>Send '$value0'</TD>";

			if($bool_key0) {
				$message .= '<TD><FONT SIZE="-1">'.
					"Recv '$key0'</FONT></TD>";
			} else {
				$message .= '<TD><FONT COLOR="#FF0000">*'.
					'</FONT></TD>';
			}
		} else {
			$message .= "<TD>&nbsp;</TD>";
			$message .= "<TD>&nbsp;</TD>";
		}

		if($bool_value1) {
			$message .= "<TD>Send '$value1'</TD>";

			if($bool_key1) {
				$message .= '<TD><FONT SIZE="-1">'.
					"Recv '$key1'</FONT></TD>";
			} else {
				$message .= '<TD><FONT COLOR="#FF0000">*'.
					'</FONT></TD>';
			}
		} else {
			$message .= "<TD>&nbsp;</TD>";
			$message .= "<TD>&nbsp;</TD>";
		}

		$message .= '</TR>';
	}

	$message .= '</TABLE>';
	$message .= '</BLOCKQUOTE>';

	return($message);
}

#------------------------------#
# ndRecvNsNone2Incomplete()    #
#------------------------------#
sub
ndRecvNsNone2Incomplete($$)
{
	my ($Link, $ns) = @_;

	my @frames = mcastNS($ns);

	vSend($Link, $ns);

	my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#----------------------------------------------#
# ndRecvNsNone2IncompleteWithEchoRequest()     #
#----------------------------------------------#
sub
ndRecvNsNone2IncompleteWithEchoRequest($$)
{
	my ($Link, $ns) = @_;

	my $ereq = 'ndisc_ereq_LL';

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>Procedure'.
			 '</B></U></FONT><BR>');

	my @frames = mcastNS($ns);
#
# 7. TN1 transmits Neighbor Solicitation A without a SLL option.
#
	vSend($Link, $ns);
#
# 8. TN1 transmits an Echo Request to the NUT.
#
	vSend($Link, $ereq);
#
# 9. Check the NCE of TN1 on the NUT and observe packets transmitted by the NUT.
#
	my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#------------------------------#
# ndRecvNsNone2Probe()         #
#------------------------------#
sub
ndRecvNsNone2Probe($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
			 '</B></U></FONT><BR>');

	my @na     = @$na_ref;
	my @frames = ucastNS($ns);

	vSend($Link, $ns);

	for(my $d = 0, my $got_na = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link,
			$d ? $DELAY_FIRST_PROBE_TIME + $TimeOut : $TimeOut,
			$SeekTime, 0,
			$d ? @frames : @na);

		if($ret{'recvCount'}) {
			foreach my $frame (@na) {
				if($ret{'recvFrame'} eq $frame) {
					$got_na ++;
					last;
				}
			}

			unless($got_na) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Could\'t observe NA</B></FONT><BR>');
				return(-1);
			}

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					return(flushBuffer($Link,
									   $TimeOut, $TimeOut));
				}
			}

			next;
		}

		unless($got_na) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe NA</B></FONT><BR>');
			return(-1);
		}
	
		last;
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#---------------------------------------#
# ndRecvNsNone2ProbeWithEchoRequest()   #
#---------------------------------------#
sub
ndRecvNsNone2ProbeWithEchoRequest($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na     = @$na_ref;
	my @frames = ucastNS($ns);
	my $ereq = 'ndisc_ereq_LL';
	my @erep = ();
	push(@erep, 'ndisc_erep_LL');

	vSend($Link, $ns);
	vSend($Link, $ereq);

	for(my $d = 0, my $got_na = 0, my $got_erep = 0; ; $d ++) {
		my $t;
		my @f;
		if ($d == 0) {
			$t = $TimeOut;
			@f = @na;
		}
		elsif ($d == 1) {
			$t = $TimeOut;
			@f = @erep;
		}
		else {
			$t = $DELAY_FIRST_PROBE_TIME + $TimeOut;
			@f = @frames;
		}

		my %ret = vRecvWrapper($Link, $t, $SeekTime, 0, @f);

		if($ret{'recvCount'}) {
			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					return(flushBuffer($Link,
									   $TimeOut, $TimeOut));
				}
			}

			foreach my $frame (@na) {
				if($ret{'recvFrame'} eq $frame) {
					$got_na ++;
					last;
				}
			}
			
			unless($got_na) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
						 'Could\'t observe NA</B></FONT><BR>');
				return(-1);
			}

			#---- for v2.6.2
			foreach my $frame (@erep) {
				if($ret{'recvFrame'} eq $frame) {
					$got_erep ++;
					last;
				}
			}

			if ($got_erep < 0) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
						 'Could\'t observe Echo Reply</B></FONT><BR>');
				return(-1);
			}
			else {
				$got_erep --;
			}
			#---- for v2.6.2
			
			next;
		}

		unless($got_na) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
					 'Could\'t observe NA</B></FONT><BR>');
			return(-1);
		}
	
		last;
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndRecvNsNone2ProbeSuspicious()       #
#--------------------------------------#
sub
ndRecvNsNone2ProbeSuspicious($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @na     = @$na_ref;
	my @frames = ucastNS($ns);

	vSend($Link, 'nd_ucast_ns_local');

	for(my $d = 0, my $got_na = 0; ; $d ++) {
		my %ret = vRecvWrapper($Link,
			$d ? $DELAY_FIRST_PROBE_TIME + $TimeOut : $TimeOut,
			$SeekTime, 0,
			$d ? @frames : @na);

		if($ret{'recvCount'}) {
			foreach my $frame (@na) {
				if($ret{'recvFrame'} eq $frame) {
					$got_na ++;
					last;
				}
			}

			unless($got_na) {
				vLogHTML('<FONT COLOR="#FF0000"><B>'.
					'Could\'t observe NA</B></FONT><BR>');
				return(-1);
			}

			foreach my $frame (@frames) {
				if($ret{'recvFrame'} eq $frame) {
					return(flushBuffer($Link,
						$TimeOut, $TimeOut));
				}
			}

			next;
		}

		unless($got_na) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'Could\'t observe NA</B></FONT><BR>');
			return(-1);
		}
	
		last;
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#------------------------------#
# ndRecvNsIncomplete2Probe()   #
#------------------------------#
sub
ndRecvNsIncomplete2Probe($$$$)
{
	my ($Link, $ns, $ereq, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);
	my $erep	= $hash_erep{$ereq};
	my $EnterDelay	= 0;

	my $got_erep = 0;
	my $got_na = 0;

	vSend($Link, $ns);

	for($got_erep = 0, $got_na = 0; ; ) {
		my %ret0 = vRecvWrapper($Link,
			$TimeOut,
			$SeekTime, 0,
			$got_na   ? '' : @na,
			$got_erep ? '' : $erep);

		if($ret0{'recvCount'}) {
			foreach my $frame (@na) {
				if($ret0{'recvFrame'} eq $frame) {
					$got_na ++;

					unless($got_erep) {
						$EnterDelay = $SeekTime;
					}

					last;
				}
			}

			if($ret0{'recvFrame'} eq $erep) {
				$got_erep ++;

				unless($got_na) {
					$EnterDelay = $SeekTime;
				}
			}

			if($got_erep && $got_na) {
				last;
			}

			next;
		}

		last;
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $EnterDelay, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#---------------------------------------------#
# ndRecvNsIncomplete2ProbeWithEchoRequest()   #
#---------------------------------------------#
sub
ndRecvNsIncomplete2ProbeWithEchoRequest($$$$)
{
	my ($Link, $ns, $ereq, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);
	my $erep	= $hash_erep{$ereq};
	my $EnterDelay	= 0;

	my $got_erep = 0;
	my $got_na = 0;

	vSend($Link, $ns);

	for($got_erep = 0, $got_na = 0; ; ) {
		my %ret0 = vRecvWrapper($Link,
			$TimeOut,
			$SeekTime, 0,
			$got_na   ? '' : @na,
			$got_erep ? '' : $erep);

		if($ret0{'recvCount'}) {
			foreach my $frame (@na) {
				if($ret0{'recvFrame'} eq $frame) {
					$got_na ++;

					unless($got_erep) {
						$EnterDelay = $SeekTime;
					}

					last;
				}
			}

			if($ret0{'recvFrame'} eq $erep) {
				$got_erep ++;

				unless($got_na) {
					$EnterDelay = $SeekTime;
				}
			}

			if($got_erep && $got_na) {
				last;
			}

			next;
		}

		last;
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	#---- for v2.6.2
	vSend($Link, $ereq);

	my %ret1 = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	unless($ret1{'recvCount'}) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
				 'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}
	#---- for v2.6.2

	my %ret2 = vRecvWrapper($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
							$EnterDelay, 0, @frames);

	if($ret2{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret2{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndSetNa4ucastNs()            #
#------------------------------#
sub
ndSetNa4ucastNs()
{
	my @na = ();

	if($V6evalTool::NutDef{'Type'} ne 'host') {
		push(@na, 'nd_recv_na_RSO_tll');
		push(@na, 'nd_recv_na_RSO_tll_GL');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_RSo_tll');
			push(@na, 'nd_recv_na_RSo_tll_GL');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_RSo');
			push(@na, 'nd_recv_na_RSo_GL');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_RSO');
				push(@na, 'nd_recv_na_RSO_GL');
			}
		}
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		push(@na, 'nd_recv_na_rSO_tll');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_rSo');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_rSO');
			}
		}
	}

	if($V6evalTool::NutDef{'Type'} eq 'special') {
		push(@na, 'nd_recv_na_rSO_tll_GL');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_GL');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_rSo_GL');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_rSO_GL');
			}
		}
	}

	return(@na);
}

#------------------------------#
# ndSetNa4dadNs()              #
#------------------------------#
sub
ndSetNa4dadNs()
{
	my @na = ();

	if($V6evalTool::NutDef{'Type'} ne 'host') {
		push(@na, 'nd_dad_na_RsO_tll');
		push(@na, 'nd_dad_na_RsO_tll_global');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_dad_na_Rso_tll');
			push(@na, 'nd_dad_na_Rso_tll_global');
		}
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		push(@na, 'nd_dad_na_rsO_tll');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_dad_na_rso_tll');
		}
	}

	if($V6evalTool::NutDef{'Type'} eq 'special') {
		push(@na, 'nd_dad_na_rsO_tll_global');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_dad_na_rso_tll_global');
		}
	}

	return(@na);
}

#------------------------------#
# ndSetNa4mcastNs()            #
#------------------------------#
sub
ndSetNa4mcastNs()
{
	my @na = ();

	if($V6evalTool::NutDef{'Type'} ne 'host') {
		push(@na, 'nd_recv_na_RSO_tll');
		push(@na, 'nd_recv_na_RSO_tll_GL');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_RSo_tll');
			push(@na, 'nd_recv_na_RSo_tll_GL');
		}
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		push(@na, 'nd_recv_na_rSO_tll');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll');
		}
	}

	if($V6evalTool::NutDef{'Type'} eq 'special') {
		push(@na, 'nd_recv_na_rSO_tll_GL');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_GL');
		}
	}

	return(@na);
}

#------------------------------#
# ndSetNa4ucastNsX()           #
#------------------------------#
sub
ndSetNa4ucastNsX()
{
	my @na = ();

	if($V6evalTool::NutDef{'Type'} ne 'host') {
		push(@na, 'nd_recv_na_RSO_tll_x');
		push(@na, 'nd_recv_na_RSO_tll_GL_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_RSo_tll_x');
			push(@na, 'nd_recv_na_RSo_tll_GL_x');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_RSo_x');
			push(@na, 'nd_recv_na_RSo_GL_x');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_RSO_x');
				push(@na, 'nd_recv_na_RSO_GL_x');
			}
		}
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		push(@na, 'nd_recv_na_rSO_tll_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_x');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_rSo_x');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_rSO_x');
			}
		}
	}

	if($V6evalTool::NutDef{'Type'} eq 'special') {
		push(@na, 'nd_recv_na_rSO_tll_GL_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_GL_x');
		}

		if($IGN_UNI_NA_TLL) {
			push(@na, 'nd_recv_na_rSo_GL_x');

			if($IGN_NA_O_FLAG) {
				push(@na, 'nd_recv_na_rSO_GL_x');
			}
		}
	}

	return(@na);
}

#------------------------------#
# ndSetNa4mcastNsX()           #
#------------------------------#
sub
ndSetNa4mcastNsX()
{
	my @na = ();

	if($V6evalTool::NutDef{'Type'} ne 'host') {
		push(@na, 'nd_recv_na_RSO_tll_x');
		push(@na, 'nd_recv_na_RSO_tll_GL_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_RSo_tll_x');
			push(@na, 'nd_recv_na_RSo_tll_GL_x');
		}
	}

	if($V6evalTool::NutDef{'Type'} ne 'router') {
		push(@na, 'nd_recv_na_rSO_tll_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_x');
		}
	}

	if($V6evalTool::NutDef{'Type'} eq 'special') {
		push(@na, 'nd_recv_na_rSO_tll_GL_x');

		if($IGN_NA_O_FLAG) {
			push(@na, 'nd_recv_na_rSo_tll_GL_x');
		}
	}

	return(@na);
}

#--------------------------------------#
# ndRecvNsReachable2Reachable()        #
#--------------------------------------#
sub
ndRecvNsReachable2Reachable($$$)
{
	my ($Link, $ns, $na) = @_;

	my @frames = @$na;

	# Test Procedure 7
	vSend($Link, $ns);
	
	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret0{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret0{'recvFrame'} eq $frame) {
				my %ret1 = vRecvWrapper($Link,
					$DELAY_FIRST_PROBE_TIME +
					$RETRANS_TIMER * $MAX_UNICAST_SOLICIT
					+ 1, $SeekTime, 0);

				if($ret1{'recvCount'}) {
					vLogHTML('<FONT COLOR="#FF0000"><B>'.
						'Observed unexpected packet'.
						'</B></FONT><BR>');

					return(-1);
				}

				return(0);
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NA</B></FONT><BR>');
	return(-1);
}


#-----------------------------------------------------#
# ndRecvNsReachable2ReachableWithEchoRequest()        #
#-----------------------------------------------------#
sub
ndRecvNsReachable2ReachableWithEchoRequest($$$)
{
	my ($Link, $ns, $na) = @_;

	my @frames = @$na;

	# Test Procedure 7 or 25
	vSend($Link, $ns);
	# Test Procedure 8 or 26
	vSend($Link, 'ndisc_ereq_LL');

	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret0{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret0{'recvFrame'} eq $frame) {
				last;
			}
		}
	}

	my %ret1 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, 'ndisc_erep_LL');

	if ($ret1{'recvCount'}) {
		if($ret1{'recvFrame'} ne 'ndisc_erep_LL') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
					 '</B></FONT><BR>');
			return(-1);
		}
	}
	else {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	return (0);
}

#------------------------------#
# ndRecvNsReachable2Probe()    #
#------------------------------#
sub
ndRecvNsReachable2Probe($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
			 '</B></U></FONT><BR>');

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	vSend($Link, $ns);

	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#---------------------------------------------#
# ndRecvNsReachable2ProbeWithEchoRequest()    #
#---------------------------------------------#
sub
ndRecvNsReachable2ProbeWithEchoRequest($$$$)
{
	my ($Link, $ns, $erep, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	# Test Procedure 16 or 34
	vSend($Link, $ns);
	# Test Procedure 17 or 35
	vSend($Link, 'ndisc_ereq_LL');

	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, $erep);
	if ($ret1{'recvCount'}) {
		if($ret1{'recvFrame'} ne $erep) {
			vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
					 '</B></FONT><BR>');
			return(-1);
		}
	}
	else {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}


	my %ret2 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret2{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret2{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndSendNsRecvNaStale()        #
#------------------------------#
sub
ndSendNsRecvNaStale($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	vSend($Link, $ns);

	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				return(0);
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NA</B></FONT><BR>');
	return(-1);
}

#------------------------------#
# ndRecvNsDelay2Probe()        #
#------------------------------#
sub
ndRecvNsDelay2Probe($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	vSend($Link, $ns);

	my %ret0 = vRecv($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndRecvNsDelay2Stale()        #
#------------------------------#
sub
ndRecvNsDelay2Stale($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	vSend($Link, $ns);

	my %ret0 = vRecvWrapper($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndRecvNsProbe2Probe()        #
#------------------------------#
sub
ndRecvNsProbe2Probe($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	vSend($Link, $ns);

	my %ret0 = vRecv($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#---------------------------------------------#
# ndRecvNsProbe2ProbeWithEchoRequest()        #
#---------------------------------------------#
sub
ndRecvNsProbe2ProbeWithEchoRequest($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	# Test Procedure 9 or 31
	vSend($Link, $ns);
	# Test Procedure 10 or 32
	vSend($Link, 'ndisc_ereq_LL');

	my %ret0 = vRecv($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, 'ndisc_erep_LL');

	if ($ret1{'recvCount'}) {
		if($ret1{'recvFrame'} ne 'ndisc_erep_LL') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
					 '</B></FONT><BR>');
			return(-1);
		}
	}
	else {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	my %ret2 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret2{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret2{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndRecvNsProbe2Stale()        #
#------------------------------#
sub
ndRecvNsProbe2Stale($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	vSend($Link, $ns);

	my %ret0 = vRecvWrapper($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret1{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret1{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#---------------------------------------------#
# ndRecvNsProbe2StaleWithEchoRequest()        #
#---------------------------------------------#
sub
ndRecvNsProbe2StaleWithEchoRequest($$$)
{
	my ($Link, $ns, $na_ref) = @_;

	my @na		= @$na_ref;
	my @frames	= ucastNS($ns);

	my $got_na = 0;

	# Test Procedure 20 or 42
	vSend($Link, $ns);
	# Test Procedure 21 or 43
	vSend($Link, 'ndisc_ereq_LL');

	my %ret0 = vRecvWrapper($Link, $TimeOut, 0, 0, @na);

	if($ret0{'recvCount'}) {
		foreach my $frame (@na) {
			if($ret0{'recvFrame'} eq $frame) {
				$got_na ++;
				last;
			}
		}
	}

	unless($got_na) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NA</B></FONT><BR>');
		return(-1);
	}

	my %ret1 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, 'ndisc_erep_LL_diff');

	if ($ret1{'recvCount'}) {
		if($ret1{'recvFrame'} ne 'ndisc_erep_LL_diff') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
					 '</B></FONT><BR>');
			return(-1);
		}
	}
	else {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	my %ret2 = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut, $SeekTime, 0, @frames);

	if($ret2{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret2{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');

	return(-1);
}

#------------------------------#
# ndSendNaNone2None()          #
#------------------------------#
sub
ndSendNaNone2None($$)
{
	my ($Link, $na) = @_;

	my $ereq = 'ndisc_ereq_LL';

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>Procedure</B></U></FONT><BR>');

	my @frames = mcastNS($ereq);

	vSend($Link, $na);

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndSendNaIncomplete2Incomplete()      #
#--------------------------------------#
sub
ndSendNaIncomplete2Incomplete($$$)
{
	my ($Link, $ereq, $na) = @_;

	my @frames = mcastNS($ereq);

	vSend($Link, $na);

	my %ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndSendNaIncomplete2Stale()           #
#--------------------------------------#
sub
ndSendNaIncomplete2Stale($$$)
{
	my ($Link, $ereq, $na) = @_;

	my $got_erep = 0;

	my $erep = $hash_erep{$ereq};

	vSend($Link, $na);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	# my @frames = ucastNS($ereq);
	# 
	# %ret = vRecvWrapper($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
	# 	$SeekTime, 0, @frames);
	# 
	# if($ret{'recvCount'}) {
	# 	foreach my $frame (@frames) {
	# 		if($ret{'recvFrame'} eq $frame) {
	# 			return(flushBuffer($Link, $TimeOut, $TimeOut));
	# 		}
	# 	}
	# }
	# 
	# vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	# return(-1);
	return(0);
}

#--------------------------------------#
# ndSendNaIncomplete2Reachable()       #
#--------------------------------------#
sub
ndSendNaIncomplete2Reachable($$$)
{
	my ($Link, $ereq, $na) = @_;

	my $got_erep = 0;

	my $erep = $hash_erep{$ereq};

	vSend($Link, $na);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	#%ret = vRecvWrapper($Link,
	#	$DELAY_FIRST_PROBE_TIME +
	#	$RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, $SeekTime, 0);
	#
	#if($ret{'recvCount'}) {
	#	vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
	#		'</B></FONT><BR>');
	#
	#	return(-1);
	#}

	return(0);
}

#--------------------------------------#
# ndSendNaReachable2Reachable()        #
#--------------------------------------#
sub
ndSendNaReachable2Reachable($$$)
{
	my ($Link, $ereq, $na) = @_;

	my $got_erep = 0;

	my $erep = $hash_erep{$ereq};

	vSend($Link, $na);

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	%ret = vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME +
		$RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1,
		$SeekTime, 0, 'ns_any2any');

	if($ret{'recvFrame'} eq 'ns_any2any') {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
			'</B></FONT><BR>');

		return(-1);
	}

	return(0);
}

#--------------------------------------#
# ndSendNaReachable2Stale()            #
#--------------------------------------#
sub
ndSendNaReachable2Stale($$$)
{
	my ($Link, $ereq, $na) = @_;

	my $got_erep = 0;

	my $erep = $hash_erep{$ereq};

	vSend($Link, $na);

	vSend($Link, $ereq);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $erep);

	if($ret{'recvCount'}) {
		if($ret{'recvFrame'} eq $erep) {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return(-1);
	}

	my @frames = ucastNS($ereq);

	%ret = vRecvWrapper($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
		$SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndSendNaDelay2Delay()                #
#--------------------------------------#
sub
ndSendNaDelay2Delay($$$)
{
	my ($Link, $ereq, $na) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	vSend($Link, $na);

	my @frames = ucastNS($ereq);

	%ret = vRecvWrapper($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
		$SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndSendNaProbe2Probe()                #
#--------------------------------------#
sub
ndSendNaProbe2Probe($$$)
{
	my ($Link, $ereq, $na) = @_;

	vSend($Link, $na);

	my @frames = ucastNS($ereq);

	%ret = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#--------------------------------------#
# ndSendNaReachable2ReachableFalse()   #
#--------------------------------------#
sub
ndSendNaReachable2ReachableFalse($$)
{
	my ($Link, $na) = @_;

	my @frames = ('ns_l2l', 'ns_g2l', 'ndisc_erep_offlink');

	# 6.
	# TR1 transmits Neighbor Advertisement A (B, C or D)

	vSend($Link, $na);

	# 7.
	# TN1 transmits Packet A

	vSend($Link, 'ndisc_ereq_offlink');

	# 8.
	# Observe the packets transmitted by the HUT.
	# The HUT MUST not transmit an Echo Reply using TR1 as the first hop
	# in response to Packet A in Step 7 and the HUT MUST not transmit
	# multicast NS's with a target set to TR1's link-local.
	%ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if ($ret{'recvCount'}) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Could observe NS</B></FONT><BR>');
			return(-1);
		} elsif ($ret{'recvFrame'} eq 'ns_g2l') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Could observe NS</B></FONT><BR>');
			return(-1);
		} elsif ($ret{'recvFrame'} eq 'ndisc_erep_offlink') {
			vLogHTML('<FONT COLOR="#FF0000"><B>Could observe Echo Reply</B></FONT><BR>');
			return(-1);
		}
	}

	return(flushBuffer($Link, $TimeOut, $TimeOut));
}



#--------------------------------------#
# ndSendNaReachable2StaleFalseX()      #
#--------------------------------------#
sub
ndSendNaReachable2StaleFalseX($$)
{
	my ($Link, $na) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @frames = ();

	push(@frames, 'ndisc_mcast_ns_sll_GG_h0_link1');
	push(@frames, 'ndisc_mcast_ns_sll_LG_h0_link1');

	vSend($Link, $na);

	vSend($Link, 'ndisc_ereq_offlink_diff');

	%ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	if($ret{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret{'recvFrame'} eq $frame) {
				return(flushBuffer($Link, $TimeOut, $TimeOut));
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	return(-1);
}

#----------------------#
# rdSendRsIgnore()     #
#----------------------#
sub
ndSendNsIgnore($$)
{
	my ($Link, $ns) = @_;

	my $frame	= 'na_any2any';

	vClear($Link);
	vSend($Link, $ns);

	my %ret = vRecvWrapper($Link, $TimeOut, 0, 0, $frame);

	if($ret{'recvFrame'} eq $frame) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Observed unexpected packet'.
			'</B></FONT><BR>');

		return(-1);
	}

	return(0);

	#my $ereq	= 'ndisc_ereq_LL';
	#my @frames	= mcastNS($ereq);

	#vClear($Link);
	#vSend($Link, $ereq);

	#%ret = vRecvWrapper($Link, $TimeOut, 0, 0, @frames);

	#if($ret{'recvCount'}) {
	#	foreach my $frame (@frames) {
	#		if($ret{'recvFrame'} eq $frame) {
	#			return(flushBuffer($Link, $TimeOut, $TimeOut));
	#		}
	#	}
	#}

	#vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS</B></FONT><BR>');
	#return(-1);
}

#----------------------#
# ndRecvDadNs()        #
#----------------------#
sub
ndRecvDadNs($$$)
{
	my ($Link, $ns, $na) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @frames = @$na;

	vSend($Link, $ns);

	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);

	if($ret0{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret0{'recvFrame'} eq $frame) {
				return(0);
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NA</B></FONT><BR>');
	return(-1);
}

#----------------------#
# ndSendNsRecvNa()     #
#----------------------#
sub
ndSendNsRecvNa($$$)
{
	my ($Link, $ns, $na) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>TEST PROCEDURE'.
		'</B></U></FONT><BR>');

	my @frames = mcastNS('ndisc_ereq_LL');

	my $got_ns	= 0;
	my $recv_ns	= '';

	vSend($Link, $ns);
	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @frames);
	if($ret0{'recvCount'}) {
		foreach my $frame (@frames) {
			if($ret0{'recvFrame'} eq $frame) {
				$recv_ns = $frame;
				$got_ns ++;
				last;
			}
		}
	}

	unless($got_ns) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NS'.
			'</B></FONT><BR>');

		return(-1);
	}

	my @nas = @$na;

	vSend($Link, $hash_na{$recv_ns});
	my %ret0 = vRecvWrapper($Link, $TimeOut, $SeekTime, 0, @nas);
	if($ret0{'recvCount'}) {
		foreach my $frame (@nas) {
			if($ret0{'recvFrame'} eq $frame) {
				return(0);
			}
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe NA</B></FONT><BR>');
	return(-1);
}

#----------------------#
# ndOfflinkEchoDelay() #
#----------------------#
sub
ndOfflinkEchoDelay($)
{
	my ($Link) = @_;

	my $returnv = 0;

	my $got_erep	= 0;

	vSend($Link, 'global_ereq');
	my %ret0 = vRecv($Link, $TimeOut, 0, 0, 'global_erep');
	if($ret0{'recvCount'}) {
		if($ret0{'recvFrame'} eq 'global_erep') {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
			'</B></FONT><BR>');

		$returnv = -1;

		return(-1);
	}

	vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME +
		$RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, $SeekTime, 0);

	return($returnv);
}

#------------------------------#
# ndOfflinkEchoDelayX()        #
#------------------------------#
sub
ndOfflinkEchoDelayX($)
{
	my ($Link) = @_;

	my $returnv = 0;

	my $got_erep	= 0;

	vSend($Link, 'global_ereq_x');
	my %ret0 = vRecv($Link, $TimeOut, 0, 0, 'global_erep_x');

	if($ret0{'recvCount'}) {
		if($ret0{'recvFrame'} eq 'global_erep_x') {
			$got_erep ++;
		}
	}

	unless($got_erep) {
		vLogHTML('<FONT COLOR="#FF0000"><B>Could\'t observe Echo Reply'.
			'</B></FONT><BR>');

		$returnv = -1;

		return(-1);
	}

	vRecvWrapper($Link,
		$DELAY_FIRST_PROBE_TIME +
		$RETRANS_TIMER * $MAX_UNICAST_SOLICIT + 1, $SeekTime, 0);

	return($returnv);
}

1;
