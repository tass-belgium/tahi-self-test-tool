#!/usr/bin/perl
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
# $TAHI: ct/addr.p2/config.pl,v 1.3 2010/03/26 05:00:33 akisada Exp $
#
########################################################################

#----------------------------------------------------------------------#
#                                                                      #
# test condition                                                       #
#                                                                      #
#----------------------------------------------------------------------#

#
# time between DAD NS and DAD NA
#
#     default: 5[sec]
#
$wait_dadna				= 5;

#
# time between NS and solicited NA 
#
#     default: 5[sec]
#
$wait_solna				= 5;



#----------------------------------------------------------------------#
#                                                                      #
# implementation depend condition                                      #
#                                                                      #
#----------------------------------------------------------------------#

#
# time between receiving DAD for LLA and receiving RS  
#
#     default: 5[sec]
#
$wait_rs				= 5;

#
# time to reboot
#
#     default: 130[sec]
#
# *set a little bit longer time than actural time to reboot
#
$wait_dadns{'reboot'}	= 130;

#
# time to wait for DAD NS for global address after receiving RA
#
#     default: 5[sec]
#
# *set a little bit longer time than actural
#
# *for IPv6 Ready Logo Phase-1 "reboot" and "ra" are enough time to
#  reboot
#
$wait_dadns{'ra'}		= 5;

#
# NUT Variable: DupAddrDetectTransmits How many times the target sends
# DAD NS packets
#
#     default: 1[time]
#
# *If the target performs DAD for LLA and does not perform DAD for GA or
#  SLA do NOT set this value as "0" set "$DADTransmitsGA" as "NO"
#
$DupAddrDetectTransmits	= 1;

#
# NUT Variable: DupAddrDetectTransmits for GA and SLA
#
#     default: ANY
#
# If the target perform DAD for GA or SLA, set "YES"
#
# If the target DOES NOT perform DAD for GA or SLA, set "NO"
#
# If you don't care whether the target perform DAD for GA or SLA, set
# "ANY"
#
# *for IPv6 Ready Logo Phase-1, use "ANY"
#
$DADTransmitsGA			= "ANY";

#
# NUT Variable: RetransTimer/1000 [sec]
# The time between retransmission of NS
#
#     defatul: 1[sec]
#
$RetransTimerSec		= 1;

#
# maximum waiting time for putting reboot command to NUT
#
# *if you specify SystemType as manual in nut.def, you DO NOT NEED to
#  care about this.
#
#     default: 120[sec]
#
$wait_rebootcmd			= 120;

#
# time to actually address assigment after ending DAD
#
#     default: 5[sec]
#
$wait_addrconf_base		= 5;

#
# Specify if the target machine configure its link-local address
# automatically
#
# specify "YES" or "NO"
#
#     default: YES
#
$lla_autoconf			= "YES";



1;
