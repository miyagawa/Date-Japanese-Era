package Date::Japanese::Era;

use strict;
use vars qw($VERSION);
$VERSION = '0.02';

use Carp;
use constant END_OF_LUNAR => 1872;

use vars qw(@ISA @EXPORT %ERA_TABLE %ERA_JA2ASCII %ERA_ASCII2JA);

use vars qw($Have_Jcode);
BEGIN {
    $Have_Jcode = 0;
    eval { require Jcode; $Have_Jcode++; };
}

{
    my $codeset = 'euc';
    sub codeset {
	my $proto = shift;
	if (@_) {
	    carp "Jcode is required to modify codeset. Ignored."
		unless $Have_Jcode;
	    $codeset = shift;
	}
	$codeset;
    }
}

sub import {
    my $self = shift;
    if (@_) {
	my $table = shift;
	eval qq{use Date::Japanese::Era::Table::$table};
	die $@ if $@;
    }
    else {
	require Date::Japanese::Era::Table;
	import Date::Japanese::Era::Table;
    }
}

sub new {
    my($class, @args) = @_;
    my $self = bless {
	name => undef,
	year => undef,
	gregorian_year => undef,
    }, $class;

    if (@args == 3) {
	$self->_from_ymd(@args);
    }
    elsif (@args == 2) {
	$self->_from_era(@args);
    }
    else {
	croak "odd number of arguments: @args";
    }
    return $self;
}

sub _from_ymd {
    my($self, @ymd) = @_;

    if ($ymd[0] <= END_OF_LUNAR) {
	Carp::carp("In $ymd[0] they didn't use gregorious date.");
    }

    require Date::Calc;		# not 'use'
    *Delta_Days = \&Date::Calc::Delta_Days;

    # XXX can be more efficient
    for my $era (keys %ERA_TABLE) {
	my $data = $ERA_TABLE{$era};
	if (Delta_Days(@{$data}[1..3], @ymd) >= 0 &&
            Delta_Days(@ymd, @{$data}[4..6]) >= 0) {
	    $self->{name} = $era;
	    $self->{year} = $ymd[0] - $data->[1] + 1;
	    $self->{gregorian_year} = $ymd[0];
	    return;
	}
    }

    croak "Unsupported date: ", join('-', @ymd);
}

sub _from_era {
    my($self, $era, $year) = @_;
    if ($era =~ /^\w+$/) {
	$era = $self->_ascii2ja($era);
    }
    elsif ($Have_Jcode) {
	$era = Jcode->new($era, $self->codeset)->euc;
    }

    unless (exists $ERA_TABLE{$era}) {
	croak "Unknown era name: $era";
    }
    my $data = $ERA_TABLE{$era};
    my $g_year = $data->[1] + $year - 1;
    if ($g_year > $data->[4]) {
	croak "Invalid combination of era and year: $era-$year";
    }

    $self->{name} = $era;
    $self->{year} = $year;
    $self->{gregorian_year} = $g_year;
}

sub _ascii2ja {
    my($self, $ascii) = @_;
    return $ERA_ASCII2JA{$ascii} || croak "Unknown era name: $ascii";
}

sub _ja2ascii {
    my($self, $ja) = @_;
    return $ERA_JA2ASCII{$ja} || croak "Unknown era name: $ja";
}

sub name {
    my $self = shift;
    if ($Have_Jcode) {
	my $encoding = $self->codeset;
	return Jcode->new($self->{name}, 'euc')->$encoding();
    }
    return $self->{name};
}

*gengou = \&name;

sub name_ascii {
    my $self = shift;
    return $self->_ja2ascii($self->name);
}

sub year {
    my $self = shift;
    return $self->{year};
}

sub gregorian_year {
    my $self = shift;
    return $self->{gregorian_year};
}

1;
__END__

=head1 NAME

Date::Japanese::Era - Conversion between Japanese Era / Gregorian calendar

=head1 SYNOPSIS

  use Date::Japanese::Era;

  # from Gregorian (month + day required)
  $era = Date::Japanese::Era->new(1970, 1, 1);

  # from Japanese Era
  $era = Date::Japanese::Era->new('¾¼ÏÂ', 52);

  $name      = $era->name;         # '¾¼ÏÂ' in EUC-jp (default)
  $gengou    = $era->gengou;       # same

  $year      = $era->year;	   # 52
  $gregorian = $era->gregorian_year;  	   # 1977

  # use JIS X0301 table for conversion
  use Date::Japanese::Era 'JIS_X0301';


=head1 DESCRIPTION

Date::Japanese::Era handles conversion between Japanese Era and
Gregorian calendar.

=head1 METHODS

=over 4

=item codeset

  $codeset = Date::Japanese::Era->codeset;
  Date::Japanese::Era->codeset($encoding);

sets / gets external encoding of Japanese era names. For example with
the following code, input and output of era names are encoded in UTF-8.

  Date::Japanese::Era->codeset('utf8');
  $era = Date::Japanese::Era->new($name, $year); # $name is UTF-8
  print $era->name;                              # also UTF-8

You need Jcode module installed to make use of this
feature. Otherwise, calls to codeset() are simply ignored (with
warning).

=item new

  $era = Date::Japanese::Era->new($year, $month, $day);
  $era = Date::Japanese::Era->new($era_name, $year);

Constructs new Date::Japanese::Era instance. When constructed from
Gregorian date, month and day is required. You need Date::Calc to
construct from Gregorian.

Name of era can be either of Japanese / ASCII. Input encodings can be
specified via codeset(), suppose you have Jcode module
installed. Default is EUC-JP.

Exceptions are thrown when inputs are invalid (e.g: non-existent
era name and year combination, unknwon era-name, etc.).

=item name

  $name = $era->name;

returns era name in Japanese. Encoding can be specified via codeset()
class method. Default is EUC-JP.

=item gengou

alias for name().

=item name_ascii

  $name_ascii = $era->name_ascii;

returns era name in US-ASCII.

=item year

  $year = $era->year;

returns year as Japanese era.

=item gregorian_year

  $year = $era->gregorian_year;

returns year as Gregorian.

=back

=head1 EXAMPLES

  use Date::Japanese::Era;

  # 2001 is H-13
  my $era = Date::Japanese::Era->new(2001, 8, 31);
  printf "%s-%s", uc(substr($era->name_ascii, 0, 1)), $era->year;

  # to Gregorian
  my $era = Date::Japanese::Era->new('Ê¿À®', 13);
  print $era->gregorian_year;	# 2001

=head1 CAVEATS

=over 4

=item *

Currently supported era is up to 'meiji'. And before Meiji 05.12.02,
gregorius calendar was not used there, but lunar calendar was. This
module does not support lunar calendar, but gives warnings in such
cases ("In %d they didn't use gregorius calendar").

=item *

There should be discussion how we handle the exact day the era has
changed (former one or latter one?). This module default handles the
day as newer one, but you can change so that it sticks to JIS table
(older one) by saying:

  use Date::Japanese::Era 'JIS_X0301';

For example, 1912-07-30 is handled as:

  default	Taishou 1 07-30
  JIS_X0301	Meiji 45 07-30

=item *

If someday current era (heisei) is changed, Date::Japanese::Era::Table
should be upgraded.

=back

=head1 TODO

=over 4

=item *

Date parameters can be in various format. I should replace
Date::Simple or whatever for that.

=item *

Support earlier eras and lunar calendar.

=back

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Date::Calc>, L<Jcode>, L<Date::Simple>

=cut
