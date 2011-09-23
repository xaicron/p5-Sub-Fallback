use strict;
use warnings;
use Test::More;
use Test::Flatten;
use Sub::Fallback;

subtest 'fallback' => sub {
    my $res = fallback [
        sub { die 'scalar' },
        sub { 'scalar' },
    ];
    is $res, 'scalar', 'scalar';

    my @res = fallback [
        sub { die 'wantarray' },
        sub { qw/a b/ },
    ];
    is_deeply \@res, [qw/a b/], 'wantarray';

    fallback [
        sub { die 'void' },
        sub {},
    ];
    pass 'void';
};

subtest 'failed' => sub {
    local $@;
    my $res = eval {
        fallback [
            sub { die 'scalar'  },
            sub { die 'scalar2' },
        ];
    };
    ok !$res, 'returned scalar';
    like $@, qr/scalar2/, 'exception (scalar)';

    my @res = eval {
        fallback [
            sub { die 'wantarray'  },
            sub { die 'wantarray2' },
        ]; 
    };
    ok !scalar @res, 'returned wantarray';
    like $@, qr/wantarray2/, 'exception (wantarray)';

    $@ = undef;
    eval {
        fallback [
            sub { die 'void'  },
            sub { die 'void2' },
        ];
    };
    pass 'passed void';
    like $@, qr/void2/, 'exception (void)';
};

done_testing;
