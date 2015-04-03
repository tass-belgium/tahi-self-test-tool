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
# $TAHI: ct/nd.p2/redirect.pm,v 1.29 2008/06/30 04:56:30 akisada Exp $
#
########################################################################

package redirect;

use Exporter;
use common;

BEGIN {}
END   {}

@ISA = qw(Exporter);

@EXPORT = qw(
	additionalSetup_v6LC_2_3_16_A
	additionalSetup_v6LC_2_3_17
	v6LC_2_3_1_A_B_E_F
	v6LC_2_3_1_C_D_G_H
	v6LC_2_3_2
	v6LC_2_3_3
	v6LC_2_3_4
	v6LC_2_3_4_A_B_C_D_E_F_G_H
	v6LC_2_3_4_I
	v6LC_2_3_4_E_F
	v6LC_2_3_5
	v6LC_2_3_6
	v6LC_2_3_7
	v6LC_2_3_8
	v6LC_2_3_9
	v6LC_2_3_10_A
	v6LC_2_3_10_B_C_D
	v6LC_2_3_11_A
	v6LC_2_3_11_B_C_D
	v6LC_2_3_12_A_B
	v6LC_2_3_12_C_D_E
	v6LC_2_3_13_A_B
	v6LC_2_3_13_C_D_E
	v6LC_2_3_14_A_B
	v6LC_2_3_14_C_D_E
	v6LC_2_3_15
	v6LC_2_3_16_A_B
	v6LC_2_3_16_A
	v6LC_2_3_16_C
	v6LC_2_3_16_D
	v6LC_2_3_17
);

push(@EXPORT, sort(@common::EXPORT));

#------------------------------#
# global variables             #
#------------------------------#
$pktdesc{'tn1_ereq_offlink_via_tr1'} =
	'    Send Echo Request via TR1: '.
	'TN1 (off-link global) -&gt; RUT (global)';

$pktdesc{'tn4_ereq_offlink_via_rut'} =
	'    Send Echo Request via RUT: '.
	'TN4 (global) -&gt; TN2 (off-link global)';

$pktdesc{'tn4_ereq_offlink_via_tr1'} =
	'    Recv Echo Request via TR1: '.
	'TN4 (global) -&gt; TN2 (off-link global)';

$pktdesc{'tn1_erep_offlink_via_tr1'} =
	'    Recv Echo Reply via TR1: '.
	'RUT (global) -&gt; TN1 (off-link global)';

$pktdesc{'tn1_erep_offlink_via_tr2'} =
	'    Recv Echo Reply via TR2: '.
	'RUT (global) -&gt; TN1 (off-link global)';

$pktdesc{'tn1_erep_offlink_via_tr3'} =
	'    Recv Echo Reply via TR3: '.
	'RUT (global) -&gt; TN1 (off-link global)';

$pktdesc{'tn1_erep_offlink'} =
	'    Recv Echo Reply: '.
	'RUT (global) -&gt; TN1 (off-link global)';



#--------------------------------------#
# additionalSetup_v6LC_2_3_16_A()      #
#--------------------------------------#

# i.
# 	TN2 is an on-link neighbor on Link B to TN1
# 	(instead of residing on Link A depicted in Common Topology).

# ii.
# 	RUT advertises prefix X on Link B.

sub
additionalSetup_v6LC_2_3_16_A($)
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
		"addr=$addr",
		'len=64',
		'type=unicast'
	)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'manualaddrconf.rmt: Could\'t set the address'.
			'</B></FONT><BR>');
		return($false);
	}

	if(vRemote(
		'manualaddrconf.rmt',
		"if=$V6evalTool::NutDef{'Link0_device'}",
		'addr=3ffe:501:ffff::',
		'len=64',
		'type=anycast'
	)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'manualaddrconf.rmt: Could\'t set the address'.
			'</B></FONT><BR>');
		return($false);
	}

	$rut_addr_v6LC_2_3_16_A	= $true;

	ignoreDAD($Link);

	return($true);
}



#--------------------------------------#
# additionalSetup_v6LC_2_3_17()        #
#--------------------------------------#

# i.
# 	Configure the RUT with a static route
#	to TN2's Link B prefix through TR1.

sub
additionalSetup_v6LC_2_3_17($)
{
        my ($Link) = @_;

	if(vRemote(
		'route.rmt',
		'cmd=add',
		'prefix=3ffe:501:ffff::',
		'prefixlen=64',
		"gateway=fe80::200:ff:fe00:a0a0",
		"if=$V6evalTool::NutDef{'Link0_device'}"
	)) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'route.rmt: Could\'t set route'.
			'</B></FONT><BR>');
		return($false);
	}

	$tr1_route_2_3_17	= $true;

	return($true);
}



#------------------------------#
# v6LC_2_3_1_A_B_E_F()         #
#------------------------------#
sub
v6LC_2_3_1_A_B_E_F($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 3.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TN1.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tn1_offlink_cache = $true;

# 4.
# 	TN1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.  

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_offlink));

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 5.
# 	Observe the packets transmitted by the HUT. 

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_offlink{$frame});
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_1_C_D_G_H()         #
#------------------------------#
sub
v6LC_2_3_1_C_D_G_H($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 3.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TN1.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tn1_offlink_cache = $true;

# 4.
# 	TN1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.  

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 5.
# 	Observe the packets transmitted by the HUT. 

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
		0, 0);

	$tn1_offlink_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_2()                 #
#------------------------------#
sub
v6LC_2_3_2($)
{
	my ($Link) = @_;

	return(v6LC_2_3_1_C_D_G_H($Link));
}



#------------------------------#
# v6LC_2_3_3()                 #
#------------------------------#
sub
v6LC_2_3_3($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 3.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TN1.
# 	The Redirect message contains an incorrect IPv6 Source Address
# 	(the off-link global address of TN2).

	vSend($Link, 'local_redirect');
	$tn1_offlink_cache = $true;

# 4.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.  

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 5.
# 	Observe the packets transmitted by the HUT. 

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	$tn1_offlink_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_4()                 #
#------------------------------#
sub
v6LC_2_3_4($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

#----------------------------------------------------------------------#
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
			'Could\'t observe NS</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}
#----------------------------------------------------------------------#

# 1.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 4.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

#	vRecv($Link,
#		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
#		0, 0);
#
#	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_4_A_B_C_D_E_F_G_H() #
#------------------------------#
sub
v6LC_2_3_4_A_B_C_D_E_F_G_H($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# # 3.
# # 	TR2 transmits a Router Advertisement with a non-zero Router Lifetime
# # 	and a Source Link-layer Address option.
# 
# 	vSend($Link, 'tr2_ra_common_sll');
# 	$tr2_default	= $true;
# 	$tr2_prefix	= $true;
# 	$tr2_cache	= $true;

# 4.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_4_I()               #
#------------------------------#
sub
v6LC_2_3_4_I($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 8.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 9.
# 	Observe the packets transmitted by the HUT. 

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 10.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 11.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 12.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

	vRecv($Link,
		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
		0, 0);

	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_4_E_F()             #
#------------------------------#
sub
v6LC_2_3_4_E_F($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# # 3.
# # 	TR2 transmits a Router Advertisement with a non-zero Router Lifetime
# # 	and a Source Link-layer Address option.
# 
# 	vSend($Link, 'tr2_ra_common_sll');
# 	$tr2_default	= $true;
# 	$tr2_prefix	= $true;
# 	$tr2_cache	= $true;

# 4.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	my $bool	= $false;
	my @frames	= sort(keys(%tr2_mcast_nd_common));

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tr2_mcast_nd_common{$frame});
			$tr2_cache	= $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

#	vRecv($Link,
#		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
#		0, 0);

#	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_5()                 #
#------------------------------#
sub
v6LC_2_3_5($)
{
	my ($Link) = @_;

#	return(v6LC_2_3_4_A_B_C_D_E_F_G_H($Link));
	return(v6LC_2_3_4($Link));
}



#------------------------------#
# v6LC_2_3_6()                 #
#------------------------------#
sub
v6LC_2_3_6($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

#----------------------------------------------------------------------#
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
			'Could\'t observe NS</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}
#----------------------------------------------------------------------#

# 1.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}

# 4.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains an incorrect IPv6 Source Address
# 	(the off-link global address of TN2).

	vSend($Link, 'local_redirect');

# 5.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_7()                 #
#------------------------------#
sub
v6LC_2_3_7($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

#----------------------------------------------------------------------#
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
			'Could\'t observe NS</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}
#----------------------------------------------------------------------#

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
			'Could\'t observe NS</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr3_erep_common');
	unless($ret{'recvFrame'} eq 'tr3_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}
#----------------------------------------------------------------------#

# 1.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 4.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.

	vSend($Link, 'local_redirect_tr1');
	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 8.
# 	TR2 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR3.

	vSend($Link, 'local_redirect_tr2');
	$tr3_cache	= $true;

# 9.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 10.
# 	Observe the packets transmitted by the HUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr3');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr3') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 	vRecv($Link,
# 		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
# 		0, 0);
# 
# 	$tr2_cache = $false;
# 	$tr3_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_8()                 #
#------------------------------#
sub
v6LC_2_3_8($)
{
	my ($Link) = @_;

#	return(v6LC_2_3_4_A_B_C_D_E_F_G_H($Link));
	return(v6LC_2_3_4($Link));
}



#------------------------------#
# v6LC_2_3_9()                 #
#------------------------------#
sub
v6LC_2_3_9($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

#----------------------------------------------------------------------#
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
			'Could\'t observe NS</B></FONT><BR>');
		return($false);
	}

	%ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}
#----------------------------------------------------------------------#

# 1.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN1.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-Layer option
# 	with the link-layer address of TR2.

	vSend($Link, 'local_redirect');
	$tr2_cache = $true;

# 2.
# 	TR1 forwards an Echo Request from TN1 to the HUT.
# 	The IPv6 Source Address is the off-link global address of TN1.
# 	The IPv6 Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 3.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr2');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr2') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply</B></FONT><BR>');
		return($false);
	}

#	vRecv($Link,
#		$DELAY_FIRST_PROBE_TIME + $TimeOut * $MAX_UNICAST_SOLICIT,
#		0, 0);
#
#	$tr2_cache = $false;

	return($true);
}



#------------------------------#
# v6LC_2_3_10_A()              #
#------------------------------#
sub
v6LC_2_3_10_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 1.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 3.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 4.
# 	Wait 2 seconds and observe the packets transmitted by the HUT.

	return(is_tr2_incomplete($Link));
}



#------------------------------#
# v6LC_2_3_10_B_C_D()          #
#------------------------------#
sub
v6LC_2_3_10_B_C_D($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 1.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 3.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 4.
# 	Wait 2 seconds and observe the packets transmitted by the HUT.

	return(is_tr2_stale($Link));
}



#------------------------------#
# v6LC_2_3_11_A()              #
#------------------------------#
sub
v6LC_2_3_11_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 1.
# 	TR2 transmits a link-local Echo Request to the HUT.
# 	TR2 does not reply to Neighbor Solicitations.

# 2.
# 	Observe packets transmitted by the HUT.

	unless(tr2_none_to_incomplete($Link)) {
		return($false);
	}

# 3.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

# 4.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 5.
# 	Observe the packets transmitted by the HUT.

	return(is_tr2_incomplete($Link));
}



#------------------------------#
# v6LC_2_3_11_B_C_D()          #
#------------------------------#
sub
v6LC_2_3_11_B_C_D($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 6.
# 	TR2 transmits a link-local Echo Request to the HUT.
# 	TR2 does not reply to Neighbor Solicitations.

# 7.
# 	Observe the packets transmitted by the HUT.

	unless(tr2_none_to_incomplete($Link)) {
		return($false);
	}

# 8.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');
	$tr2_cache	= $true;

# 9.
# 	Observe the packets transmitted by the HUT.

	return(is_tr2_stale($Link));
}



#------------------------------#
# v6LC_2_3_12_A_B()            #
#------------------------------#
sub
v6LC_2_3_12_A_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(tr2_none_to_reachable($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 1.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 3.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 4.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 5.
# 	Wait 2 seconds.

# 6.
# 	Wait DELAY_FIRST_PROBE_TIME.  (5 seconds)

# 7.
# 	Observe the packets transmitted by the HUT.

	my @mframes	= sort(keys(%tr2_mcast_nd_common));
	my @uframes	= sort(keys(%tr2_ucast_nd_common));

	%ret = vRecv($Link, $DELAY_FIRST_PROBE_TIME + $TimeOut,
		0, 0, @mframes, @uframes);
	foreach my $frame (@mframes) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'HUT is in INCOMPLETE'.
				'</B></FONT><BR>');

			vRecv($Link,
				$TimeOut * ($MAX_MULTICAST_SOLICIT - 1),
				0, 0);

			$tr2_cache	= $true;

			return($false);
		}
	}

	foreach my $frame (@uframes) {
		if($ret{'recvFrame'} eq $frame) {
			vLogHTML('<FONT COLOR="#FF0000"><B>'.
				'HUT is in PROBE'.
				'</B></FONT><BR>');

			vRecv($Link,
				$TimeOut * ($MAX_UNICAST_SOLICIT - 1),
				0, 0);

			$tr2_cache	= $true;

			return($false);
		}
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_12_C_D_E()          #
#------------------------------#
sub
v6LC_2_3_12_C_D_E($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	unless(tr2_none_to_reachable($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 1.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 2.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT).  (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 3.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 4.
# 	Observe the packets transmitted by the HUT.

# 5.
# 	Wait 2 seconds.

# 6.
# 	Wait DELAY_FIRST_PROBE_TIME.  (5 seconds)

# 7.
# 	Observe the packets transmitted by the HUT.

	return(is_tr2_stale_diff($Link));
}



#------------------------------#
# v6LC_2_3_13_A_B()            #
#------------------------------#
sub
v6LC_2_3_13_A_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR2 transmits a link-local Echo Request to the HUT.

# 2.
# 	TR2 transmits a solicited Neighbor Advertisement
# 	in response to any Neighbor Solicitations from the HUT.

# 3.
# 	Observer the packets transmitted by the HUT.

# 4.
# 	Wait (REACHCABLE_TIME * MAX_RANDOM_FACTOR). (45 seconds)

	unless(tr2_none_to_stale($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.
	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 7.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 8.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT). (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 9.
# 	TR2 transmits a link-local Echo Request to the HUT.

# 10.
# 	Observe the packets transmitted by the HUT.

# 11.
# 	Wait 2 seconds.

# 12.
# 	Wait DELAY_FIRST_PROBE_TIME. (5 seconds)

# 13.
# 	Observe the packets transmitted by the HUT.

	vSend($Link, 'tr2_ereq_common');

	return(is_tr2_stale($Link));
}



#------------------------------#
# v6LC_2_3_13_C_D_E()          #
#------------------------------#
sub
v6LC_2_3_13_C_D_E($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR2 transmits a link-local Echo Request to the HUT.

# 2.
# 	TR2 transmits a solicited Neighbor Advertisement
# 	in response to any Neighbor Solicitations from the HUT.

# 3.
# 	Observer the packets transmitted by the HUT.

# 4.
# 	Wait (REACHCABLE_TIME * MAX_RANDOM_FACTOR). (45 seconds)

	unless(tr2_none_to_stale($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6
# 	 Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 7.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 8.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT). (3 seconds)
	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 9.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 10.
# 	Observe the packets transmitted by the HUT.

# 11.
# 	Wait 2 seconds.

# 12.
# 	Wait DELAY_FIRST_PROBE_TIME. (5 seconds)

# 13.
# 	Observe the packets transmitted by the HUT.

	return(is_tr2_stale_diff($Link));
}



#------------------------------#
# v6LC_2_3_14_A_B()            #
#------------------------------#
sub
v6LC_2_3_14_A_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR2 transmits a link-local Echo Request to the HUT.

# 2.
# 	TR2 transmits a solicited Neighbor Advertisement
# 	in response to any Neighbor Solicitations from the HUT.

# 3.
# 	Observer the packets transmitted by the HUT.

# 4.
# 	Wait (REACHCABLE_TIME * MAX_RANDOM_FACTOR). (45 seconds)
	unless(tr2_none_to_stale($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

# 5.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 6.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 7.
# 	TR2 transmits an Echo Request from its link-local address to the HUT.

	vSend($Link, 'tr2_ereq_common');

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 8.
# 	Wait DELAY_FIRST_PROBE_TIME. (5 seconds)

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

# 9.
# 	TR1 transmits a Redirect message to the NUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 10.
# 	Observe the packets transmitted by the HUT.

	my @frames	= sort(keys(%tr2_ucast_nd_common));
	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vRecv($Link, $TimeOut, 0, 0);

			vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT,
				0, 0);
			$tr2_cache	= $false;

			return($true);
		}
	}

	vLogHTML('<FONT COLOR="#FF0000"><B>'.
		'Could\'t observe NS'.
		'</B></FONT><BR>');

	return($false);
}



#------------------------------#
# v6LC_2_3_14_C_D_E()          #
#------------------------------#
sub
v6LC_2_3_14_C_D_E($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 12.
# 	TR2 transmits a link-local Echo Request to the HUT.

# 13.
# 	TR2 transmits a solicited Neighbor Advertisement
# 	in response to any Neighbor Solicitations from the HUT.

# 14.
# 	Observer the packets transmitted by the HUT.

# 15.
# 	Wait (REACHCABLE_TIME * MAX_RANDOM_FACTOR). (45 seconds)

	unless(tr2_none_to_stale($Link)) {
		return($false);
	}

	$tr2_cache	= $true;

# 16.
# 	TR1 forwards an Echo Request to the HUT.
# 	The Source Address is the off-link global address of TN1.
# 	The Destination Address is the global address of the HUT.

	vSend($Link, 'tn1_ereq_offlink_via_tr1');

# 17.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 18.
# 	TR2 transmits an Echo Request from its link-local address to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 19.
# 	Observe the packets transmitted by the HUT.

	my %ret = vRecv($Link, $TimeOut, 0, 0, 'tr2_erep_common');
	unless($ret{'recvFrame'} eq 'tr2_erep_common') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 20.
# 	Wait DELAY_FIRST_PROBE_TIME. (5 seconds)

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

# 21.
# 	TR1 transmits a Redirect message to the HUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.
# 	The Redirect message contains a Target Link-layer Address option
# 	or Redirected Packet option according to the table above.

	vSend($Link, 'local_redirect');

# 22.
# 	Wait (RETRANS_TIMER * MAX_*CAST_SOLICIT). (3 seconds)

	vRecv($Link, $RETRANS_TIMER * $MAX_UNICAST_SOLICIT, 0, 0);

# 23.
# 	TR2 transmits a link-local Echo Request to the HUT.

	vSend($Link, 'tr2_ereq_common');

# 24.
# 	Observe the packets transmitted by the HUT.

# 25.
# 	Wait 2 seconds.

# 26.
# 	Wait DELAY_FIRST_PROBE_TIME. (5 seconds)

# 27.
# 	Observe the packets transmitted by the HUT.

	return(is_tr2_stale_diff($Link));
}



#------------------------------#
# v6LC_2_3_15()                #
#------------------------------#
sub
v6LC_2_3_15($)
{
	my ($Link) = @_;

	return(v6LC_2_3_10_A($Link));
}



#------------------------------#
# v6LC_2_3_16_A_B()            #
#------------------------------#
sub
v6LC_2_3_16_A_B($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TN1 transmits an Echo Request to TN2's unicast global address
# 	with prefix X and a first hop through the RUT.

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_onlink));

	vSend($Link, 'local_ereq');

# 2.
# 	Observe the packets transmitted by the RUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			vSend($Link, $tn1_mcast_nd_onlink{$frame});
			$tn1_onlink_cache = $true;
			last;
		}
	}

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe NS'.
			'</B></FONT><BR>');
		return($false);
	}

	$bool = $false;
	@frames = (
		'local_redirect',
		'local_redirect_tll',
		'local_redirect_redirected',
		'local_redirect_comb_64',
		'local_redirect_comb_63'
	);

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames);
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			$bool = $true;
			last;
		}
	}

	vRecv($Link, $TimeOut * $MAX_MULTICAST_SOLICIT, 0, 0);

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Redirect'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_16_A()              #
#------------------------------#
sub
v6LC_2_3_16_A($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TN1 transmits an Echo Request to TN2's unicast global address
# 	with prefix X and a first hop through the RUT.

	my $bool	= $false;
	my @nd_redirect	= sort(keys(%tn1_mcast_nd_onlink));
	my @nd_forward	= sort(keys(%tn1_mcast_nd_onlinkX));

	my @redirect = (
		'local_redirect',
		'local_redirect_tll',
		'local_redirect_redirected',
		'local_redirect_comb_64',
		'local_redirect_comb_63'
	);

	vSend($Link, 'local_ereq');

# 2.
# 	Observe the packets transmitted by the RUT.
#
	for( ; ; ) {
		my $continue	= $false;

		%ret = vRecv($Link, $TimeOut, 0, 0,
			@nd_redirect, @nd_forward, @redirect);

		foreach my $frame (@nd_redirect) {
			if($ret{'recvFrame'} eq $frame) {
				vSend($Link, $tn1_mcast_nd_onlink{$frame});
				$tn1_onlink_cache = $true;
				$continue	= $true;
				last;
			}
		}

		if($continue) {
			next;
		}

		foreach my $frame (@nd_forward) {
			if($ret{'recvFrame'} eq $frame) {
				vSend($Link, $tn1_mcast_nd_onlinkX{$frame});
				$tn1_onlink_cacheX = $true;
				$continue	= $true;
				last;
			}
		}

		if($continue) {
			next;
		}

		foreach my $frame (@redirect) {
			if($ret{'recvFrame'} eq $frame) {
				$bool = $true;
				last;
			}
		}

		last;
	}

	vRecv($Link, $TimeOut * $MAX_MULTICAST_SOLICIT, 0, 0);

	unless($bool) {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Redirect'.
			'</B></FONT><BR>');

		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_16_C()              #
#------------------------------#
sub
v6LC_2_3_16_C($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 6.
# 	TN1 transmits an Echo Request to TN2 with a first hop through the RUT.
# 	The Source Address is TN1's address with an off-link prefix.

	vSend($Link, 'local_ereq');

# 7.
# 	Observe the packets transmitted by the RUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, 'local_redirect');
	if($ret{'recvFrame'} eq 'local_redirect') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe Redirect'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_16_D()              #
#------------------------------#
sub
v6LC_2_3_16_D($)
{
	my ($Link) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

	my $bool	= $false;
	my @frames	= sort(keys(%tn1_mcast_nd_onlink));

# 8.
# 	TN1 transmits an Echo Request to TN2's solicited-node multicast address
# 	with a first hop through the RUT.

	vSend($Link, 'local_ereq');

# 9.
# 	Observe the packets transmitted by the RUT.

	%ret = vRecv($Link, $TimeOut, 0, 0, @frames, 'local_redirect');
	foreach my $frame (@frames) {
		if($ret{'recvFrame'} eq $frame) {
			vSend($Link, $tn1_mcast_nd_onlink{$frame});
			$tn1_onlink_cache = $true;


			%ret = vRecv($Link, $TimeOut, 0, 0, 'local_redirect');
			last;
		}
	}

	if($ret{'recvFrame'} eq 'local_redirect') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Observe Redirect'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



#------------------------------#
# v6LC_2_3_17()                #
#------------------------------#
sub
v6LC_2_3_17($$)
{
	my ($Link0, $Link1) = @_;

	vLogHTML('<FONT COLOR="#FF0000" SIZE="5"><U><B>'.
		'Test Procedure'.
		'</B></U></FONT><BR>');

# 1.
# 	TR1 forwards an Echo Request from TN2 to the RUT.
# 	The Destination Address is the global address of the RUT.

	vSend($Link0, 'tn1_ereq_offlink_via_tr1');

# 2.
# 	Observe the packets transmitted by the RUT.

	my %ret = vRecv($Link0, $TimeOut, 0, 0, 'tn1_erep_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn1_erep_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Reply'.
			'</B></FONT><BR>');
		return($false);
	}

# 3.
# 	TR1 transmits a Redirect message to the RUT.
# 	The ICMPv6 Destination Address is the global address of TN2.
# 	The Target Address is the link-local address of TR2.

	vSend($Link0, 'local_redirect');

# 4.
# 	TN4 transmits an Echo Request to TN2's off link address
# 	using the RUT has its first hop.

	vSend($Link1, 'tn4_ereq_offlink_via_rut');

# 5.
# 	Observe the packets transmitted by the RUT.

	%ret = vRecv($Link0, $TimeOut, 0, 0, 'tn4_ereq_offlink_via_tr1');
	unless($ret{'recvFrame'} eq 'tn4_ereq_offlink_via_tr1') {
		vLogHTML('<FONT COLOR="#FF0000"><B>'.
			'Could\'t observe Echo Request'.
			'</B></FONT><BR>');
		return($false);
	}

	return($true);
}



1;
