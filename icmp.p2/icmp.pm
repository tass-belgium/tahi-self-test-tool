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
# $TAHI: ct/icmp.p2/icmp.pm,v 1.6 2006/07/26 01:04:35 akisada Exp $
#-----------------------------------------------------------------

package icmp;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
		set_default_route
		delete_default_route
		mkNCE_Link
		mkNCE_Global
		sendRA
		createIdDef
		checkNUT
		icmp_vRecv
		setup
		setup_v6LC_5_1_4_A
		cleanup
	    );

use V6evalTool;
require './config.pl';

BEGIN { }
END { }

$type = $V6evalTool::NutDef{Type};

$subPass = 0; #This value presents that subroutine ended normally: subroutine PASS
$subFail = 32; #This value presents that subroutine ended abnormally: subroutine FAIL
$subFatal = 64; #FATAL (terminate series of related tests)

#-----------------------------------------------------------------
# node constants
#-----------------------------------------------------------------
$MAX_MULTICAST_SOLICIT = 3;		# times
$MAX_ANYCAST_DELAY_TIME = 1;		# sec.

$wait_address_resolution = $MAX_MULTICAST_SOLICIT * 3 + 2;	# margin: 2sec.


#----------------------------------------------------------------
# set routes to NUT
#----------------------------------------------------------------
sub set_default_route (;$) {
	$IF = Link0 if ( !$IF );

	my ($lladdr, $interface);

	# NUT Link0 interface
	$interface = $V6evalTool::NutDef{Link0_device};

	# TN Link0 Link Local Address
	$lladdr = vMAC2LLAddr($V6evalTool::TnDef{Link0_addr});

	vRemote("route.rmt", "cmd=add prefix=default gateway=$lladdr " .
		"if=$interface") &&
			return($icmp::subFatal);

	return($icmp::subPass);
}

#----------------------------------------------------------------
# delete routes to NUT
#----------------------------------------------------------------
sub delete_default_route (;$) {
	$IF = Link0 if ( !$IF );

	my ($lladdr, $interface);

	# NUT Link0 interface
	$interface = $V6evalTool::NutDef{Link0_device};

	# TN Link0 Link Local Address
	$lladdr = vMAC2LLAddr($V6evalTool::TnDef{Link0_addr});


	vRemote("route.rmt", "cmd=delete prefix=default gateway=$lladdr " .
		"if=$interface") &&
			return($icmp::subFatal);

	return($icmp::subPass);
}


#-----------------------------------------------------------------
# make Neighbor Cache Entry
# In NUT,
#   make TN's link local address	 
#-----------------------------------------------------------------
sub mkNCE_Link (;$) {
	my ($IF) = @_;
	my ($reachable) = 0;

	$IF = Link0 if (!$IF) ;

#	%main::pktdesc = (
#	    ns_local			=> 'Receive Neighbor Solicitation',
#	    ns_local_sll		=> 'Receive Neighbor Solicitation',
#	    na_local			=> 'Send Neighbor Advertisement',
#	    echo_request_link_local	=> 'Send Echo Request (Link-local address)',
#	    echo_reply_link_local	=> 'Receive Echo Reply (Link-local address)',
#	);

	$main::pktdesc{ns_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_local_sll} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_local} = 'Send Neighbor Advertisement';
	$main::pktdesc{echo_request_link_local} = 'Send Echo Request (Link-local address)';
	$main::pktdesc{echo_reply_link_local} = 'Receive Echo Reply (Link-local address)';

ECHO_AGAIN:
	vSend($IF, echo_request_link_local);

	%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_link_local,
		     ns_local, ns_local_sll);

	if ($ret{status} != 0) {
		vLog("TN can not receive Echo Reply or NS from NUT");
		return($subFail);
	}
	elsif ($ret{recvFrame} eq 'echo_reply_link_local') {
		$reachable++; #hide added,correct?
		# do nothing
	}
	elsif ($ret{recvFrame} eq 'ns_local' ||
	       $ret{recvFrame} eq 'ns_local_sll') {
		vSend($IF, na_local);
		$reachable++;

		%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_link_local);

		if ($ret{status} != 0) {
			vLog("TN can not receive Echo Reply from NUT");
			return($subFail);
		}
		elsif ($ret{recvFrame} eq 'echo_reply_link_local') {
			return($subPass);
		}
		else {
			vLog("TN received an expected packet from NUT");
		};
	};

	if ($reachable == 0) {
		$reachable++;
		goto ECHO_AGAIN;
	}

	return($subPass);
}


#-----------------------------------------------------------------
# make Neighbor Cache Entry
# In NUT,
#   make TN's global local address	 
#-----------------------------------------------------------------
sub mkNCE_Global (;$) {
	my ($IF) = @_;
	my ($reachable) = 0;

	$IF = Link0 if (!$IF) ;
        
#	%main::pktdesc = (
#	    ns_global			=> 'Receive Neighbor Solicitation',
#	    ns_global_sll		=> 'Receive Neighbor Solicitation',
#	    na_global			=> 'Send Neighbor Advertisement',
#	    ns_global_from_local	=> 'Receive Neighbor Solicitation',
#	    ns_global_sll_from_local	=> 'Receive Neighbor Solicitation',
#	    na_global_to_local		=> 'Send Neighbor Advertisement',
#	    echo_request_global		=> 'Send Echo Request (Global address)',
#	    echo_reply_global		=> 'Receive Echo Reply (Global address)',
#	);
	$main::pktdesc{ns_global} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_global_sll} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_global} = 'Send Neighbor Advertisement';
	$main::pktdesc{ns_global_from_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{ns_global_sll_from_local} = 'Receive Neighbor Solicitation';
	$main::pktdesc{na_global_to_local} = 'Send Neighbor Advertisement';
	$main::pktdesc{echo_request_global} = 'Send Echo Request (Global address)';
	$main::pktdesc{echo_reply_global} = 'Receive Echo Reply (Global address)';

ECHO_AGAIN:
	vSend($IF, echo_request_global);

RECV_AGAIN:
	%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_global,
		     ns_global, ns_global_sll,
		     ns_global_from_local, ns_global_sll_from_local,
		     ns_local, ns_local_sll);

	if ($ret{status} != 0) {
		vLog("TN can not receive Echo Reply or NS from NUT");
		return($subFail);
	}
	elsif ($ret{recvFrame} eq 'echo_reply_global') {
		$reachable++; #hide added,correct?
		# do nothing
	}
	elsif ($ret{recvFrame} eq 'ns_global' ||
	       $ret{recvFrame} eq 'ns_global_sll' ||
	       $ret{recvFrame} eq 'ns_global_from_local' ||
	       $ret{recvFrame} eq 'ns_global_sll_from_local' ||
	       $ret{recvFrame} eq 'ns_local' ||
	       $ret{recvFrame} eq 'ns_local_sll') {

		if ($ret{recvFrame} eq 'ns_global' ||
		    $ret{recvFrame} eq 'ns_global_sll') {
			vSend($IF, na_global);
			$reachable++;
		}
		elsif ($ret{recvFrame} eq 'ns_global_from_local' ||
		       $ret{recvFrame} eq 'ns_global_sll_from_local') {
			vSend($IF, na_global_to_local);
			$reachable++;
		}
		elsif ($ret{recvFrame} eq 'ns_local' ||
		       $ret{recvFrame} eq 'ns_local_sll') {
			vSend($IF, na_local);
			goto RECV_AGAIN;
		};

		%ret = vRecv($IF, $wait_reply, 0, 0, echo_reply_global);

		if ($ret{status}) {
			vLog("TN can not receive Echo Reply from NUT");
			return($subFail);
		}
		elsif ($ret{recvFrame} eq 'echo_reply_global') {
			# do nothing
		}
		else {
			vLog("TN received an expected packet from NUT");
		};
	};

	if ($reachable == 0) {
		$reachable++;
		goto ECHO_AGAIN;
	}

	return($subPass);
}


