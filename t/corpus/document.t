use 5.008001;
use strict;
use warnings;

use Test::More 0.96;
BEGIN { $ENV{PERL_BSON_BACKEND} = "" }
BEGIN { $INC{"BSON/XS.pm"} = undef }
use Path::Tiny;

use lib 't/lib';
use CorpusTest;

test_corpus_file( path($0)->basename(".t") . ".json" );

done_testing;

# COPYRIGHT
#
# vim: set ts=4 sts=4 sw=4 et tw=75:
