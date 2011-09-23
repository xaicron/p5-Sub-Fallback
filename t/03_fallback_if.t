use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Sub::Fallback;

subtest 'fallback' => sub {
    my $res = fallback [
        sub { 0 },
        sub { 1 },
    ], sub { my $res = shift; $res ? 0 : 1 };
    is $res, 1, 'scalar';

    my @res = fallback [
        sub { qw/a b/ },
        sub { qw/c d/ },
    ], sub { (grep /c/ => @_) ? 0 : 1 };
    is_deeply \@res, [qw/c d/], 'wantarray';

    my $i;
    fallback [
        sub { $i = 1 }, sub { $i = 0 },
    ], sub { $i };
    is $i, 0, 'void';
};

subtest 'failed' => sub {
    my $res = fallback [
        sub { 'foo' },
        sub { 'bar' },
    ], sub { my $res = shift; $res eq 'hoge' ? 0 : 1 };
    ok !defined $res, 'scalar';

    my @res = fallback [
        sub { qw/a b/ },
        sub { qw/c d/ },
    ], sub { (grep /f/ => @_) ? 0 : 1 };
    ok scalar @res == 0, 'wantarray';

    fallback [
        sub { 0 }, sub { 0 },
    ], sub { 1 };
    pass 'void';
};

done_testing;
