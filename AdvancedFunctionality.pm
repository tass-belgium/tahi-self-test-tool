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
# $TAHI: ct/AdvancedFunctionality.pm,v 1.4 2010/03/24 11:00:17 akisada Exp $
#
########################################################################

package AdvancedFunctionality;

use Exporter;
use File::Basename;
use V6evalTool;

BEGIN {}
END   {}

@ISA = qw(Exporter);

@EXPORT = qw(
	$HAS_MULTIPLE_INTERFACES
	$MTU_CONFIGURATION
	$MULTICAST_ROUTING
	$TRANSMITTING_EREQ
);

$HAS_MULTIPLE_INTERFACES	= 0;
$MTU_CONFIGURATION	= 0;
$MULTICAST_ROUTING	= 0;
$TRANSMITTING_EREQ	= 0;

sub read_configuration($$);
sub overwrite_config_pm($);

my %values = (
	'TRANSMITTING_EREQ'		=> '0',
	'MULTICAST_ROUTING'		=> '0',
	'MTU_CONFIGURATION'		=> '0',
	'HAS_MULTIPLE_INTERFACES'	=> '0',
);

my $configuration	= dirname(__FILE__).'/config.txt';
my $opt_packet	= dirname(__FILE__).'/config.def';
my @keys	= sort(keys(%values));

my $prog = basename($0);
my $strerror = '';
my $true	= 1;
my $false	= 0;
my $opt_compare	= 0;

require '../config.pl';

unless(defined($TRANSMITTING_EREQ)) {
	$TRANSMITTING_EREQ	= 0;
}

unless(defined($MULTICAST_ROUTING)) {
	$MULTICAST_ROUTING	= 0;
}

unless(defined($MTU_CONFIGURATION)) {
	$MTU_CONFIGURATION	= 0;
}

unless(defined($HAS_MULTIPLE_INTERFACES)) {
	$HAS_MULTIPLE_INTERFACES	= 0;
}

$values{'TRANSMITTING_EREQ'}	= $TRANSMITTING_EREQ;
$values{'MULTICAST_ROUTING'}	= $MULTICAST_ROUTING;
$values{'MTU_CONFIGURATION'}	= $MTU_CONFIGURATION;
$values{'HAS_MULTIPLE_INTERFACES'}	= $HAS_MULTIPLE_INTERFACES;

unless(overwrite_config_def(\@keys)) {
	print(STDERR "$prog: $strerror\n");
	exit(-1);
	# NOTREACHED
}

vCPP();



#--------------------------------------------------------------#
# overwrite_config_def()                                       #
#--------------------------------------------------------------#
sub
overwrite_config_def($)
{
	my ($keys) = @_;

	local(*OUTPUT);

	unless(open(OUTPUT, "> $opt_packet")) {
		$strerror = "open: $opt_packet: $!";
		return($false);
	}

	print(OUTPUT "#ifndef HAVE_CONFIG_DEF\n");
	print(OUTPUT "#define HAVE_CONFIG_DEF\n");

	foreach my $key (@$keys) {
		print(OUTPUT "\n");
		print(OUTPUT "#ifndef $key\n");
		print(OUTPUT "#define $key\t$values{$key}\n");
		print(OUTPUT "#endif\t// $key\n");
	}

	print(OUTPUT "#endif\t// HAVE_CONFIG_DEF\n");

	close(OUTPUT);

	return($true);
}

1;
