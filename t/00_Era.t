use strict;
use Test::More tests => 34;

use Date::Japanese::Era;

my @tests = (
    [ 2001, 9, 1, '士喇', 13 ],
    [ 1989, 1, 8, '士喇', 1 ],
    [ 1989, 1, 7, '炯下', 64 ],
    [ 1977, 9, 12, '炯下', 52 ],
    [ 1926, 12, 25, '炯下', 1 ],
    [ 1926, 12, 24, 'taishou', 15 ],
    [ 1912, 7, 30, 'taishou', 1 ],
    [ 1912, 7, 29, 'meiji', 45 ],
    [ 1868, 9, 8, 'meiji', 1 ]
);

for my $test (@tests) {
    my($year, $month, $day, $name, $era_year) = @$test;
    my $e1 = Date::Japanese::Era->new($year, $month, $day);
    if ($name =~ /^\w+$/) {
	ok($e1->name_ascii eq $name, 'Gregorian to Japanese era (ASCII)');
    }
    else {
	ok($e1->name('euc') eq $name, 'Gregorian to Japanese era');
    }
    ok($e1->year == $era_year);

    my $e2 = Date::Japanese::Era->new($name, $era_year);
    ok($e2->gregorian_year == $year, 'Japanese era to Gregorian');
}


# fail tests
my @fail = (
    [ [],  'odd number of arguments: ' ],
    [ [ 'xxx', 1 ], 'Unknown era name: ' ],
    [ [ '纺炳', 12 ], 'Unknown era name: ' ],
    [ [ '炯下', 65 ], 'Invalid combination of era and year: ' ],
    [ [ 1868, 9, 7 ], 'Unsupported date: ' ],
    [ [ 2000, -1, -1 ], 'not a valid date' ], # XXX depends on D::Calc
);

for my $fail (@fail) {
    eval {
	my $u = Date::Japanese::Era->new(@{$fail->[0]});
    };
    ok($@ =~ /$fail->[1]/, 'various ways to fail');
}

SKIP: {
    skip 'Jcode not installed', 1 unless $Date::Japanese::Era::Have_Jcode;
    my $utf8 = "\xe6\x98\xad\xe5\x92\x8c";	# 炯下
    Date::Japanese::Era->codeset('utf8');
    my $era = Date::Japanese::Era->new($utf8, 52);
    ok($era->name eq $utf8, 'input / output UTF-8');
};





