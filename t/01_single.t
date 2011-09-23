use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Sub::Fallback;

subtest 'single' => sub {
    my $res = fallback sub { 'scalar' };
    is $res, 'scalar', 'scalar';

    my @res = fallback sub { qw/a b/ };
    is_deeply \@res, [qw/a b/], 'wantarray';

    fallback sub {};
    pass 'void';
};

subtest 'failed' => sub {
    local $@;
    $@ = undef;
    my $res = eval { fallback sub { die 'scalar' } };
    ok !$res, 'returned scalar';
    like $@, qr/scalar/, 'exception (scalar)';

    $@ = undef;
    my @res = eval { fallback sub { die 'wantarray' } };
    ok !scalar @res, 'returned wantarray';
    like $@, qr/wantarray/, 'exception (wantarray)';

    $@ = undef;
    eval { fallback sub { die 'void' } };
    pass 'passed void';
    like $@, qr/void/, 'exception (void)';
};

done_testing;
