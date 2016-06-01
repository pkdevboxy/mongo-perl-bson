#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
BEGIN { $ENV{PERL_BSON_BACKEND} = undef }
BEGIN { $INC{"BSON/XS.pm"} = undef }
use BSON;

my $ts = BSON::Timestamp->new(0x1234, 0x5678);
isa_ok( $ts, 'BSON::Timestamp' );
is( $ts->seconds, 0x1234 );
is( $ts->increment, 0x5678 );
is( $ts->seconds(0x4321), 0x4321 );
is( $ts->increment(0x8765), 0x8765 );
