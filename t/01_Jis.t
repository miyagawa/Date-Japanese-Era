use strict;
use Test::More tests => 27;

use Date::Japanese::Era 'JIS_X0301';

my @tests = (
    [ 2001, 9, 1, 'ʿ��', 13 ],
    [ 1989, 1, 8, 'ʿ��', 1 ],
    [ 1989, 1, 7, '����', 64 ],
    [ 1977, 9, 12, '����', 52 ],
    [ 1926, 12, 26, '����', 1 ],
    [ 1926, 12, 25, 'taishou', 15 ],
    [ 1912, 7, 31, 'taishou', 1 ],
    [ 1912, 7, 30, 'meiji', 45 ],
    [ 1873, 1, 1, 'meiji', 6 ]
);

for my $test (@tests) {
    my($year, $month, $day, $name, $era_year) = @$test;
    my $e1 = Date::Japanese::Era->new($year, $month, $day);
    if ($name =~ /^\w+$/) {
	is($e1->name_ascii, $name, 'Gregorian to Japanese era (ASCII)');
    }
    else {
	is($e1->name('euc'), $name, 'Gregorian to Japanese era');
    }
    is($e1->year, $era_year);

    my $e2 = Date::Japanese::Era->new($name, $era_year);
    is($e2->gregorian_year, $year, 'Japanese era to Gregorian');
}




