requires 'perl', '5.008001';
requires 'Date::Calc', 4.3;
requires 'Encode' => 2.1;
requires 'Lingua::JA::Numbers' => 0.04;
requires 'Time::Piece';

on test => sub {
    requires 'Test::More';
    requires 'Test::More::UTF8';
};
