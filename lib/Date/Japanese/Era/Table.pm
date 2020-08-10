package Date::Japanese::Era::Table;

use utf8;
use strict;
our $VERSION = '0.04';

require Exporter;
our @ISA    = qw(Exporter);
our @EXPORT = qw(%ERA_TABLE %ERA_JA2ASCII %ERA_ASCII2JA %NEXT %PREV);

our %ERA_TABLE = (

    # era => [ $ascii, @begin_ymd, @end_ymd ]
    "明治" => [ 'meiji',   1868, 9,  8,  1912, 7,  29 ],
    "大正" => [ 'taishou', 1912, 7,  30, 1926, 12, 24 ],
    "昭和" => [ 'shouwa',  1926, 12, 25, 1989, 1,  7 ],
    "平成" => [ 'heisei',  1989, 1,  8,  2019, 4,  30 ],
    "令和" => [ 'reiwa',   2019, 5,  1,  2999, 12, 31 ],    # XXX
);

our %ERA_JA2ASCII = map { $_ => $ERA_TABLE{$_}->[0] } keys %ERA_TABLE;
our %ERA_ASCII2JA = reverse %ERA_JA2ASCII;

our ( %NEXT, %PREV );
my @order = sort { $ERA_TABLE{$a}[1] <=> $ERA_TABLE{$b}[1] } keys %ERA_TABLE;
for ( my $i = 0; $i < @order; $i++ ) {
    $NEXT{ $order[$i] } = $order[ $i + 1 ] if $i + 1 <= @order;
    $PREV{ $order[$i] } = $order[ $i - 1 ] if $i > 0 and $i - 1 <= @order;
}

1;
__END__

=head1 NAME

Date::Japanese::Era::Table - Conversion Table for Date::Japanese::Era

=head1 SYNOPSIS

B<DO NOT USE THIS MODULE DIRECTLY>

=head1 DESCRIPTION

This module defines conversion table used by Date::Japanese::Era.

=head1 AUTHOR

Tatsuhiko Miyagawa E<lt>miyagawa@bulknews.netE<gt>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<Date::Japanese::Era>

=cut
