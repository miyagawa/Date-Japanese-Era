# NAME

Date::Japanese::Era - Conversion between Japanese Era / Gregorian calendar

# SYNOPSIS

    use utf8;
    use Date::Japanese::Era;

    # from Gregorian (month + day required)
    $era = Date::Japanese::Era->new(1970, 1, 1);

    # from Japanese Era
    $era = Date::Japanese::Era->new("昭和", 52); # SHOWA

    $name      = $era->name;         # 昭和 (in Unicode)
    $gengou    = $era->gengou;       # Ditto

    $year      = $era->year;         # 52
    $gregorian = $era->gregorian_year;       # 1977

    # use JIS X0301 table for conversion
    use Date::Japanese::Era 'JIS_X0301';

    # more DWIMmy
    $era = Date::Japanese::Era->new("昭和五十二年");
    $era = Date::Japanese::Era->new("昭和52年");

# DESCRIPTION

Date::Japanese::Era handles conversion between Japanese Era and
Gregorian calendar.

# METHODS

- new

        $era = Date::Japanese::Era->new($year, $month, $day);
        $era = Date::Japanese::Era->new($era_name, $year);
        $era = Date::Japanese::Era->new($era_year_string);

    Constructs new Date::Japanese::Era instance. When constructed from
    Gregorian date, month and day is required. You need Date::Calc to
    construct from Gregorian.

    Name of era can be either of Japanese / ASCII. If you pass Japanese,
    the variable should be properly UTF-8 flaged.

    Exceptions are thrown when inputs are invalid (e.g: non-existent
    era name and year combination, unknwon era-name, etc.).

- name

        $name = $era->name;

    returns era name in Japanese in Unicode.

- gengou

    alias for name().

- name\_ascii

        $name_ascii = $era->name_ascii;

    returns era name in US-ASCII.

- year

        $year = $era->year;

    returns year as Japanese era.

- gregorian\_year

        $year = $era->gregorian_year;

    returns year as Gregorian.

# EXAMPLES

    use utf8;
    use Date::Japanese::Era;

    # 2001 is H-13
    my $era = Date::Japanese::Era->new(2001, 8, 31);
    printf "%s-%s", uc(substr($era->name_ascii, 0, 1)), $era->year;

    # to Gregorian
    my $era = Date::Japanese::Era->new("平成", 13); # HEISEI 13
    print $era->gregorian_year;   # 2001

# CAVEATS

- Currently supported era is up to 'meiji'. And before Meiji 05.12.02,
gregorius calendar was not used there, but lunar calendar was. This
module does not support lunar calendar, but gives warnings in such
cases ("In %d they didn't use gregorius calendar").

    To use calendar ealier than that, see
    [DateTime::Calendar::Japanese::Era](https://metacpan.org/pod/DateTime::Calendar::Japanese::Era), which is based on DateTime
    framework and is more comprehensive.

- There should be discussion how we handle the exact day the era has
changed (former one or latter one?). This module default handles the
day as newer one, but you can change so that it sticks to JIS table
(older one) by saying:

        use Date::Japanese::Era 'JIS_X0301';

    For example, 1912-07-30 is handled as:

        default       Taishou 1 07-30
        JIS_X0301     Meiji 45 07-30

- If someday current era (heisei) is changed, Date::Japanese::Era::Table
should be upgraded.

# AUTHOR

Tatsuhiko Miyagawa <miyagawa@bulknews.net>

# COPYRIGHT

Tatsuhiko Miyagawa, 2001-

# LICENSE

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

# SEE ALSO

[DateTime::Calendar::Japanese::Era](https://metacpan.org/pod/DateTime::Calendar::Japanese::Era), [Date::Calc](https://metacpan.org/pod/Date::Calc), [Encode](https://metacpan.org/pod/Encode)
