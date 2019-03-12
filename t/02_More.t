use strict;
use Test::More;
use Test::More::UTF8;

use lib 'lib';
use Date::Japanese::Era 'UTF8';

use utf8;

my @tests = (
    [ 2019, 4, 30, '平成', 31 ],
    [ 2019, 5, 1, '平成', 31 ],   # -- until 2019/04/30
#    [ 2019, 5, 1, '', 1 ],      # ++ until 2019/04/30
    [ 2020, 1, 1, '平成', 32 ]    # -- until 2019/04/30
#    [ 2020, 1, 1, '', 2 ]       # ++ until 2019/04/30
);

for my $test (@tests) {
    my( $year, $month, $day, $name, $era_year ) = @$test;
    my $e1 = Date::Japanese::Era->new( $year, $month, $day );
    is $e1->name, $name, 'name';
    is $e1->year, $era_year, 'year';
    note "Gregorian to Japanese era: $year/$month/$day => $name${\$era_year}年${\$month}月${\$day}日";

    my $e2 = Date::Japanese::Era->new($name, $era_year);
    is $e2->gregorian_year, $year, "Japanese era to Gregorian: $name${\$era_year}年${\$month}月${\$day}日 => $year/$month/$day";
}

done_testing;