#-----------------------------------------------------------------
# wrapper of vRecv
# handling NSs
#-----------------------------------------------------------------
sub icmp_vRecv ($$$$@) {
	my($interface, $tout, $count, $seektime, @expect) = @_;
	my($rcv_ns_local, $rcv_ns_global);

	$rcv_ns_local = 0;
	$rcv_ns_global = 0;

	while (1) {
		%ret = vRecv($interface, $tout, $count, $seektime,
			     @expect,
			     ns_local, ns_local_sll,
			     ns_global, ns_global_sll);

		if ($ret{recvFrame} eq 'ns_local' ||
		    $ret{recvFrame} eq 'ns_local_sll') {
			if ($rcv_ns_local != 0) {
				last;
			};

			vSend($interface, na_local);
			$rcv_ns_local = 1;
		}
		elsif ($ret{recvFrame} eq 'ns_global' ||
		       $ret{recvFrame} eq 'ns_global_sll') {
			if ($rcv_ns_global != 0) {
				last;
			};

			vSend($interface, na_global);
			$rcv_ns_global = 1;
		}
		else {
			last;
		};
	};

	return(%ret);
}

#-----------------------------------------------------------------
# send RA
#-----------------------------------------------------------------
sub sendRA (;$) {
	my($IF) = @_;
	if (!$IF){
		$IF = "Link0";
		$RApaket = "ra";
	}elsif ($IF eq "Link1"){
		$IF = "Link1";
		$RApaket = "ra";
	}elsif ($IF eq "setup"){
		$IF = "Link0";
		$RApaket = "ra_start";
	}elsif ($IF eq "cleanup"){
		$IF = "Link0";
		$RApaket = "ra_end";
	}

	$main::pktdesc{$RApaket} = 'Send Router Advertisement';

	if($type ne router) {
		vSend($IF, $RApaket);
		#-- this part is for ignoring NS Packet --
		vSleep(5);
		vClear($IF);
	};
}


#-----------------------------------------------------------------
# createIdDef() - create unique Fragment ID and write to ./ID.def
#-----------------------------------------------------------------
sub createIdDef() {
	sleep 1;				# make time unique
	$id = time & 0x00000fff;		# use lower 12 bit
	open(OUT, ">./ID.def") || return 1;

	# Fragment ID (32bit)

	printf OUT "#define FRAG_ID     0x0%07x\n", $id;
	printf OUT "#define FRAG_ID_T   0xf%07x\n", $id;

	# Echo Request ID (16bit)

	printf OUT "#define REQ_ID     0x0%03x\n", $id;
	printf OUT "#define REQ_ID_T   0xf%03x\n", $id;

	# Echo Request Sequence No. (16bit)

	printf OUT "#define SEQ_NO     0x00\n", $id;
	printf OUT "#define SEQ_NO_T   0x0f\n", $id;

	close(OUT);
	return(0);
}

#-----------------------------------------------------------------
# checkNUT() - check NUT type, host or router
#-----------------------------------------------------------------
sub checkNUT($) {
	my ($ntype) = @_;

	if ($ntype eq 'hostrouter') {
		return;
	}
	elsif ($ntype eq 'host' && $type eq 'host') {
		return;
	}
	elsif ($ntype eq 'router' && $type eq 'router') {
		return;
	}
	elsif ($ntype eq 'host' && $type eq 'router') {
		vLogHTML("This test is for a host implimentation.");
		exit($V6evalTool::exitHostOnly);
	}
	elsif ($ntype eq 'router' && $type eq 'host') {
		vLogHTML("This test is for a router implimentation.");
		exit($V6evalTool::exitRouterOnly);
	}
	else {
		vLogHTML("Unknown NUT type $type - check nut.def<br>");
		exit($V6evalTool::exitFatal);
	}
}
#-----------------------------------------------------------------
# setup() - setup test sequence
#-----------------------------------------------------------------
sub setup(;$) {	
	my($info) = @_;
	vLog("Setup");

#	if ($V6evalTool::NutDef{Type} eq 'host') {
#		if ($info ne "default_RA"){
#			sendRA("setup");
#		}else{
#			sendRA();
#		}
#	};
	
	if($info ne "no_route"){
		if ($V6evalTool::NutDef{Type} eq 'router') {
			$ret = set_default_route();
			if ($ret != $icmp::subPass) {
				vLogHTML('<FONT COLOR="#FF0000">*** NUT can not be initialized !! ***</FONT><BR>');
				return($subFail);
			};
		};
	};
	
	#
	# following parts(mkNCE_Link() and mkNCE_global()) are not written in 
	# IOL specificatoion.
	# TAHI original.
	#
	$ret = mkNCE_Link();
	
	if ($ret != $icmp::subPass) {
		vLogHTML('<FONT COLOR="#FF0000">*** NUT can not be initialized !! ***</FONT><BR>');
		return($subFail);
	}
	else {
		vLog("TN created the entry of TN's link-local address to Neighbor cache of NUT.");
	};
	
#this RA must not before mkNCE_Link()
	if(($V6evalTool::NutDef{Type} eq 'host') ||
		($V6evalTool::NutDef{Type} eq 'special')) {

		if ($info ne "default_RA"){
			sendRA("setup");
		}else{
			sendRA();
		}
	};


	$ret = mkNCE_Global();
	
	if ($ret != $icmp::subPass) {
		vLogHTML('<FONT COLOR="#FF0000">*** NUT can not be initialized !! ***</FONT><BR>');
		return($subFail);
	}
	else {
		vLog("TN created the entry of TN's global address to Neighbor cache of NUT.");
	};

	return($icmp::subPass);
}



