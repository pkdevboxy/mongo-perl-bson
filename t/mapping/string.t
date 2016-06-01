use 5.008001;
use strict;
use warnings;
use utf8;

use Test::More 0.96;
BEGIN { $ENV{PERL_BSON_BACKEND} = undef }
BEGIN { $INC{"BSON/XS.pm"} = undef }

binmode( Test::More->builder->$_, ":utf8" )
  for qw/output failure_output todo_output/;

use lib 't/lib';
use TestUtils;

use BSON qw/encode decode/;
use BSON::Types qw/bson_string/;

my ($hash);

# test constructor
is( bson_string(), '', "empty bson_string() is ''" );
is( BSON::String->new, '', "empty constructor is ''" );

# test overloading
is( bson_string('héllo wörld'), 'héllo wörld', "string overload" );

# string -> string
$hash = decode( encode( { A => 'héllo wörld' } ) );
is( sv_type( $hash->{A} ), 'PV', "string->string" );
is( $hash->{A}, 'héllo wörld', "value correct" );

# BSON::String -> string
$hash = decode( encode( { A => bson_string('héllo wörld') } ) );
is( sv_type( $hash->{A} ), 'PV', "BSON::String->string" );
is( $hash->{A}, 'héllo wörld', "value correct" );

# MongoDB::BSON::String -> string
my $str = 'héllo wörld';
$hash = decode( encode( { A => bless \$str, "MongoDB::BSON::String" } ) );
is( sv_type( $hash->{A} ), 'PV', "MongoDB::BSON::String->string" );
is( $hash->{A}, 'héllo wörld', "value correct" );

# string -> BSON::String
$hash = decode( encode( { A => 'héllo wörld' } ), wrap_strings => 1 );
is( ref( $hash->{A} ), 'BSON::String', "string->BSON::String" );
is( $hash->{A}->value, 'héllo wörld', "value correct" );

# BSON::String -> BSON::String
$hash = decode( encode( { A => bson_string('héllo wörld') } ), wrap_strings => 1 );
is( ref( $hash->{A} ), 'BSON::String', "BSON::String->BSON::String" );
is( $hash->{A}->value, 'héllo wörld', "value correct" );

# MongoDB::BSON::String -> BSON::String
$hash = decode( encode( { A => bless \$str, "MongoDB::BSON::String" } ), wrap_strings => 1 );
is( ref( $hash->{A} ), 'BSON::String', "MongoDB::BSON::String->BSON::String" );
is( $hash->{A}->value, 'héllo wörld', "value correct" );

done_testing;

# COPYRIGHT
#
# vim: set ts=4 sts=4 sw=4 et tw=75:
