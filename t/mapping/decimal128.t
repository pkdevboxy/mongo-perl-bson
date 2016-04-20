use 5.008001;
use strict;
use warnings;

use Test::More 0.96;

use lib 't/lib';
use TestUtils;

use BSON qw/encode decode/;
use BSON::Types ':all';

use JSON::MaybeXS;

my ($hash);

# test constructor
is( bson_decimal128()->value, "0", "empty bson_decimal128() is 0" );
is( BSON::Decimal128->new->value, "0", "empty constructor is 0" );

# test overloading
is( bson_decimal128("3.14159"), "3.14159", "overloading correct" );

# BSON::Decimal128 -> BSON::Decimal128
$hash = decode( encode( { A => bson_decimal128("3.14159") } ) );
is( ref( $hash->{A} ), 'BSON::Decimal128', "BSON::Decimal128->BSON::Decimal128" );
is( $hash->{A}->value, "3.14159", "value correct" );

# test special decimal128s
for my $s ( qw/Inf -Inf NaN/ ) {
    $hash = decode( encode( { A => bson_decimal128($s) } ) );
    is( $hash->{A}->value, $s, "$s value correct" );
}

# to JSON
is( to_myjson( { a => bson_decimal128("0.0") } ),
    q[{"a":"0.0"}], 'bson_decimal128(0.0)' );
is( to_myjson( { a => bson_decimal128("42") } ),
    q[{"a":"42"}], 'bson_decimal128(42)' );
is( to_myjson( { a => bson_decimal128("0.1") } ),
    q[{"a":"0.1"}], 'bson_decimal128(0.1)' );

# to extended JSON
is(
    to_extjson( { a => bson_decimal128("0.0") } ),
    q[{"a":{"$numberDecimal":"0.0"}}],
    'bson_decimal128(0.0)'
);

is(
    to_extjson( { a => bson_decimal128("12345678E+678") } ),
    q[{"a":{"$numberDecimal":"12345678E+678"}}],
    'bson_decimal128(12345678E+678)'
);

done_testing;

# COPYRIGHT
#
# vim: set ts=4 sts=4 sw=4 et tw=75: