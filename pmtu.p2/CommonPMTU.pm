#
# $Name: V6LC_5_0_0 $
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
# Perl Module for Path MTU Conformance Test
#
# $Id: CommonPMTU.pm,v 1.9 2006/01/18 13:33:07 akisada Exp $
#

package CommonPMTU;

use Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
	pmtuReboot
	nd_vRecv_EN
	all_vRecv
	writefragdef
	writefragdef_req
	setup11
	setup11alt
	setup11_v6LC_4_1_2
	cleanup
	cleanupalt
	%pktdesc
	);

use V6evalTool;
require './config.pl';

$Success = 0;		# subroutine exit status
$Failure = 1;

@fragment_1st_name = ();   #fragment paket definition
@req_fragment_1st_name = ();   #fragment paket definition

%pktdesc = (
	#--- CommonHost/Router
	'ns_l2l'	=> 'Recv Neighbor Solicitation (Link-Local to Link-Local)',
	'ns_g2l'	=> 'Recv Neighbor Solicitation (Global to Link-Local)',
	'ns_l2g'	=> 'Recv Neighbor Solicitation (Link-Local to Global)',
	'ns_g2g'	=> 'Recv Neighbor Solicitation (Global to Global)',
	'u_ns_l2l'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Link-Local)',
	'u_ns_l2l_wo'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Link-Local, without SLL)',
	'u_ns_g2l'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local)',
	'u_ns_g2l_wo'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local, without SLL)',
	'u_ns_l2g'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global)',
	'u_ns_l2g_wo'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global, without SLL)',
	'u_ns_g2g'	=> 'Recv Unicast Neighbor Solicitation (Global to Global)',
	'u_ns_g2g_wo'	=> 'Recv Unicast Neighbor Solicitation (Global to Global, without SLL)',
	'na_l2l'	=> 'Send Neighbor Advertisement (Link-Local to Link-Local)',
	'na_l2g'	=> 'Send Neighbor Advertisement (Link-Local to Global)',
	'na_g2l'	=> 'Send Neighbor Advertisement (Global to Link-Local)',
	'na_g2g'	=> 'Send Neighbor Advertisement (Global to Global)',

	#--- CommonRouter
	'ns_g2l_link1'		=> 'Recv Neighbor Solicitation (Global to Link-Local)',
	'u_ns_g2l_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local)',
	'u_ns_g2l_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Link-Local, without SLL)',
	'ns_l2g_link1'		=> 'Recv Neighbor Solicitation (Link-Local to Global)',
	'u_ns_l2g_link1'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global)',
	'u_ns_l2g_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Link-Local to Global, without SLL)',
	'ns_g2g_link1'		=> 'Recv Neighbor Solicitation (Global to Global)',
	'u_ns_g2g_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Global)',
	'u_ns_g2g_wo_link1'	=> 'Recv Unicast Neighbor Solicitation (Global to Global, without SLL)',

	'na_l2l_link1'		=> 'Send Neighbor Advertisement (Link-Local to Link-Local)',
	'na_l2g_link1'		=> 'Send Neighbor Advertisement (Link-Local to Global)',
	'na_g2l_link1'		=> 'Send Neighbor Advertisement (Global to Link-Local)',
	'na_g2g_link1'		=> 'Send Neighbor Advertisement (Global to Global)',

	#--- Setup for Host
	'setup_ra'		=> 'Send Router Advertisement',
	'setup_ra_rltime_1800'	=> 'Send Router Advertisement',
	'setup_dadns'		=> 'Recv DADNS',

	#--- Setup for Host/Router
	'setup_echo_request'	=> 'Send Echo Request (Link-Local)',
	'setup_echo_reply'	=> 'Recv Echo Reply (Link-Local)',
	'setup_echo_request_g'	=> 'Send Echo Request (Global)',
	'setup_echo_reply_g'	=> 'Recv Echo Reply (Global)',

	#--- Setup for Router

	#--- Cleanup for Host
	'cleanup_ra'			=> 'Send Router Advertisement (any Lifetimes set to 0)',
	'cleanup_na'			=> 'Send Neighbor Advertisement (Link-Local Address with Different Link-layer Address)',
	'cleanup_na_g'			=> 'Send Neighbor Advertisement (Global Address with Different Link-layer Address)',
	'cleanup_echo_request'		=> 'Send Echo Request',
	'cleanup_echo_request_g'	=> 'Send Echo Request (Global)',

	#--- Cleanup for Router
	'cleanup_na_1'			=> 'Send Neighbor Advertisement (Link-Local Address with Different Link-layer Address)',
	'cleanup_na_g_1'		=> 'Send Neighbor Advertisement (Global Address with Different Link-layer Address)',
	'cleanup_echo_request_1'	=> 'Send Echo Request',
	'cleanup_echo_request_g_1'	=> 'Send Echo Request (Global)',
);

#--- NS/NA correspondence
%nd = (
	'Link0' => {
		'ns_l2l'	=> 'na_l2l',
		'ns_g2l'	=> 'na_l2g',
		'ns_l2g'	=> 'na_g2l',
		'ns_g2g'	=> 'na_g2g',
		'u_ns_l2l'	=> 'na_l2l',
		'u_ns_l2l_wo'	=> 'na_l2l',
		'u_ns_g2l'	=> 'na_l2g',
		'u_ns_g2l_wo'	=> 'na_l2g',
		'u_ns_l2g'	=> 'na_g2l',
		'u_ns_l2g_wo'	=> 'na_g2l',
		'u_ns_g2g'	=> 'na_g2g',
		'u_ns_g2g_wo'	=> 'na_g2g',
	},
	'Link1' => {
		'ns_l2l'		=> 'na_l2l_link1',
		'ns_g2l_link1'		=> 'na_l2g_link1',
		'ns_l2g_link1'		=> 'na_g2l_link1',
		'ns_g2g_link1'		=> 'na_g2g_link1',
		'u_ns_l2l'		=> 'na_l2l_link1',
		'u_ns_l2l_wo'		=> 'na_l2l_link1',
		'u_ns_g2l_link1'	=> 'na_l2g_link1',
		'u_ns_g2l_wo_link1'	=> 'na_l2g_link1',
		'u_ns_l2g_link1'	=> 'na_g2l_link1',
		'u_ns_l2g_wo_link1'	=> 'na_g2l_link1',
		'u_ns_g2g_link1'	=> 'na_g2g_link1',
		'u_ns_g2g_wo_link1'	=> 'na_g2g_link1',
	},
);


$remote_debug = '';
$routeSet = 0;
$useRA = 0;


#===============================================================
# pmtuReboot() - reboot target
#===============================================================
# argument:
#    nothing
# return:
#    Success / Failure
#===============================================================
sub pmtuReboot {
	my ($ret);

	vLogHTML('Target: Reboot<BR>');
	$ret = vRemote('reboot.rmt', $remote_debug, "timeout=$wait_rebootcmd");

	if ($ret == 0) {
		return ($Success);
	} else {
		return ($Failure);
	}
}


#===============================================================
# %ret = nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
#			- waiting for expecting packets for End Node
#===============================================================
# argument:
#    LinkN: interface name ('Link0' or 'Link1')
#    timeout: time to stop waiting [sec.]
#    seektime: time to start waiting [sec.]
#    count: number of receiving packets
#    frame(list): expecting packet names
# return:
#    ret(hash):
#	status    - status(0: catch expected packets
#			   1: time exceeded
#			   2: count exceeded
#			 > 3: error)
#	recvCount - number of received packets
#	recvTimeN - time of receiving packet #N 
#	recvFrame - name of received packet(expected)
#===============================================================

sub nd_vRecv_EN {
	my($IF, $timeout, $seektime, $count, @frames) = @_;
	my(%ret, @recv);

	my %ndHash = %{$nd{$IF}};
	my @ndList = keys(%ndHash);

	while (1) {
		%ret = vRecv3($IF, $timeout, $seektime, $count, @ndList, @frames);

		if ($ret{'status'} == 0) {
			@recv = grep {$ret{'recvFrame'} eq $_} @ndList;
			if ($recv[0]) {
				vSend($IF, $ndHash{$recv[0]});
				next;
			}

			@recv = grep {$ret{'recvFrame'} eq $_} @frames;
			if ($recv[0]) {
				last;
			}
		} else {
			last;
		}
	}

	return (%ret);
}


#===============================================================
# all_vRecv(LinkN, timeout, frame...)
#			- repeating waiting for expecting packets
#===============================================================
# argument:
#    LinkN: interface name ('Link0' or 'Link1')
#    timeout: every time of waiting [sec.]
#    frame(list): expecting packet names
# return:
#    ($ret, @received)
#    ret:
#	$Success or $Failure
#    received:
#	list of not received packet names
#===============================================================
sub all_vRecv {
	my($IF, $wait_reply, @specified) = @_;
	my(%ret, $i);

	while ($#specified > -1) {
		%ret = nd_vRecv_EN($IF, $wait_reply, 0, 0, @specified);

		if ($ret{'status'} == 0) {
			vLogHTML('OK<BR>');
			for ($i = 0; $i <= $#specified; $i++) {
				if ($ret{'recvFrame'} eq $specified[$i]) {
					splice(@specified, $i, 1);
					last;
				}
			}
		} else {
			last;
		}
	}

	if ($#specified == -1) {
		return ($Success, @specified);
	} else {
		return ($Failure, @specified);
	}
}

#===============================================================
# writefragdef(file name,packet name, MTU size, packet size, 1st fragment default size,
# 2nd fragment default size, header_ether, ip_src, ip_dst)
#			- fragment paket definition(echo reply fragment)
#===============================================================
# return:
#    ($ret)
#    ret:
#	$Success or $Failure
#===============================================================
#----  fragment paket definition
sub writefragdef($$$$$$$$$){
	my ($def, $original_name, $MTU_value, $PKT_size,$data_size_1st,$data_size_2nd , $header_ether, $ip_src, $ip_dst) = @_;
	
	if(open(OUT, "> $def")) {

		@fragment_1st_name = ();
		while ( $data_size_1st  <= ($MTU_value - 40 ) && $data_size_2nd >= 0) {
			
			if ((($data_size_1st + 40 +8) <= $MTU_value) &&  ($data_size_2nd  <= ($MTU_value - 40 -8 ))){
			
				$offset = $data_size_1st/8;
				
				push( @fragment_1st_name ,"echo_reply$PKT_size" . "_1st_$data_size_1st");
				
				select(OUT);
				
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_reply$PKT_size" . "_1st_$data_size_1st,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n"; #change this
				print "        _DST( $ip_dst );\n"; #change this
				print "    },\n";
				print "    {\n";
				print "        header = _HDR_IPV6_NAME(echo_reply$PKT_size"."_1st_$data_size_1st);\n"; #change this
				print "        exthdr = frag"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "        upper = payload"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_reply$PKT_size" . "_2nd_$data_size_2nd,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n";
				print "        _DST( $ip_dst );\n"; #change this
				print "    },\n";
				print "    {\n";
				print "         header = _HDR_IPV6_NAME(echo_reply$PKT_size"."_2nd_$data_size_2nd);\n"; #change this
				print "         exthdr = frag"."$PKT_size"."_2nd_$data_size_2nd;\n"; #change this
				print "         upper = payload"."$PKT_size"."_2nd_$data_size_2nd;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_1st_$data_size_1st {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = 0;\n";
				print "    MFlag = 1;\n";
				print "    Identification = FRAG_ID;\n";
				print "}\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_2nd_$data_size_2nd {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = $offset;" . "//$data_size_1st"."/8;\n";
				print "    MFlag = 0;\n";
				print "    Identification = FRAG_ID;\n";
				print "}\n";
				
				print "\n";
				
				print "Payload payload"."$PKT_size"."_1st_$data_size_1st {\n"; #chnage this
				print "    data = substr(_PACKET_IPV6_NAME("."$original_name"."), 40, "."$data_size_1st".");\n";
				print "}\n";
				
				print "\n";
				
				print "Payload payload"."$PKT_size"."_2nd_$data_size_2nd {\n"; #chnage this
				print "    data = substr(_PACKET_IPV6_NAME("."$original_name"."), ",$data_size_1st+40,", "."$data_size_2nd".");\n";
				print "}\n";
				
				
				
				select(STDOUT);
			}
			
			$data_size_1st += 8;
			$data_size_2nd -= 8;
		}
		close(OUT);
		return($Success);
	}
	vLogHTML('<FONT COLOR="#FF0000">Can\'t open file.</FONT><BR>');
	return($Failure);
}

