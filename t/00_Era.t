use strict;
use Test::More;

BEGIN { use_ok('Date::Japanese::Era'); }

use utf8;

my @tests = (
    [ 2020, 1, 1, '令和', 2 ],
    [ 2019, 5, 1, '令和', 1 ],
    [ 2019, 4, 30, '平成', 31 ],
    [ 2001, 9, 1, '平成', 13 ],
    [ 1989, 1, 8, '平成', 1 ],
    [ 1989, 1, 7, '昭和', 64 ],
    [ 1977, 9, 12, '昭和', 52 ],
    [ 1926, 12, 25, '昭和', 1 ],
    [ 1926, 12, 24, 'taishou', 15 ],
    [ 1912, 7, 30, 'taishou', 1 ],
    [ 1912, 7, 29, 'meiji', 45 ],
    [ 1873, 1, 1, 'meiji', 6 ]
);

for my $test (@tests) {
    my($year, $month, $day, $name, $era_year) = @$test;
    my $e1 = Date::Japanese::Era->new($year, $month, $day);
    if ($name =~ /^[a-zA-Z]+$/) {
	is($e1->name_ascii, $name, 'Gregorian to Japanese era (ASCII)');
    }
    else {
	is($e1->name, $name, 'Gregorian to Japanese era');
    }
    is($e1->year, $era_year);

    my $e2 = Date::Japanese::Era->new($name, $era_year);
    is($e2->gregorian_year, $year, 'Japanese era to Gregorian');
}


# fail tests
my @fail = (
    [ [],  'odd number of arguments: ' ],
    [ [ 'xxx', 1 ], 'Unknown era name: ' ],
    [ [ '慶応', 12 ], 'Unknown era name: ' ],
    [ [ '昭和', 65 ], 'Invalid combination of era and year: ' ],
    [ [ 1868, 9, 7 ], 'Unsupported date: ' ],
    [ [ 2000, -1, -1 ], 'not a valid date' ], # XXX depends on D::Calc
);

for my $fail (@fail) {
    local $SIG{__WARN__} = sub {};
    eval {
	my $u = Date::Japanese::Era->new(@{$fail->[0]});
    };
    like($@, qr/$fail->[1]/, 'various ways to fail');
}

{
    my @era;
    push @era, Date::Japanese::Era->new('昭和52年');
    push @era, Date::Japanese::Era->new('昭和52');
    push @era, Date::Japanese::Era->new('昭和５２年');
    push @era, Date::Japanese::Era->new('昭和５２');
    push @era, Date::Japanese::Era->new('昭和五十二年');
    push @era, Date::Japanese::Era->new('昭和五十二');

    for my $e (@era) {
        is $e->name, '昭和';
        is $e->year, 52;
    }
}

{
    my $era = Date::Japanese::Era->new('令和元年');
    is $era->name, '令和';
    is $era->year, 1;
    is $era->gregorian_year, 2019;
}

done_testing;

