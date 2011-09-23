package Sub::Fallback;

use strict;
use warnings;
use 5.008_001;
use parent 'Exporter';
use Carp ();

our $VERSION = '0.01';

our @EXPORT = qw(fallback);

sub fallback {
    my ($callbacks, $fallback_if) = @_;
    my $wantarray = wantarray;
    Carp::croak('Usage: fallback($callbacks, $fallback_if)')
        unless ref $callbacks eq 'ARRAY' || ref $callbacks eq 'CODE';
    $callbacks = [$callbacks] if ref $callbacks eq 'CODE';

    my $err;
    $fallback_if ||= sub { $err = $@ };
    for my $cb (@$callbacks) {
        if ($wantarray) {
            my @res = eval { $cb->() };
            unless ($fallback_if->(@res)) {
                return @res;
            }
        }
        elsif (not defined $wantarray) {
            eval { $cb->() };
            unless ($fallback_if->()) {
                return;
            }
        }
        else {
            my $res = eval { $cb->() };
            unless ($fallback_if->($res)) {
                return $res;
            }
        }
    }
    Carp::croak($err) if $err;

    return;
}

1;
__END__

=encoding utf-8

=for stopwords

=head1 NAME

Sub::Fallback -

=head1 SYNOPSIS

  use Sub::Fallback;

=head1 DESCRIPTION

Sub::Fallback is

=head1 AUTHOR

xaicron E<lt>xaicron {at} cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2011 - xaicron

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
