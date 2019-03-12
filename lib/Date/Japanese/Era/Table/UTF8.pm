package Date::Japanese::Era::Table::UTF8;

use strict;
use utf8;

our $VERSION = '0.01';

our (
    %ERA_TABLE, %ERA_TABLE_MORE, %ERA_JA2ASCII, %ERA_ASCII2JA,
    %ERA_JA2ROMAN, %ERA_ROMAN2JA, %ERA_JA2KANA, %ERA_KANA2JA
);

use base 'Exporter';
our @EXPORT = qw(
    %ERA_TABLE %ERA_TABLE_MORE %ERA_JA2ASCII %ERA_ASCII2JA
    %ERA_JA2ROMAN %ERA_ROMAN2JA %ERA_JA2KANA %ERA_KANA2JA
);

my $newone = '新元号'; # replace it on 2019/04/01

%ERA_TABLE_MORE = (
    '明治' => {
        kana => 'メイジ', roman => 'meiji',
        start => [ 1868, 9, 8 ],
        end => [ 1912, 7, 29 ]
    },
    '大正' => {
        kana => 'タイショウ', roman => 'taishou',
        start => [ 1912, 7, 30],
        end => [ 1926, 12, 24 ]
    },
    '昭和' => {
        kana => 'ショウワ', roman => 'shouwa',
        start => [ 1926, 12, 25],
        end => [ 1989, 1, 7 ]
    },
    '平成' => {
        kana => 'ヘイセイ', roman => 'heisei',
        start => [ 1989, 1, 8],
        end => [ 2019, 4, 30 ]
    },
#### replace it on 2019/04/01
    $newone => {
        kana => undef, roman => undef,
        start => [ 2019, 5, 1],
        end => undef
    }, # XXX
#### the end of to be replased
);
delete $ERA_TABLE_MORE{$newone};   #### this must to be deleted on 2019/04/01

while( my( $key,  $ref ) = each %ERA_TABLE_MORE ) {
    $ref->{initial} = uc substr $ref->{'roman'}, 0, 1;
    
    $ERA_TABLE{$key} = [
        $ref->{'roman'} || 'heisei',    #### this must to be edited on 2019/04/01
        @{$ref->{'start'}},
        @{$ref->{'end'} || [ 2999, 12, 31 ] }
    ];
    
    if( $ref->{'roman'} ) {
        $ERA_JA2ASCII{$key} = $ERA_JA2ROMAN{$key} = $ref->{'roman'};
        $ERA_ASCII2JA{$ref->{'roman'}} = $ERA_ROMAN2JA{$ref->{'roman'}} = $key;
    }
    if( $ref->{'kana'} ) {
        $ERA_JA2KANA{$key} = $ref->{'kana'};
        $ERA_KANA2JA{$ref->{'kana'}} = $key;
    }
}
#### delete these lines on 2019/04/01
 splice @{$ERA_TABLE{'平成'}}, -3, 3, ( 2999, 12, 31 )
unless defined $ERA_TABLE_MORE{$newone}{'roman'};
#### the end of to be deleted

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
