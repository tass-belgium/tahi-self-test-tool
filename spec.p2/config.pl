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
# $TAHI: ct/spec.p2/config.pl,v 1.4 2010/03/26 05:00:34 akisada Exp $
#
########################################################################

#----------------------------------------------------------------------#
#                                                                      #
# setup                                                                #
#                                                                      #
#----------------------------------------------------------------------#

#
# wait time for DADNS respond to RA.
#
#     default: 5[sec]
#
$wait_dadns			= 5;	

#
# wait time for transmit packet
# after received DADNS.
#
#     default: 5[sec]
#
$wait_after_dadns	= 5;



#----------------------------------------------------------------------#
#                                                                      #
# main                                                                 #
#                                                                      #
#----------------------------------------------------------------------#

#
# wait time for echo_reply, icmp_err, ...
#
#     default: 5[sec]
#
$wait_reply			= 5;

#
# wait time for ICMP Time Exceeded, for Fragmentation test.
#
#     default: 65[sec]
#
$exceed_max			= 65;	

#
# accept ICMP Time Exceed if this time passed after receiving 1st
# fragment.
#
#     default: 55[sec]
#
$exceed_min			= 55;



#----------------------------------------------------------------------#
#                                                                      #
# cleanup                                                              #
#                                                                      #
#----------------------------------------------------------------------#

#
# Common Cleanup Procedure.
# Available actions are:
#     normal: (UNTER CONSTRUCTION)
#         (1) send RA with Router/Prefix Life Time set to zero.
#         (2) send NA with SLL containing a different cached address.
#         (3) Transmit Echo Request. (never respond to NS)
#     reboot:
#         (1) reboot target.
#         (2) sleep $sleep_after_reboot
#     nothing:
#         do nothing. (only sleep $cleanup_interval)
#
$cleanup			= "normal";

#
# wait for Target Neighbor Node Cache state transit to INCOMPLETE.
#
#     default: 10[sec]
#
#     note: this is only used in cleanup "normal".
#         DELAY_FIRST_PROBE_TIME = 5 [sec],
#         RETRANS_TIMER = 1,000[msec],
#         MAX_UNICAST_SOLICIT = 3,
#         5 + 1.000 * 3 = 8[sec]
#
$wait_incomplete	= 10;

#
# maximum waiting time for putting reboot command to NUT
#
# *if you specify SystemType as manual in nut.def, you DO NOT NEED to
#  care about this.
#
#     default: 300[sec])
#
$wait_rebootcmd		= 300;

#
# sleep time after reboot.
#
#     default: 10[sec]
#
#     note: this is used not only in cleanup, but also in
#           Initialization(v6LC.1.0.0)
#
$sleep_after_reboot	= 10;

#
# sleep time in cleanup "nothing" procedure.
#
#     default: 5[sec]
#
$cleanup_interval	= 5;



1;