#===============================================================
# writefragdef_req(file name, MTU size, packet size, 1st fragment default size,
# 2nd fragment default size, header_ether, ip_src, ip_dst)
#			- fragment paket definition(echo request fragment)
#===============================================================
# return:
#    ($ret)
#    ret:
#	$Success or $Failure
#===============================================================
#----  fragment paket definition
sub writefragdef_req($$$$$$$$){
	my ($def_file, $MTU_value, $PKT_size,$data_size_1st,$data_size_2nd , $header_ether, $ip_src, $ip_dst) = @_;

	if(open(OUT, "> $def_file")) {
		
		@req_fragment_1st_name = ();
		while ( $data_size_1st  <= ($MTU_value - 40 ) && $data_size_2nd >= 0) {
			
			if ((($data_size_1st + 40 +8) <= $MTU_value) &&  ($data_size_2nd  <= ($MTU_value - 40 -8 ))){
				
				$offset = $data_size_1st/8;
				
				push( @req_fragment_1st_name ,"echo_request$PKT_size" . "_1st_$data_size_1st");
				
				select(OUT);
			
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_request$PKT_size" . "_1st_$data_size_1st,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n"; #change this
				print "        _DST( $ip_dst );\n"; #change this
				$tmp = $data_size_1st +8;
				print "        PayloadLength = $tmp;\n";
				print "    },\n";
				print "    {\n";
				print "        header = _HDR_IPV6_NAME(echo_request$PKT_size"."_1st_$data_size_1st);\n"; #change this
				print "        exthdr = frag"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "        upper = stop;\n";
#payload"."$PKT_size"."_1st_$data_size_1st;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "FEM_hdr_ipv6_exth(\n";
				print "    echo_request$PKT_size" . "_2nd_$data_size_2nd,\n"; #change this
				print "    $header_ether ,\n"; #change this _HETHER_nut2tn
				print "    {\n";
				print "        _SRC( $ip_src );\n";
				print "        _DST( $ip_dst );\n"; #change this
				$tmp = $data_size_2nd +8;
				print "        PayloadLength = $tmp;\n";
				print "    },\n";
				print "    {\n";
				print "         header = _HDR_IPV6_NAME(echo_request$PKT_size"."_2nd_$data_size_2nd);\n"; #change this
				print "         exthdr = frag"."$PKT_size"."_2nd_$data_size_2nd;\n"; #change this
				#print "         upper = payload"."$PKT_size"."_2nd_$data_size_2nd;\n";
				print "        upper = stop;\n"; #change this
				print "    }\n";
				print ")\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_1st_$data_size_1st {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = 0;\n";
				print "    MFlag = 1;\n";
				print "    Identification = any;\n";
				print "}\n";
				
				print "\n";
				
				print "Hdr_Fragment frag"."$PKT_size"."_2nd_$data_size_2nd {\n"; #change this
				print "    NextHeader = 58;\n";
				print "    FragmentOffset = $offset;" . "//$data_size_1st"."/8;\n";
				print "    MFlag = 0;\n";
				print "    Identification = any;\n";
				print "}\n";
			
				print "\n";
				
				print "Payload payload"."$PKT_size"."_1st_$data_size_1st {\n"; #chnage this
				print "    data = repeat(0x00, $data_size_1st);\n";
				print "}\n";
				
				print "\n";
				
				print "Payload payload"."$PKT_size"."_2nd_$data_size_2nd {\n"; #chnage this
				print "    data = repeat(0x00, $data_size_2nd);\n";
				print "}\n";
								
				select(STDOUT);
			}
			
			$data_size_1st += 8;
			$data_size_2nd -= 8;
		}
		close(OUT);
		return($Success);
	}
	vLogHTML('<FONT COLOR="#FF0000">Can\'t open file.</FONT><BR>');
	return($Failure);
}

#===============================================================
# setup11(Link0) - Common Test Setup 1.1
#===============================================================
sub setup11 {
	my($status);

	if ($V6evalTool::NutDef{'Type'} eq 'router') {
		$status = _setup11_Router(@_);
	} else {
		$status = _setup11_Host(@_);
	}

	return ($status);
}

#===============================================================
# setup11(Link0) - Common Test Setup 1.1
#===============================================================
sub setup11alt {
	my($status);

	if ($V6evalTool::NutDef{'Type'} eq 'router') {
		$status = _setup11_Routeralt(@_);
	} else {
		$status = _setup11_Host(@_);
	}

	return ($status);
}

sub _setup11_Host {
	my($IF) = @_;
	my(%ret);

	vLogHTML('--- start Common Test Setup 1.1 for Host<BR>');

	vSend($IF, 'setup_echo_request');
	%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			vSend($IF, 'na_l2l');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_g2l') {
			vSend($IF, 'na_l2g');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply');
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
	%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g', 'ns_g2g', 'ns_l2g');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_g2g') {
			vSend($IF, 'na_g2g');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			vSend($IF, 'na_g2l');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
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

sub _setup11_Host_v6LC_4_1_2 {
	my($IF) = @_;
	my(%ret);

	vLogHTML('--- start Common Test Setup 1.1 for Host<BR>');

	vSend($IF, 'setup_echo_request');
	%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			vSend($IF, 'na_l2l');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_g2l') {
			vSend($IF, 'na_l2g');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply');
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

	vSend($IF, 'setup_ra_rltime_1800');
	$useRA = 1;
	vRecv3($IF, $wait_dadns, 0, 0, 'setup_dadns');
	vSleep($wait_after_dadns);

	vSend($IF, 'setup_echo_request_g');
	%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g', 'ns_g2g', 'ns_l2g');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_g2g') {
			vSend($IF, 'na_g2g');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			vSend($IF, 'na_g2l');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
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

#===============================================================
# setup11_v6LC_4_1_2(Link0) - Common Test Setup 1.1
#===============================================================
sub setup11_v6LC_4_1_2 {
	my($status);

	if ($V6evalTool::NutDef{'Type'} eq 'router') {
		$status = _setup11_Router(@_);
	} else {
		$status = _setup11_Host_v6LC_4_1_2(@_);
	}

	return ($status);
}

sub _setup11_Router {
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
	%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			desc_vSend($IF, 'na_l2l');
			%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			desc_vSend($IF, 'na_g2l');
			%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply');
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


sub _setup11_Routeralt {
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
	%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply', 'ns_l2l', 'ns_g2l');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_l2l') {
			desc_vSend($IF, 'na_l2l');
			%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			desc_vSend($IF, 'na_g2l');
			%ret = desc_vRecv($IF, $wait_reply, 0, 0, 0, 'setup_echo_reply');
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

	vClear($IF);
	vSend($IF, 'setup_echo_request_g');
	%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g', 'ns_g2g', 'ns_l2g');
	if ($ret{'status'} == 0) {
		if ($ret{'recvFrame'} eq 'ns_g2g') {
			vSend($IF, 'na_g2g');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
		} elsif ($ret{'recvFrame'} eq 'ns_l2g') {
			vSend($IF, 'na_g2l');
			%ret = vRecv3($IF, $wait_reply, 0, 0, 'setup_echo_reply_g');
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


#===============================================================
# cleanup($Link0[, $Link1]) - Common Test Cleanup
#===============================================================
sub cleanup {
#	my($ret);
#
#	if ($V6evalTool::NutDef{'Type'} eq 'router') {
#		$ret = _cleanup_Router(@_);
#	} else {
#		$ret = _cleanup_Host(@_);
#	}
#
#	return ($ret);
	return(pmtuReboot());
}

sub cleanupalt {
#	my($ret);
#
#	if ($V6evalTool::NutDef{'Type'} eq 'router') {
#		$ret = _cleanup_Routeralt(@_);
#	} else {
#		$ret = _cleanup_Host(@_);
#	}
#
#	return ($ret);
	return(pmtuReboot());
}

sub _cleanup_Host {
	my($IF) = @_;
	my($ret);

	vLogHTML('--- Cleanup NUT<BR>');

	if ($cleanup eq 'normal') {
		if ($useRA == 1) {	# use Global Address
			vSend($IF, 'cleanup_na_g');
			vSend($IF, 'cleanup_echo_request_g');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF, $wait_incomplete, 0, 0);
			vSend($IF, 'cleanup_ra');
			$useRA = 0;
		}

		vSend($IF, 'cleanup_na');
		vSend($IF, 'cleanup_echo_request');
		vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
		vRecv3($IF, $wait_incomplete, 0, 0);
		$ret = $Success;
	} elsif ($cleanup eq 'reboot') {
		$ret = specReboot();
		vSleep($sleep_after_reboot);
		if ($ret) {
			$ret = $Failure;
		} else {
			$ret = $Success;
		}
	} elsif ($cleanup eq 'nothing') {
		vSleep($cleanup_interval);
		$ret = $Success;
	} else {
		vLogHTML("unrecognized cleanup keyword ``$cleanup'' in config.pl<BR>");
		$ret = $Failure;
	}

	return ($ret);
}

sub _cleanup_Router {
	my($IF0, $IF1) = @_;
	my($ret, $tnaddr, $nutdev);

	vLogHTML('--- Cleanup RUT<BR>');

	if ($cleanup eq 'normal') {
		vClear($IF0);
		desc_vSend($IF0, 'cleanup_na');
		desc_vSend($IF0, 'cleanup_echo_request');
		vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
		vRecv3($IF0, $wait_incomplete, 0, 0);

		if ($IF1) {
			# many tests which unused Link1 is not needed
			# to cleanup Global address on Link0 also.
			desc_vSend($IF0, 'cleanup_na_g');
			desc_vSend($IF0, 'cleanup_echo_request_g');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF0, $wait_incomplete, 0, 0);

			vClear($IF1);
			desc_vSend($IF1, 'cleanup_na_1');
			desc_vSend($IF1, 'cleanup_echo_request_1');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF1, $wait_incomplete, 0, 0);

			desc_vSend($IF1, 'cleanup_na_g_1');
			desc_vSend($IF1, 'cleanup_echo_request_g_1');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF1, $wait_incomplete, 0, 0);
		}

		$ret = cleanup_deleteRoute();
	} elsif ($cleanup eq 'reboot') {
		$ret = specReboot();
		vSleep($sleep_after_reboot);
		if ($ret) {
			$ret = $Failure;
		} else {
			$ret = $Success;
		}
	} elsif ($cleanup eq 'nothing') {
		$ret = cleanup_deleteRoute();
		vSleep($cleanup_interval);
	}

	return ($ret);
}


sub _cleanup_Routeralt {
	my($IF0, $IF1) = @_;
	my($ret, $tnaddr, $nutdev);

	vLogHTML('--- Cleanup RUT<BR>');

	if ($cleanup eq 'normal') {
		vClear($IF0);
		vSend($IF0, 'cleanup_na_g');
		vSend($IF0, 'cleanup_echo_request_g');
		vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
		vRecv3($IF0, $wait_incomplete, 0, 0);

		vClear($IF0);
		desc_vSend($IF0, 'cleanup_na');
		desc_vSend($IF0, 'cleanup_echo_request');
		vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
		vRecv3($IF0, $wait_incomplete, 0, 0);

		if ($IF1) {
			# many tests which unused Link1 is not needed
			# to cleanup Global address on Link0 also.
			desc_vSend($IF0, 'cleanup_na_g');
			desc_vSend($IF0, 'cleanup_echo_request_g');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF0, $wait_incomplete, 0, 0);

			vClear($IF1);
			desc_vSend($IF1, 'cleanup_na_1');
			desc_vSend($IF1, 'cleanup_echo_request_1');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF1, $wait_incomplete, 0, 0);

			desc_vSend($IF1, 'cleanup_na_g_1');
			desc_vSend($IF1, 'cleanup_echo_request_g_1');
			vLogHTML("Wait for transit target Neighbor Cache Entry to INCOMPLETE/NONCE ($wait_incomplete sec.)<BR>");
			vRecv3($IF1, $wait_incomplete, 0, 0);
		}

		$ret = cleanup_deleteRoute();
	} elsif ($cleanup eq 'reboot') {
		$ret = specReboot();
		vSleep($sleep_after_reboot);
		if ($ret) {
			$ret = $Failure;
		} else {
			$ret = $Success;
		}
	} elsif ($cleanup eq 'nothing') {
		$ret = cleanup_deleteRoute();
		vSleep($cleanup_interval);
	}

	return ($ret);
}


sub cleanup_deleteRoute {
	my($ret, $tnaddr, $nutdev);

	$ret = $Success;

	if ($routeSet == 0) {
		return ($ret);
	}

	# $routeSet == 1
	$tnaddr = vMAC2LLAddr($V6evalTool::TnDef{'Link0_addr'});
	$nutdev = $V6evalTool::NutDef{'Link0_device'};

	$ret = vRemote('route.rmt',	'cmd=delete ' .
					'prefix=default ' .
					"gateway=$tnaddr " .
					"if=$nutdev");
	if ($ret) {
		vLogHTML('<font color="#ff0000">Cannot delete default router</font><br>');
		$ret = $Failure;
	} else {
		# $ret = $Success;	# unchanged
	}

	return ($ret);
}


# temporarily add packet description " from/to LinkN"
sub desc_vSend {
	my($IF, $frame) = @_;
	my($tmpdesc, $ret);

	$tmpdesc = $pktdesc{$frame};
	$pktdesc{$frame} .= " to $IF";
	$ret = vSend($IF, $frame);
	$pktdesc{$frame} = $tmpdesc;

	return ($ret);
}

# $offset means: add "from LinkN" to description for $frames[$offset ..]
sub desc_vRecv {
	my($IF, $timeout, $seektime, $count, $offset, @frames) = @_;
	my(%ret, %tmpdesc, $key);

	%tmpdesc = ();
	foreach $key ((@frames)[$offset .. $#frames]) {
		$tmpdesc{$key} = $pktdesc{$key};
		$pktdesc{$key} .= " from $IF";
	}
	%ret = vRecv3($IF, $timeout, $seektime, $count, @frames);
	foreach $key ((@frames)[$offset .. $#frames]) {
		$pktdesc{$key} = $tmpdesc{$key};
	}

	return (%ret);
}


1;


__END__
################################################################

=head1 NAME

  CommonPMTU.pm - Common Test Setup, Cleanup, and other procedures

=head1 SYNOPSIS

  pmtuReboot()
  nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
  setup11(Link0)
  cleanup([Link0[, Link1]])

=head1 DESCRIPTION

  pmtuReboot() - Reboot Target

    argument:
       nothing

    return:
       Success / Failure code

    This subroutine simply calls vRemote("reboot.rmt").

  nd_vRecv_EN(LinkN, timeout, seektime, count, frame...)
			- waiting for expecting packets for End Node

    argument:
       LinkN: interface name ('Link0' or 'Link1')
       timeout: time to stop waiting [sec.]
       seektime: time to start waiting [sec.]
       count: number of receiving packets
       frame(list): expecting packet names

    return:
       ret(hash):
           status    - status(0: catch expected packets
                              1: time exceeded
                              2: count exceeded
                            > 3: error)
           recvCount - number of received packets
           recvTimeN - time of receiving packet #N 
           recvFrame - name of received packet(expected)

    This is a wrapper for vRecv() which replies appropriate
    Neighbor Advertisement automatically when it receives
    any Neighbor Solicitation.
    Then it waits the specified packets again (no NS in this time).

  setup11(Link0) - Common Test Setup 1.1

    Arranges the least setup which enables NUT to communicate with TN.
    Add TN to NUT's default router, and Neighbor Cache Entry status
    set to REACHABLE.

    [case: NUT is a host]
    First, TN transmits an Echo Request to NUT. The Source Address is
    TN's Link-Local Address (LLA), and the Destination Address is
    NUT's LLA. NUT responds Echo Reply. This causes NUT's Neighbor
    Cache Entry (NCE) for TN's LLA with the state of REACHABLE.

    Second, TN transmits a Router Advertisement with a global prefix,
    L flag, and A flag set. This causes the NUT to add TN to its
    Default Router List, configure a global address, and compute
    Reachable Time.

    Third, TN Transmits an Echo Request to NUT. The Source Address is
    TN's Global Address (GA), and the Destination Address is NUT's GA.
    NUT responds Echo Reply. This causes NUT's NCE for TN's GA with
    the state of REACHABLE also.

    [case: NUT is a router]
    First, configure NUT's default router to TN's LLA.

    Second, TN transmits an Echo Request to NUT. The Source Address is
    TN's Link-Local Address (LLA), and the Destination Address is
    NUT's LLA. NUT responds Echo Reply. This causes NUT's NCE for
    TN's LLA with the state of REACHABLE.

  cleanup([$Link0[, $Link1]]) - Common Test Cleanup

    This procedure deletes the Neighbor Cache Entries from the NUT.
    Available actions (in config.pl) are as follows:

      1. Delete Default Router List and Neighbor Cache Entry (Needs Link0/1)

          If NUT is Host and unused Common Test Setup 1.1, or
          NUT is Router and unused Common Test Setup 1.2,
          TN transmits Neighbor Advertisement (NA) with TN's Link-Local
          Address (LLA) and a Link-Layer Address different from Cached one.

          After that, TN transmits Echo Request to NUT and ignores
          all responces and Neighbor Solicitations (NS). This causes
          NUT's Neighbor Cache Entry (NCE) for TN's LLA with the state
          of INCOMPLETE/NONCE.

          Finally, If TN is Router and used Common Test Setup 1.1,
          delete TN's LLA from NUT's Default Router List.

          If NUT is Host and used Common Test Setup 1.1,
          TN transmits NA with TN's Global Address (GA) and a different
          Link-Layer Address. Ignores all responces and NSs.

          Next, TN transmits Router Advertisement with Router Lifetime
          and Prefix Lifetime 0.

          Next, TN transmits NA with TN's LLA and a different Link-Layer
          Address. Ignores all responces and NSs.

          If NUT is Router and used Common Test Setup 1.2,
          NUT's NCEs set to INCOMPLETE/NONCE on Link0 and Link1
          and delete Default Router Lists.

      2. Reboot

      3. Do nothing (only sleep short time)

=head1 SEE ALSO

  perldoc V6evalTool

=cut
