use strict;
use Test::More;
use Test::More::UTF8;

use lib 'lib';
use Date::Japanese::Era 'UTF8';

use utf8;

my @tests1 = (
    [ 2019, 4, 30, '平成', 31 ],
    [ 2019, 5, 1, '平成', 31 ],   # -- until 2019/04/30
#    [ 2019, 5, 1, '', 1 ],      # ++ until 2019/04/30
    [ 2020, 1, 1, '平成', 32 ]    # -- until 2019/04/30
#    [ 2020, 1, 1, '', 2 ]       # ++ until 2019/04/30
);

for my $test (@tests1) {
    my( $year, $month, $day, $name, $era_year ) = @$test;
    my $e1 = Date::Japanese::Era->new( $year, $month, $day );
    is $e1->name, $name, 'name';
    is $e1->year, $era_year, 'year';
    note "Gregorian to Japanese era: $year/$month/$day => $name${\$era_year}年${\$month}月${\$day}日";

    my $e2 = Date::Japanese::Era->new( $name, $era_year );
    is $e2->gregorian_year, $year, "Japanese era to Gregorian: $name${\$era_year}年${\$month}月${\$day}日 => $year/$month/$day";
}

my @tests2 = (
    [ 1872, '明治', 2, 'M', 'メイジ' ],
    [ 1913, '大正', 2, 'T', 'タイショウ' ],
    [ 1927, '昭和', 2, 'S', 'ショウワ' ],
    [ 1990, '平成', 2, 'H', 'ヘイセイ' ],
#    [ 2020, '', 2, '', '' ],   # to be upgraded until 2019/04/30
);

for my $test (@tests2) {
    my( $year, $name, $era_year, $initial, $kana ) = @$test;
    my $e3 = Date::Japanese::Era->new( $name, $era_year );
    is $e3->year, $era_year, "$name${\$era_year}年は${\$year}年";
    is $e3->name_initial, $initial, "頭文字は" . $e3->name_initial;
    is $e3->name_kana, $kana, "読みは" . $e3->name_kana;
}






done_testing;

