use strict;
use Test::More;
use Test::More::UTF8;

use Date::Japanese::Era;

use utf8;
my @passes = (
    [ '明治', 1,  9,  8 ],
    [ '明治', 45, 7,  29 ],
    [ '大正', 1,  7,  30 ],
    [ '大正', 14, 12, 24 ],
    [ '昭和', 1,  12, 25 ],
    [ '昭和', 64, 1,  7 ],
    [ '平成', 1,  1,  8 ],
    [ '平成', 31, 4,  30 ],
    [ '令和', 1,  5,  1 ],
);

for my $test (@passes) {
    my $e = Date::Japanese::Era->new(@$test);
    is $e->isa('Date::Japanese::Era'), 1, 'pass';
}

# must fail strictly
my @fails = (
    [ '大正', 1,  7,  29 ],
    [ '明治', 45, 7,  30 ],
    [ '昭和', 1,  12, 24 ],
    [ '大正', 15, 12, 25 ],
    [ '平成', 1,  1,  7 ],
    [ '昭和', 64, 1,  8 ],
    [ '令和', 1,  4,  30 ],
    [ '平成', 31, 5,  1 ],
);

for my $test (@fails) {
    eval { Date::Japanese::Era->new(@$test) };
    like $@, qr/^Invalid combination of era and ymd:/, 'to be strictly, it must fail';
}

note "if allowExceed eq '平成'";

my $pass = pop @fails;
for my $test (@fails) {
    eval { Date::Japanese::Era->new( @$test, { allowExceed => '平成' } ) };
    like $@, qr/^Invalid combination of era and ymd:/, 'fail';
}

my $e = Date::Japanese::Era->new( @$pass, { allowExceed => '平成' } );
is $e->name(), '令和', 'pass';
is $e->year(), 1,        'pass';

$e = Date::Japanese::Era->new( '平成', 32, { allowExceed => '平成' } );
is $e->name(), '令和', 'convert to "令和" automatically';
is $e->year(), 2,        'convert to "令和" automatically';

done_testing;
