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
# $TAHI: ct/icmp.p2/config.pl,v 1.3 2010/03/26 05:00:33 akisada Exp $
#
########################################################################

#
# Time to wait for reply of packet from NUT to packet which TN sent.
# echo reply , icmp error message...
# echo request from NUT to TN is also contained
#
#     default: 5[sec]
#
$wait_reply			= 5;

#
# The maximun time to wait for fragment reassembly time exceeded message
#
#     default: 65[sec]
#
$wait_time_exc		= 65;

#
# whether to reboot in cleanup() function
#
# YES: reboot
# NO: not reboot
#
#     default: NO
#
$reboot_incleanup	= "NO";

#
# maximum waiting time for putting reboot command to NUT
#
# *if you specify SystemType as manual in nut.def, you DO NOT NEED to
#  care about this.
#
#     default: 300[sec]
#
$wait_rebootcmd		= 300;

#
# sleep time after reboot.
#
#     default: 0[sec]
#
$sleep_after_reboot	= 0;



#----------------------------------------------------------------------#
#                                                                      #
# for clean up                                                         #
#                                                                      #
#----------------------------------------------------------------------#

#
# This time use in cleanup() function.
# This parameter shows time after transmitting na until TN receives ns N
# times.
#
#     default: 10
#
$wait_time_for_ns	= 10;

#
# This count use in cleanup() function.
# This parameter shows number of times which receives NS. 
#
#     default: 3
#
$count_ns			= 3;



1;