sub
setup_v6LC_5_1_4_A()
{
	vLog("Test Setup");
	
	if(set_default_route() != $icmp::subPass) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'*** NUT can not be initialized !! ***</FONT><BR>');
		return($subFail);
	};

	if(mkNCE_Link() != $icmp::subPass) {
		vLogHTML('<FONT COLOR="#FF0000">'.
			'*** NUT can not be initialized !! ***</FONT><BR>');
		return($subFail);
	}

	vLog("TN created the entry of TN's link-local address ".
		"to Neighbor cache of NUT.");
	
	return($icmp::subPass);
}



#-----------------------------------------------------------------
# cleanup() - cleanup test sequence
#-----------------------------------------------------------------
sub cleanup(;$) {
	my($info) = @_;
	vLog("Cleanup");

	if($reboot_incleanup eq 'YES'){
		vLog("Remote boot NUT. ");
		$ret = vRemote("reboot.rmt",'', "timeout=$wait_rebootcmd");
		vLog("reboot.rmt returned status $ret") if $debug > 0;
	
		if ($ret > 0) {
			vLogHTML('<FONT COLOR="#FF0000">Can\'t cleanup</FONT>');
			return($subFatal);
		}

		if($sleep_after_reboot) {
			vSleep($sleep_after_reboot);
		}
#------------delete default route---------------------------------
	}else {
		if ($info ne "no_route"){
		
			if ($V6evalTool::NutDef{Type} eq 'router') {
				$ret = delete_default_route();
				if ($ret != $icmp::subPass) {
					vLogHTML('<FONT COLOR="#FF0000">Can\'t delete default route</FONT>');
					return($subFatal);
				}	
			}
		}
#-----------send NA(fake mac address was set:global)------------------
		vSend('Link0', clean_na_global);
		vSend('Link0', echo_request_global);
		vRecv('Link0', $icmp::wait_reply, 0, 0, clean_echo_reply_global);
		vSleep($icmp::wait_time_for_ns);
		for (1..$icmp::count_ns){
			vRecv('Link0', $icmp::wait_reply, 0, 0, clean_ns_global_sll);
		}
		vClear('Link0');

#-----------send RA(Router Lifetime,Prefix Life time = 0)---------
		if ($V6evalTool::NutDef{Type} eq 'host') {
			sendRA("cleanup");
		}

#-----------send NA(fake mac address was set:link-local)---------------------
		vSend('Link0', clean_na_local);
		vSend('Link0', echo_request_link_local);
		vRecv('Link0', $icmp::wait_reply, 0, 0, clean_echo_reply_link_local);
		vSleep($icmp::wait_time_for_ns);
		for (1..$icmp::count_ns){
			vRecv('Link0', $icmp::wait_reply, 0, 0, clean_ns_local_sll);
		}
		vClear('Link0');
	}
}
